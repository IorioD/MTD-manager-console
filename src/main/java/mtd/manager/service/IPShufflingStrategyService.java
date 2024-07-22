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
        log.info("KubernetesClient built");

        while (true) {

            Strategy ipShuffling = strategyRepository.findByName(IP_SHUFFLING_CONTAINER).orElseThrow(EntityNotFoundException::new);

            List<Deployment> deployments = deploymentRepository.findAll();
            log.info("Deployments found: {}", deployments.size());

            for (Deployment deployment : deployments) {
                if (Boolean.TRUE.equals(ipShuffling.getEnabled()) && Integer.valueOf(1).equals(deployment.getStrategy()) && deployment.isEnabled()) {

                    io.fabric8.kubernetes.api.model.apps.Deployment runningDeployment = kubernetesClient.apps()
                            .deployments().inNamespace(deployment.getNamespace()).withName(deployment.getName()).get();
                    log.info("Deployment running: {}", runningDeployment.getMetadata().getName());

                    // Force a rolling restart by updating an annotation
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