package mtd.manager.service;

import io.fabric8.kubernetes.client.KubernetesClient;
import io.fabric8.kubernetes.client.KubernetesClientBuilder;
import jakarta.persistence.EntityNotFoundException;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import mtd.manager.entity.Deployment;
import mtd.manager.entity.Parameter;
import mtd.manager.entity.Strategy;
import mtd.manager.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;


/* =============================================================================================================
                                        IP Shuffling Strategy

    This service periodically checks for deployments that have the IP Shuffling strategy enabled.
    If a deployment is found with this strategy enabled, it forces a rolling restart of the pods associated
    with that deployment by updating an annotation on the pod template. This triggers Kubernetes to restart
    the pods, effectively shuffling their IP addresses.

    The IP is chosen from a range of reserved IP addresses via the so-called Container Network Interface (CNI) 
    plugins, assigning a unique address to the pod from this range and setting up the necessary network interfaces 
    and routing rules on the node to ensure the direct communication among pods without any NAT.

    The service runs in an infinite loop, sleeping for a configurable period between iterations.
=============================================================================================================*/

@Slf4j
@Component
public class IPShufflingStrategyService implements Runnable {

    public static final String IP_SHUFFLING_CONTAINER = "ip-shuffling";

    @Value("${kubernetes.master.url}")
    private String masterUrl;
    @Autowired
    private DeploymentRepository deploymentRepository;
    @SuppressWarnings("unused")
    @Autowired
    private NodeRepository nodeRepository;
    @SuppressWarnings("unused")
    @Autowired
    private NodeLabelRepository nodeLabelRepository;
    @Autowired
    private StrategyRepository strategyRepository;
    @Autowired
    private ParameterRepository parameterRepository;

    @Override
    @SneakyThrows
    public void run() {

        log.info("IPShufflingStrategyService running");
        KubernetesClient kubernetesClient = new KubernetesClientBuilder().build();
        log.info("KubernetesClient built: IP Shuffling");

        while (true) {

            Strategy ipShuffling = strategyRepository.findByName(IP_SHUFFLING_CONTAINER).orElseThrow(EntityNotFoundException::new);

            List<Deployment> deployments = deploymentRepository.findAll();
            log.info("Deployments found: {}", deployments.size());

            for (Deployment deployment : deployments) {
                if (Boolean.TRUE.equals(ipShuffling.getEnabled()) && Integer.valueOf(1).equals(deployment.getStrategy()) && deployment.isEnabled()) {

                    io.fabric8.kubernetes.api.model.apps.Deployment runningDeployment = kubernetesClient.apps()
                            .deployments().inNamespace(deployment.getNamespace()).withName(deployment.getName()).get();
                    
                    if (runningDeployment == null) {
                        log.warn("Deployments {} not found in namespace {}", deployment.getName(), deployment.getNamespace());
                        continue; // Skip to next one
                    }
                    
                    log.info("Deplyments running: {}", runningDeployment.getMetadata().getName());

                    // Force a rolling restart by updating a deployment annotation
                    Map<String, String> annotations = runningDeployment.getSpec().getTemplate().getMetadata().getAnnotations();
                    if (annotations == null) {
                        annotations = new java.util.HashMap<>();
                    }
                    annotations.put("kubectl.kubernetes.io/restartedAt", java.time.Instant.now().toString());
                    runningDeployment.getSpec().getTemplate().getMetadata().setAnnotations(annotations);

                    kubernetesClient.apps().deployments()
                            .inNamespace(deployment.getNamespace())
                            .resource(runningDeployment)
                            .update();

                    log.info("Restart executed for deployment {}", runningDeployment.getMetadata().getName());
                }
            }

            Parameter period = parameterRepository.findByKey("period").orElseThrow(EntityNotFoundException::new);
            Thread.sleep(Integer.parseInt(period.getValue()));
        }
    }
}
