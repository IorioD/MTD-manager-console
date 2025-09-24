package mtd.manager.service;

import mtd.manager.dto.DeploymentDTO;
import mtd.manager.entity.Deployment;
import mtd.manager.repository.DeploymentRepository;
import mtd.manager.vo.DeploymentUpdateVO;
import mtd.manager.vo.DeploymentVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import io.kubernetes.client.openapi.ApiClient;
import io.kubernetes.client.openapi.apis.CoreV1Api;
import io.kubernetes.client.openapi.models.V1ObjectMeta;
import io.kubernetes.client.openapi.models.V1Pod;
import io.kubernetes.client.openapi.models.V1PodList;
import io.kubernetes.client.openapi.models.V1PodSpec;
import io.kubernetes.client.openapi.models.V1PodStatus;
import io.kubernetes.client.util.Config;
import io.kubernetes.client.openapi.Configuration;

import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

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

    public void syncPodsFromKubernetes() throws Exception {
    ApiClient client = Config.defaultClient();
    Configuration.setDefaultApiClient(client);

    CoreV1Api api = new CoreV1Api();
    V1PodList podList = api.listPodForAllNamespaces(
        null, null, null, null,
        null, null, null, null,
        null, false
        );

        if (podList == null || podList.getItems() == null) {
            return;
        }

        for (V1Pod pod : podList.getItems()) {
            if (pod == null) continue;

            V1ObjectMeta meta = pod.getMetadata();
            V1PodStatus stats = pod.getStatus();
            V1PodSpec spec = pod.getSpec();

            // NOME POD
            String podName = (meta != null) ? meta.getName() : "unknown";

            // NAMESPACE
            String namespace = (meta != null) ? meta.getNamespace() : "default";

            // NODE
            String nodeName = Optional.ofNullable(spec)
                    .map(V1PodSpec::getNodeName)
                    .orElse("N/A");

            // Status (Pending, Running, Succeeded, Failed, Unknown)
            String status = Optional.ofNullable(stats)
                    .map(V1PodStatus::getPhase)
                    .orElse("Unknown");

            // IP POD
            String podIp = Optional.ofNullable(stats)
                    .map(V1PodStatus::getPodIP)
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
                ? "Cloud" : "Edge";

            // Salvataggio nel DB
            Deployment deplo = deploymentRepository.findByName(podName);
            if (deplo == null) {
                deplo = new Deployment();
                deplo.setEnabled(false); // Default to enabled for new pods
                deplo.setStrategy(1);   // Default strategy for new pods
            }
            deplo.setName(podName);
            deplo.setNamespace(namespace);
            deplo.setType(type);
            deplo.setNodeName(nodeName);
            deplo.setStatus(status);
            deplo.setPodIp(podIp);

            deploymentRepository.save(deplo);
        }
    }

    @Scheduled(fixedRate = 60000)
    public void scheduledSyncPods() {
        try {
            syncPodsFromKubernetes();
            System.out.println("Kubernetes Pods synced successfully.");
        } catch (Exception e) {
            System.err.println("Error in syncing Kubernetes Pods: " + e.getMessage());
        }
    }
}
