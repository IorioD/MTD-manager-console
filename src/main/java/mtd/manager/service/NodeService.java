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
import org.springframework.stereotype.Service;

import com.google.gson.reflect.TypeToken;

import io.kubernetes.client.openapi.ApiClient;
import io.kubernetes.client.openapi.Configuration;
import io.kubernetes.client.openapi.apis.CoreV1Api;
import io.kubernetes.client.openapi.models.V1Node;
import io.kubernetes.client.openapi.models.V1NodeAddress;
import io.kubernetes.client.openapi.models.V1NodeCondition;
import io.kubernetes.client.openapi.models.V1NodeStatus;
import io.kubernetes.client.openapi.models.V1ObjectMeta;
import io.kubernetes.client.util.Config;
import io.kubernetes.client.util.Watch;

import jakarta.annotation.PostConstruct;

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

    @PostConstruct
    public void init() {
        try {
            initialSyncNodes();

            new Thread(() -> {
                try {
                    watchNodes();
                } catch (Exception e) {
                    System.err.println("Error watching Kubernetes nodes: " + e.getMessage());
                    e.printStackTrace();
                }
            }, "k8s-node-watch-thread").start();
        } catch (Exception e) {
            System.err.println("Error initializing NodeService: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Initial sync of existing nodes to populate the database
    public void initialSyncNodes() throws Exception {
        ApiClient client = Config.defaultClient();
        Configuration.setDefaultApiClient(client);

        CoreV1Api api = new CoreV1Api();
        var nodeList = api.listNode(null, null, null, null,
                                    null, null, null, null,
                                    null, false);

        if (nodeList == null || nodeList.getItems() == null) return;

        for (V1Node node : nodeList.getItems()) {
            upsertNode(node);
        }

        System.out.println("Initial Kubernetes nodes sync completed.");
    }
    
    // Watch for node changes in Kubernetes
    private void upsertNode(V1Node nodeV1) {
        if (nodeV1 == null) return;

        // NODE NAME
        String hostname = Optional.ofNullable(nodeV1.getMetadata())
                .map(V1ObjectMeta::getName)
                .orElse("unknown");

        // NODE IP
        String ip = Optional.ofNullable(nodeV1.getStatus())
                .map(V1NodeStatus::getAddresses)
                .orElse(Collections.emptyList())
                .stream()
                .filter(addr -> "InternalIP".equals(addr.getType()))
                .findFirst()
                .map(V1NodeAddress::getAddress)
                .orElse("N/A");

        // ROLE
        String role = Optional.ofNullable(nodeV1.getMetadata())
                .map(V1ObjectMeta::getLabels)
                .map(labels -> labels.keySet().stream()
                        .filter(k -> k.startsWith("node-role.kubernetes.io/"))
                        .findFirst()
                        .map(k -> k.replace("node-role.kubernetes.io/", ""))
                        .orElse("worker"))
                .orElse("worker");
        // TYPE
        String type = (role.equals("control-plane") || role.equals("master") || role.equals("worker"))
                ? CLOUD : EDGE;

        // STATUS
        String status = Optional.ofNullable(nodeV1.getStatus())
                .map(V1NodeStatus::getConditions)
                .orElse(Collections.emptyList())
                .stream()
                .filter(cond -> "Ready".equals(cond.getType()))
                .findFirst()
                .map(V1NodeCondition::getStatus)
                .orElse("Unknown");

        // DB ADD/UPDATE
        Node node = nodeRepository.findByIpAddress(ip).orElse(new Node());
        node.setHostname(hostname);
        node.setIpAddress(ip);
        node.setRole(role);
        node.setType(type);
        node.setAvailable(status);

        nodeRepository.save(node);
    }

    // Watch for node changes in Kubernetes
    private void watchNodes() throws Exception {
        ApiClient client = Config.defaultClient();
        Configuration.setDefaultApiClient(client);
        CoreV1Api api = new CoreV1Api();

        TypeToken<Watch.Response<V1Node>> typeToken = new TypeToken<Watch.Response<V1Node>>() {};

        try (Watch<V1Node> watch = Watch.createWatch(
                client,
                api.listNodeCall(null, null, null, 
                        null, null, null, 
                        null, null, null, true, null),
                typeToken.getType())) {

            for (Watch.Response<V1Node> event : watch) {
                V1Node node = event.object;
                switch (event.type) {
                    case "ADDED":
                    case "MODIFIED":
                        upsertNode(node);
                        break;
                    case "DELETED":
                        String ip = Optional.ofNullable(node.getStatus())
                                .map(V1NodeStatus::getAddresses)
                                .orElse(Collections.emptyList())
                                .stream()
                                .filter(addr -> "InternalIP".equals(addr.getType()))
                                .findFirst()
                                .map(V1NodeAddress::getAddress)
                                .orElse(null);

                        if (ip != null) {
                            nodeRepository.findByIpAddress(ip)
                                    .ifPresent(nodeRepository::delete);
                        }
                        break;
                }
            }
        }
    }
}
