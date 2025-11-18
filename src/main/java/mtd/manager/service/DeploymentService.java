package mtd.manager.service;

import mtd.manager.dto.DeploymentDTO;
import mtd.manager.entity.Deployment;
import mtd.manager.repository.DeploymentRepository;
import mtd.manager.vo.DeploymentUpdateVO;
import mtd.manager.vo.DeploymentVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.gson.reflect.TypeToken;

import io.kubernetes.client.openapi.ApiClient;
import io.kubernetes.client.openapi.Configuration;
import io.kubernetes.client.openapi.apis.AppsV1Api;
import io.kubernetes.client.openapi.models.V1Deployment;
import io.kubernetes.client.openapi.models.V1DeploymentCondition;
import io.kubernetes.client.openapi.models.V1DeploymentStatus;
import io.kubernetes.client.openapi.models.V1ObjectMeta;
import io.kubernetes.client.util.Config;
import io.kubernetes.client.util.Watch;
import okhttp3.Call;

import jakarta.annotation.PostConstruct;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;
import java.util.Collections;

@Service
public class DeploymentService {

    @Autowired
    private DeploymentRepository deploymentRepository;

    public String save(DeploymentVO vO) {
        Deployment bean = new Deployment();
        BeanUtils.copyProperties(vO, bean);
        bean = deploymentRepository.save(bean);
        return bean.getName();
    }

    public void delete(Long id) {
        deploymentRepository.deleteById(id);
    }

    public void update(DeploymentUpdateVO vO) {
        Deployment bean = requireOne(vO.getId());
        BeanUtils.copyProperties(vO, bean);
        deploymentRepository.save(bean);
    }

    public DeploymentDTO getById(Long id) {
        Deployment original = requireOne(id);
        return toDTO(original);
    }

    private DeploymentDTO toDTO(Deployment original) {
        DeploymentDTO bean = new DeploymentDTO();
        BeanUtils.copyProperties(original, bean);
        bean.setStrategy(original.getStrategy()); // Set the strategy
        bean.setEnabled(original.getEnabled());   // Set the enabled flag
        return bean;
    }

    private Deployment requireOne(Long id) {
        return deploymentRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Resource not found: " + id));
    }

    public List<DeploymentDTO> findAll() {
        List<DeploymentDTO> list = new ArrayList<>();
        deploymentRepository.findAll().forEach(depl -> list.add(toDTO(depl)));
        return list;
    }

    public void updateDeploymentStrategy(Long id, Integer strategy) {
        Deployment deployment = requireOne(id);
        deployment.setStrategy(strategy);
        deploymentRepository.save(deployment);
    }

    public void updateEnabled(Long id, boolean enabled) {
        Deployment deployment = requireOne(id);
        deployment.setEnabled(enabled);
        deploymentRepository.save(deployment);
    }

    public void toggleEnabled(Long id) {
        Deployment deployment = requireOne(id);
        deployment.setEnabled(!deployment.getEnabled());
        deploymentRepository.save(deployment);
    }

