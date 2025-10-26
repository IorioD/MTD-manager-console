package mtd.manager.service;

import mtd.manager.dto.ClusterDTO;
import mtd.manager.dto.ClusterDTO.NodeInfo;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponentsBuilder;

import io.kubernetes.client.openapi.ApiClient;
import io.kubernetes.client.openapi.ApiException;
import io.kubernetes.client.openapi.apis.CoreV1Api;
import io.kubernetes.client.openapi.apis.VersionApi;
import io.kubernetes.client.openapi.models.V1Node;
import io.kubernetes.client.openapi.models.V1NodeList;
import io.kubernetes.client.openapi.models.VersionInfo;
import io.kubernetes.client.openapi.Configuration;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import io.kubernetes.client.util.Config;

import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


@Service
public class ClusterService {

    private static final Logger logger = LoggerFactory.getLogger(ClusterService.class);
    private static final String PROMETHEUS_URL = "http://192.168.56.117:30090/api/v1/query";

    @SuppressWarnings("null")
    public ClusterDTO retrieveClusterInfo() throws IOException, ApiException{
        
        ClusterDTO clusterDTO = new ClusterDTO();

        // Configure client Kubernetes
        ApiClient client = Config.defaultClient();
        Configuration.setDefaultApiClient(client);

        // API version
        VersionApi versionApi = new VersionApi();
        CoreV1Api api = new CoreV1Api();

        // Cluster nodes list
        V1NodeList nodeList = api.listNode(null, null, null, null, null, null, null, null, null, false);
        List<V1Node> nodes = nodeList.getItems();

        // Obtain dynamically cluster name
        /*try{    
            V1ConfigMap configMap = api.readNamespacedConfigMap("cluster-info", "default", null, null, null);
            String clusterName = configMap.getData().get("cluster-name");
            clusterDTO.setName(clusterName);        
        } catch (ApiException e) {
            clusterDTO.setName("Unknown Cluster");
        }*/
        // NB: to use this, use a create and apply configmap like 
                            /*
                            apiVersion: v1
                            kind: ConfigMap
                            metadata:
                                name: cluster-info
                                namespace: default
                            data:
                                cluster-name: "<Cluster_name>"
                            */
        
        // Static cluster name
        clusterDTO.setName("Kubernetes Cluster");

        // API version
        try {
            VersionInfo versionInfo = versionApi.getCode();
            String apiVersion = versionInfo.getGitVersion();
            clusterDTO.setApiVersion(apiVersion);
        } catch (ApiException e) {
            clusterDTO.setApiVersion("Unknown Version");
            logger.error("Failed to retrieve API version", e);
        }

        // Nodes number
        clusterDTO.setNodeCount(nodes.size());

        Map<String, NodeInfo> nodeInfoMap = new HashMap<>();
        Map<String, String> ipToNodeNameMap = new HashMap<>();

        // Architecture and OS of each node
        if (!nodes.isEmpty()) {
            for (V1Node node : nodes) {
                String nodeName = node.getMetadata().getName();
                String architecture = node.getStatus().getNodeInfo().getArchitecture();
                String operatingSystem = node.getStatus().getNodeInfo().getOperatingSystem();

                nodeInfoMap.put(nodeName, new NodeInfo(architecture, operatingSystem));

                 node.getStatus().getAddresses().forEach(address -> {
                    if ("InternalIP".equals(address.getType())) {
                        ipToNodeNameMap.put(address.getAddress(), nodeName);
                    }
                });
            }
            clusterDTO.setNodeInfoMap(nodeInfoMap);
        } else{
            logger.warn("Cluster list is empty.");
            nodeInfoMap.put(null, new NodeInfo(null, null));
        }
        
        // Retrieve node metrics
        retrieveNodeMetrics(clusterDTO, ipToNodeNameMap);

        return clusterDTO;
    }

