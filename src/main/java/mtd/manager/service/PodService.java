package mtd.manager.service;

import mtd.manager.dto.PodDTO;
import mtd.manager.entity.Pod;
import mtd.manager.repository.PodRepository;
import mtd.manager.vo.PodUpdateVO;
import mtd.manager.vo.PodVO;
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
public class PodService {

    @Autowired
    private PodRepository podRepository;

    public String save(PodVO vO) {
        Pod bean = new Pod();
        BeanUtils.copyProperties(vO, bean);
        bean = podRepository.save(bean);
        return bean.getName();
    }

    public void delete(Long id) {
        podRepository.deleteById(id);
    }

    public void update(PodUpdateVO vO) {
        Pod bean = requireOne(vO.getId());
        BeanUtils.copyProperties(vO, bean);
        podRepository.save(bean);
    }

    public PodDTO getById(Long id) {
        Pod original = requireOne(id);
        return toDTO(original);
    }

    private PodDTO toDTO(Pod original) {
        PodDTO bean = new PodDTO();
        BeanUtils.copyProperties(original, bean);
        bean.setStrategy(original.getStrategy()); // Set the strategy
        bean.setEnabled(original.getEnabled());   // Set the enabled flag
        return bean;
    }

    private Pod requireOne(Long id) {
        return podRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Resource not found: " + id));
    }

    public List<PodDTO> findAll() {
        List<PodDTO> list = new ArrayList<>();
        podRepository.findAll().forEach(depl -> list.add(toDTO(depl)));
        return list;
    }

    public void updatePodStrategy(Long id, Integer strategy) {
        Pod pod = requireOne(id);
        pod.setStrategy(strategy);
        podRepository.save(pod);
    }

    public void updateEnabled(Long id, boolean enabled) {
        Pod pod = requireOne(id);
        pod.setEnabled(enabled);
        podRepository.save(pod);
    }

    public void toggleEnabled(Long id) {
        Pod pod = requireOne(id);
        pod.setEnabled(!pod.getEnabled());
        podRepository.save(pod);
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

            // NODE ROLE
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
            Pod podDB = podRepository.findByName(podName);
            if (podDB == null) {
                podDB = new Pod();
                podDB.setEnabled(false); // Default to enabled for new pods
                podDB.setStrategy(1);   // Default strategy for new pods
            }
            podDB.setName(podName);
            podDB.setNamespace(namespace);
            podDB.setType(type);
            podDB.setNodeName(nodeName);
            podDB.setStatus(status);
            podDB.setPodIp(podIp);

            podRepository.save(podDB);
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
