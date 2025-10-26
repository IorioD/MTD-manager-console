package mtd.manager.service;

import io.fabric8.kubernetes.api.model.PodSpec;
import io.fabric8.kubernetes.api.model.apps.Deployment;
import io.fabric8.kubernetes.client.KubernetesClient;
import io.fabric8.kubernetes.client.KubernetesClientBuilder;
import jakarta.persistence.EntityNotFoundException;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import mtd.manager.entity.Parameter;
import mtd.manager.entity.Strategy;
import mtd.manager.entity.Node;
import mtd.manager.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.List;

/*=============================================================================================================
                                            Node Shuffling Strategy

    This service periodically checks for deployments that have the Node Shuffling strategy enabled.
    If a deployment is found with this strategy enabled, it selects a new node (either edge or cloud based on
    the deployment type) and updates the deployment's pod template to use the new node. This triggers Kubernetes
    to reschedule the pods onto the new node (cloud or edge depending on the deployment type).

    The service runs in an infinite loop, sleeping for a configurable period between iterations.
=============================================================================================================*/


@Slf4j
@Component
public class NodeShufflingStrategyService implements Runnable {

    public static final String NODE_SHUFFLING_CONTAINER = "pod-migration";
    public static final String EDGE = "edge";
    public static final String CLOUD = "cloud";

    @Value("${kubernetes.master.url}")
    private String masterUrl;
    @Autowired
    private DeploymentRepository deploymentRepository;
    @Autowired
    private NodeRepository nodeRepository;
    @Autowired
    private StrategyRepository strategyRepository;
    @Autowired
    private ParameterRepository parameterRepository;

    @SuppressWarnings("unused")
    @Override
    @SneakyThrows
    public void run() {
        log.info("NodeShufflingStrategyService running");
        KubernetesClient kubernetesClient = new KubernetesClientBuilder().build();
        log.info("KubernetesClient built: Node Shuffling");

        while (true) {
            Strategy nodeShuffling = strategyRepository.findByName(NODE_SHUFFLING_CONTAINER).orElseThrow(EntityNotFoundException::new);

            List<mtd.manager.entity.Deployment> deployments = deploymentRepository.findAll();
            log.info("Deployments found: {}", deployments.size());
            for (mtd.manager.entity.Deployment deployment : deployments) {
                if (Boolean.TRUE.equals(nodeShuffling.getEnabled()) && Integer.valueOf(3).equals(deployment.getStrategy()) && deployment.isEnabled()) {
                    Deployment runningDeployment = kubernetesClient.apps()
                            .deployments()
                            .inNamespace(deployment.getNamespace())
                            .withName(deployment.getName())
                            .get();
                    log.info("Deployments running: {}", runningDeployment.getMetadata().getName());

                    if (runningDeployment != null) {
                        changeDeploymentNode(kubernetesClient, runningDeployment, deployment.getType());
                        
                        kubernetesClient.apps()
                                .deployments()
                                .inNamespace(deployment.getNamespace())
                                .resource(runningDeployment)
                                .rolling()
                                .restart();

                        log.info("Node shuffle and restart executed for pod {}", runningDeployment.getMetadata().getName());
                    } else {
                        log.warn("No running pod found for {}", deployment.getName());
                    }
                }
            }

            Parameter period = parameterRepository.findByKey("period").orElseThrow(EntityNotFoundException::new);
            Thread.sleep(Integer.parseInt(period.getValue()));
        }
    }

    private void changeDeploymentNode(KubernetesClient kubernetesClient, Deployment runningDeployment, String deploymentType) {
        Node newNode = null;
        if (EDGE.equals(deploymentType)) {
            newNode = nodeRepository.findRandomEdgeNode();
        } else if (CLOUD.equals(deploymentType)) {
            newNode = nodeRepository.findRandomWorkerNode();
        }

        if (newNode != null) {
            log.info("Selected new node {} for deployment {}", newNode.getHostname(), runningDeployment.getMetadata().getName());
            PodSpec podSpec = runningDeployment.getSpec().getTemplate().getSpec();
            if (podSpec != null) {
                podSpec.setNodeName(newNode.getHostname());
                log.info("Node set for deployment {} to {}", runningDeployment.getMetadata().getName(), newNode.getHostname());

                // Apply the changes to the deployment
                kubernetesClient.apps().deployments().inNamespace(runningDeployment.getMetadata().getNamespace())
                        .resource(runningDeployment).serverSideApply();

                // Verify the changes
                Deployment updatedDeployment = kubernetesClient.apps().deployments().inNamespace(runningDeployment.getMetadata().getNamespace())
                        .withName(runningDeployment.getMetadata().getName()).get();
                PodSpec updatedPodSpec = updatedDeployment.getSpec().getTemplate().getSpec();
                log.info("Verified node for deployment {} is set to {}", runningDeployment.getMetadata().getName(), updatedPodSpec.getNodeName());

                if (newNode.getHostname().equals(updatedPodSpec.getNodeName())) {
                    log.info("Deployments successfully reassigned to new node {}", newNode.getHostname());
                } else {
                    log.warn("Failed to reassign pod to new node. Current node: {}", updatedPodSpec.getNodeName());
                }
            } else {
                log.warn("PodSpec is null for deployment {}", runningDeployment.getMetadata().getName());
            }
        } else {
            log.warn("No available node found for deployment type {}", deploymentType);
        }
    }
}