    private void retrieveNodeMetrics(ClusterDTO clusterDTO, Map<String, String> ipToNodeNameMap) {

        ObjectMapper objectMapper = new ObjectMapper();

        CloseableHttpClient httpClient = HttpClients.createDefault();
    
        // Query for CPU use
        String cpuQuery = "100 - (avg by (instance) (rate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)";
        String cpuUrl = UriComponentsBuilder.fromHttpUrl(PROMETHEUS_URL).queryParam("query", cpuQuery).build().encode().toUriString();

        // Query for memory use
        String memoryQuery = "avg by (instance) (node_memory_MemAvailable_bytes) / avg by (instance) (node_memory_MemTotal_bytes) * 100";
        String memUrl = UriComponentsBuilder.fromHttpUrl(PROMETHEUS_URL).queryParam("query", memoryQuery).build().encode().toUriString();

        // Query for disk use
        String diskQuery = "100 - (avg by (instance) (node_filesystem_free_bytes{fstype!=\"tmpfs\",fstype!=\"overlay\"}) / avg by (instance) (node_filesystem_size_bytes{fstype!=\"tmpfs\",fstype!=\"overlay\"})) * 100";
        String diskUrl = UriComponentsBuilder.fromHttpUrl(PROMETHEUS_URL).queryParam("query", diskQuery).build().encode().toUriString();
        
        // Metrics map
        Map<String, ClusterDTO.NodeMetrics> nodeMetricsMap = new HashMap<>();

        fetchAndProcessMetrics(cpuUrl, "cpuUsage", nodeMetricsMap, objectMapper, httpClient, ipToNodeNameMap);
        fetchAndProcessMetrics(memUrl, "memUsage", nodeMetricsMap, objectMapper, httpClient, ipToNodeNameMap);
        fetchAndProcessMetrics(diskUrl, "diskUsage", nodeMetricsMap, objectMapper, httpClient, ipToNodeNameMap);

        clusterDTO.setNodeMetricsMap(nodeMetricsMap);
    }

    private void fetchAndProcessMetrics(String url, String metricType, Map<String, ClusterDTO.NodeMetrics> nodeMetricsMap, 
                                        ObjectMapper objectMapper, CloseableHttpClient httpClient, Map<String, String> ipToNodeNameMap) {
        try (CloseableHttpResponse response = httpClient.execute(new HttpGet(url))) {
            int statusCode = response.getStatusLine().getStatusCode();
            String responseBody = EntityUtils.toString(response.getEntity());
    
            if (statusCode >= 200 && statusCode < 300) {
                logger.info("Prometheus response: OK");// + responseBody);
            } else {
                logger.error("Failed to retrieve metrics: HTTP " + statusCode + ", Response: " + responseBody);
                return;
            }
    
            JsonNode root = objectMapper.readTree(responseBody);
            JsonNode data = root.path("data").path("result");
    
            for (JsonNode node : data) {

                String instance = node.path("metric").path("instance").asText(); // es. "192.168.1.37:9100"
                String ip = instance.split(":")[0];
                String nodeName = ipToNodeNameMap.get(ip);

                if (nodeName == null) {
                    logger.warn("No Kubernetes node found for instance {}", instance);
                    continue;
                }
                
                String metricValueStr = node.path("value").get(1).asText();
                BigDecimal metricValue = new BigDecimal(metricValueStr).setScale(2, RoundingMode.HALF_UP);
                
                logger.info("Processing metrics for node: " + nodeName + ", metricType: " + metricType + ", value: " + metricValue);

                nodeMetricsMap.putIfAbsent(nodeName, new ClusterDTO.NodeMetrics());
    
                switch (metricType) {
                    case "cpuUsage":
                        nodeMetricsMap.get(nodeName).setCpuUsage(formatValue(metricType, metricValue));
                        break;
                    case "memUsage":
                        nodeMetricsMap.get(nodeName).setMemUsage(formatValue(metricType, metricValue));
                        break;
                    case "diskUsage":
                        nodeMetricsMap.get(nodeName).setDiskUsage(formatValue(metricType, metricValue));
                        break;
                }
            }
        } catch (Exception e) {
            logger.error("Failed to retrieve metrics from Prometheus", e);
        }
    }

    private String formatValue(String metricType, BigDecimal value) {
        if (value != null) {
            switch (metricType) {
                case "cpuUsage":
                case "diskUsage":
                    return value.toString() + " %";
                case "memUsage":
                    return value.toString() + " %";
                default:
                    return value.toString(); // fallback in case metricType is unknown
            }
        }
        return "N/D"; // fallback if value is null or empty
    }
}