    @PostConstruct
    public void init() {
        try{
            ApiClient client = Config.defaultClient();
            Configuration.setDefaultApiClient(client);
            initialFetch(client);
                new Thread(() -> {
                        try {
                            watchDeployments(client);
                        } catch (Exception e) {
                            System.err.println("Error watching Kubernetes deployments: " + e.getMessage());
                            e.printStackTrace();
                        }
                }).start();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Initial fetch of existing deployments to populate the database
    private void initialFetch(ApiClient client) throws Exception {
        AppsV1Api api = new AppsV1Api(client);

        var deploymentList = api.listDeploymentForAllNamespaces(
                null, null, null, null, null,
                null, null, null, null, false);

        if (deploymentList == null || deploymentList.getItems() == null) return;

        for (V1Deployment deployment : deploymentList.getItems()) {
            handleDeploymentEvent("ADDED", deployment); // save DB
        }

        System.out.println("Initial deployments fetch completed, DB populated.");
    }

    // Watch for deployment changes in Kubernetes
    public void watchDeployments(ApiClient client) throws Exception {
        AppsV1Api api = new AppsV1Api(client);

        Call call = api.listDeploymentForAllNamespacesCall(
            null, null, null, null, null,
            null, null, null, null, Boolean.TRUE, null
        );

        TypeToken<Watch.Response<V1Deployment>> typeToken = new TypeToken<Watch.Response<V1Deployment>>() {};

        try (Watch<V1Deployment> watch = Watch.createWatch(client, call, typeToken.getType())) {

            while(true){
                Watch.Response<V1Deployment> item = watch.next();
                if (item == null) break;
                String eventType = item.type;
                V1Deployment deployment = item.object;
                handleDeploymentEvent(eventType, deployment);
            }
        }
    }

    // Handle deployment events from Kubernetes watch
    private void handleDeploymentEvent(String eventType, V1Deployment deployment) {
        if (deployment == null || deployment.getMetadata() == null) return;

        V1ObjectMeta meta = deployment.getMetadata();

        // NAME, NAMESPACE, STATUS
        String name = Optional.ofNullable(meta).map(V1ObjectMeta::getName).orElse("unknown");
        String namespace = Optional.ofNullable(meta).map(V1ObjectMeta::getNamespace).orElse("default");
        String status = getDeploymentState(deployment);

        // TYPE
        String role = Optional.ofNullable(deployment.getMetadata())
                .map(V1ObjectMeta::getLabels)
                .map(labels -> labels.keySet().stream()
                        .filter(k -> k.startsWith("node-role.kubernetes.io/"))
                        .findFirst()
                        .map(k -> k.replace("node-role.kubernetes.io/", ""))
                        .orElse("worker"))
                .orElse("worker");

        String type = (role.equals("control-plane") || role.equals("master") || role.equals("worker"))
                ? "Cloud" : "Edge";

        Optional<Deployment> existing = deploymentRepository.findByNameAndNamespace(name, namespace);

        // DB ADD/UPDATE/DELETE
        switch (eventType) {
            case "ADDED", "MODIFIED" -> {
                Deployment deploymentDB = existing.orElse(new Deployment());
                deploymentDB.setName(name);
                deploymentDB.setNamespace(namespace);
                deploymentDB.setStatus(status);
                deploymentDB.setType(type);
                deploymentDB.setStrategy(1);
                deploymentDB.setEnabled(false);
                deploymentRepository.save(deploymentDB);
            }
            case "DELETED" -> existing.ifPresent(deploymentRepository::delete);
        }
    }

    // Get the current state of a deployment based on its conditions
    public static String getDeploymentState(V1Deployment deployment) {
        List<V1DeploymentCondition> conditions = Optional.ofNullable(deployment.getStatus())
                .map(V1DeploymentStatus::getConditions)
                .orElse(Collections.emptyList());

        boolean paused = conditions.stream()
                .anyMatch(c -> "Progressing".equals(c.getType())
                        && "False".equalsIgnoreCase(c.getStatus())
                        && "DeploymentPaused".equals(c.getReason()));
        if (paused) return "Paused";

        boolean failed = conditions.stream()
                .anyMatch(c -> "Progressing".equals(c.getType())
                        && "False".equalsIgnoreCase(c.getStatus())
                        && "ProgressDeadlineExceeded".equals(c.getReason()));
        if (failed) return "Failed";

        boolean progressing = conditions.stream()
                .anyMatch(c -> "Progressing".equals(c.getType())
                        && "True".equalsIgnoreCase(c.getStatus()));
        if (progressing) {
            boolean available = conditions.stream()
                    .anyMatch(c -> "Available".equals(c.getType())
                            && "True".equalsIgnoreCase(c.getStatus()));
            return available ? "Available" : "Progressing";
        }

        boolean unavailable = conditions.stream()
                .anyMatch(c -> "Available".equals(c.getType())
                        && "False".equalsIgnoreCase(c.getStatus()));
        if (unavailable) return "Unavailable";

        return "Unknown";
    }
}
