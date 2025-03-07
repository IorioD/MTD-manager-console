package mtd.manager.service;

import io.fabric8.kubernetes.api.model.apps.Deployment;
import io.fabric8.kubernetes.client.KubernetesClient;
import io.fabric8.kubernetes.client.KubernetesClientBuilder;
import jakarta.persistence.EntityNotFoundException;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import mtd.manager.entity.Parameter;
import mtd.manager.entity.Strategy;
import mtd.manager.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.List;

@Slf4j
@Component
public class RedundancyService implements Runnable {

    public static final String DYNAMIC_REPLICA_STRATEGY = "dynamic-pod-replica";
    public static final String EDGE = "edge";
    public static final String CLOUD = "cloud";

    @Value("${kubernetes.master.url}")
    private String masterUrl;
    @Autowired
    private DeploymentRepository deploymentRepository;
    @Autowired
    private StrategyRepository strategyRepository;
    @Autowired
    private ParameterRepository parameterRepository;

    @Override
    @SneakyThrows
    public void run() {

        log.info("RedundancyService running");
        KubernetesClient kubernetesClient = new KubernetesClientBuilder().build();
        log.info("KubernetesClient built");

        while (true) {
            Strategy dynamicReplicaStrategy = strategyRepository.findByName(DYNAMIC_REPLICA_STRATEGY)
                    .orElseThrow(EntityNotFoundException::new);

            List<mtd.manager.entity.Deployment> deployments = deploymentRepository.findAll();
            log.info("Deployments found: {}", deployments.size());

            for (mtd.manager.entity.Deployment deployment : deployments) {
                if (Boolean.TRUE.equals(dynamicReplicaStrategy.getEnabled()) && Integer.valueOf(2).equals(deployment.getStrategy()) && deployment.isEnabled()) {
                    Deployment runningDeployment = kubernetesClient.apps().deployments()
                            .inNamespace(deployment.getNamespace())
                            .withName(deployment.getName())
                            .get();
                    if (runningDeployment == null) {
                        log.warn("Deployment {} not found in namespace {}", deployment.getName(), deployment.getNamespace());
                        continue;
                    }

                    log.info("Deployment running: {}", runningDeployment.getMetadata().getName());

                    int desiredReplicas = calculateDesiredReplicas(deployment);
                    log.info("Desired replicas for deployment {}: {}", deployment.getName(), desiredReplicas);

                    runningDeployment.getSpec().setReplicas(desiredReplicas);

                    kubernetesClient.apps().deployments()
                            .inNamespace(deployment.getNamespace())
                            .resource(runningDeployment)
                            .update(); // Apply the update

                    log.info("Replica update executed for deployment {}", runningDeployment.getMetadata().getName());
                }
            }

            Parameter period = parameterRepository.findByKey("period").orElseThrow(EntityNotFoundException::new);
            log.info("Sleeping for {} milliseconds", period.getValue());
            try {
                Thread.sleep(Integer.parseInt(period.getValue()));
            } catch (InterruptedException e) {
                log.error("Thread was interrupted", e);
                Thread.currentThread().interrupt(); // Reset the interrupted status
            }
        }
    }

    private int calculateDesiredReplicas(mtd.manager.entity.Deployment deployment) {
        return 2;
    }
}
