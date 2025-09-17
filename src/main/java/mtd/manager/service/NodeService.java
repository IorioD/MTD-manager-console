package mtd.manager.service;

import mtd.manager.dto.NodeDTO;
import mtd.manager.entity.Node;
import mtd.manager.repository.NodeRepository;
import mtd.manager.vo.NodeQueryVO;
import mtd.manager.vo.NodeUpdateVO;
import mtd.manager.vo.NodeVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import io.kubernetes.client.openapi.ApiClient;
import io.kubernetes.client.openapi.Configuration;
import io.kubernetes.client.openapi.apis.CoreV1Api;
import io.kubernetes.client.openapi.models.V1Node;
import io.kubernetes.client.openapi.models.V1NodeAddress;
import io.kubernetes.client.openapi.models.V1NodeCondition;
import io.kubernetes.client.openapi.models.V1NodeList;
import io.kubernetes.client.openapi.models.V1NodeStatus;
import io.kubernetes.client.openapi.models.V1ObjectMeta;
import io.kubernetes.client.util.Config;

import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;
import java.util.Collections;

@Service
public class NodeService {

    public static final String CLOUD = "cloud";
    public static final String EDGE = "edge";
    @Autowired
    private NodeRepository nodeRepository;

    public Long save(NodeVO vO) {
        Node bean = new Node();
        BeanUtils.copyProperties(vO, bean);
        bean = nodeRepository.save(bean);
        return bean.getId();
    }

    public void delete(Long id) {
        nodeRepository.deleteById(id);
    }

    public void update(NodeUpdateVO vO) {
        Node bean = requireOne(vO.getId());
        BeanUtils.copyProperties(vO, bean);
        nodeRepository.save(bean);
    }

    public NodeDTO getById(Long id) {
        Node original = requireOne(id);
        return toDTO(original);
    }

    public Page<NodeDTO> query(NodeQueryVO vO) {
        throw new UnsupportedOperationException();
    }

    private NodeDTO toDTO(Node original) {
        NodeDTO bean = new NodeDTO();
        BeanUtils.copyProperties(original, bean);
        return bean;
    }

    private Node requireOne(Long id) {
        return nodeRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Resource not found: " + id));
    }

    public List<NodeDTO> findAll() {
        List<NodeDTO> list = new ArrayList<>();
        nodeRepository.findAll().forEach(node -> list.add(toDTO(node)));
        return list;
    }

    public List<NodeDTO> findAllCloudNode() {
        List<NodeDTO> list = new ArrayList<>();
        nodeRepository.findAllByType(CLOUD).forEach(node -> list.add(toDTO(node)));
        return list;
    }

    public List<NodeDTO> findAllEdgeNode() {
        List<NodeDTO> list = new ArrayList<>();
        nodeRepository.findAllByType(EDGE).forEach(node -> list.add(toDTO(node)));
        return list;
    }

    public boolean isIpUnique(String ipAddress) {
        return !nodeRepository.existsByIpAddress(ipAddress);
    }

    public void syncNodesFromKubernetes() throws Exception {
        ApiClient client = Config.defaultClient(); // usa KUBECONFIG o in-cluster config
        Configuration.setDefaultApiClient(client);

        CoreV1Api api = new CoreV1Api();
        V1NodeList nodeList = api.listNode(null, null, null, null,
                                           null, null, null, null,
                                           null, false);

        if (nodeList == null || nodeList.getItems() == null) {
            return;
        }

        for (V1Node nodeV1 : nodeList.getItems()) {
            if (nodeV1 == null) continue;

            // NODE NAME
            V1ObjectMeta meta = nodeV1.getMetadata();
            String hostname = (meta != null) ? meta.getName() : "unknown";

            // IP ADDRESS
            String ip = Optional.ofNullable(nodeV1.getStatus())
                .map(V1NodeStatus::getAddresses)
                .orElse(Collections.emptyList())
                .stream()
                .filter(addr -> "InternalIP".equals(addr.getType()))
                .findFirst()
                .map(V1NodeAddress::getAddress)
                .orElse("N/A");
            
            // ROLE
            String role = Optional.ofNullable(meta)
                .map(V1ObjectMeta::getLabels)
                .map(labels -> labels.keySet().stream()
                        .filter(k -> k.startsWith("node-role.kubernetes.io/"))
                        .findFirst()
                        .map(k -> k.replace("node-role.kubernetes.io/", ""))
                        .orElse("worker"))
                .orElse("worker");

            // TYPE
            String type = (role.equals("control-plane") || role.equals("master") || 
                            role.equals("worker"))
                ? CLOUD : EDGE;

            // AVAILABLE
            V1NodeCondition readyCond = Optional.ofNullable(nodeV1.getStatus())
                .map(V1NodeStatus::getConditions)
                .orElse(Collections.emptyList())
                .stream()
                .filter(cond -> "Ready".equals(cond.getType()))
                .findFirst()
                .orElse(null);

            String status = (readyCond != null && "True".equals(readyCond.getStatus())) ? "Ready" : "NotReady";
            boolean available = "Ready".equals(status);

            // DB ADD/UPDATE 
            Node node = nodeRepository.findByIpAddress(ip).orElse(new Node());
            node.setHostname(hostname);
            node.setIpAddress(ip);
            node.setRole(role);
            node.setType(type);
            node.setAvailable(available);

            nodeRepository.save(node);
        }
    }

    @Scheduled(fixedRate = 3600000)
    public void scheduledSyncNodes() {
        try {
            syncNodesFromKubernetes();
            System.out.println("Kubernetes Nodes synced successfully.");
        } catch (Exception e) {
            System.err.println("Error in syncing Kubernetes Nodes: " + e.getMessage());
        }
    }
}
