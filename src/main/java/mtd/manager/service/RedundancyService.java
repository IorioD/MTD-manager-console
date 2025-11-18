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

/*=============================================================================================================
                                            Redundancy Service

    This service periodically checks for deployments that have the Redundancy strategy enabled.
    If a deployment is found with this strategy enabled, it calculates the desired number of replicas
    based on predefined criteria and updates the deployment's replica count accordingly.

    Replicas are implemented in Kubernetes via an object called ReplicaSet to maintain a specific number of 
    replicas always updated and ready.

    The service runs in an infinite loop, sleeping for a configurable period between iterations.
=============================================================================================================*/

@Slf4j
@Component
public class RedundancyService implements Runnable {

    public static final String DYNAMIC_REPLICA_STRATEGY = "redundancy-service";
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

    /*
    @Autowired
    private ClusterService clusterService; 

    private final Random random = new Random();
     */

    @Override
    @SneakyThrows
    public void run() {

        log.info("RedundancyService running");
        KubernetesClient kubernetesClient = new KubernetesClientBuilder().build();
        log.info("KubernetesClient built: Redundancy");

        //ClusterDTO clusterData = null;

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

                    /*
                    int currentReplicas = runningDeployment.getSpec().getReplicas();
                    log.info("Current replicas for deployment {}: {}", runningDeployment.getMetadata().getName(), currentReplicas);

                    clusterData = clusterService.retrieveClusterInfo();

                    int optimizedReplicas = GeneticAlgorithmForReplicas(clusterData);
                    int rotationPeriod = GeneticAlgorithmForRotation(clusterData);

                    if (optimizedReplicas <= 0) {
                        if (currentReplicas > 1) {
                            log.warn("Invalid replica count {}. Setting to minimum allowed (1).", optimizedReplicas);
                            optimizedReplicas = 1;
                        } else {
                            log.warn("Replicas already at minimum (1), no update needed.");
                            continue;
                        }
                    }
                    log.info("Optimized replicas: {}, rotation period: {}s", optimizedReplicas, rotationPeriod);
                    */

                    int desiredReplicas = calculateDesiredReplicas(deployment);
                    log.info("Desired replicas for deployment {}: {}", deployment.getName(), desiredReplicas);

                    runningDeployment.getSpec().setReplicas(desiredReplicas);
                    //runningDeployment.getSpec().setReplicas(optimizedReplicas);

                    kubernetesClient.apps().deployments()
                            .inNamespace(deployment.getNamespace())
                            .resource(runningDeployment)
                            .update(); // Apply the update

                    log.info("Replica update executed for deployment {}", runningDeployment.getMetadata().getName());
                    //Thread.sleep(rotationPeriod * 1000L);
                }
            }

            /*
            Parameter period = parameterRepository.findByKey("period").orElseThrow(EntityNotFoundException::new);
            Thread.sleep(Integer.parseInt(period.getValue()));
            */

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
        return 2; // Placeholder logic; implement ASAGA algorithm
    }

    /*
    private int GeneticAlgorithmForRotation(ClusterDTO clusterData) {
        double cpuLoad = getCpuLoad(clusterData); // CPU load between 0 and 1
        double memoryUsage = getMemoryUsage(clusterData); // Memory used in MB
        double diskUsage = getDiskUsage(clusterData);

        logMetrics(cpuLoad, memoryUsage, diskUsage);

        // Default rotation period
        int rotationPeriod = 30;

        // Thresholds for considering if resources are all high
        double cpuThreshold = 0.85; // CPU threshold (85%)
        double memoryThreshold = 0.80; // Memory threshold (1000 MB)
        double diskThreshold = 0.80; // Disk threshold (80%)

        // Check if all resources are above the threshold
        if (cpuLoad > cpuThreshold && memoryUsage > memoryThreshold && diskUsage > diskThreshold) {
            rotationPeriod = 100;  // If all resources exceed the threshold, set to 100 seconds
        } else {
            // Calculate a combined factor that takes into account all factors
            double combinedFactor = (cpuLoad * 0.4) + (memoryUsage * 0.3) + (diskUsage * 0.3);

            // Determine the rotation period based on the combined factor
            if (combinedFactor > 0.85) {
                rotationPeriod = 60;  // Increase rotation period if all resources are above 80%
            } else if (combinedFactor > 0.75) {
                rotationPeriod = 55;  // If combined factor is between 0.75 and 0.85
            } else if (combinedFactor > 0.65) {
                rotationPeriod = 40;  // If between 0.65 and 0.75
            } else {
                rotationPeriod = 30;  // Default period
            }
        }
        log.info("Calculated Rotation Period: {} seconds", rotationPeriod);
        return rotationPeriod; 
    }

    private void logMetrics(double cpuLoad, double memoryUsage, double diskUsage) {
        String CpuLoadPerc = String.format("%.2f", cpuLoad * 100);
        String MemoryUsagePerc = String.format("%.2f", memoryUsage * 100);
        String DiskUsagePerc = String.format("%.2f", diskUsage * 100);
        
        log.info("Rotation Algorithm - CPU Load: {} %, Memory Usage: {} , Disk Usage: {} %",
        CpuLoadPerc, MemoryUsagePerc, DiskUsagePerc);
    }


    private int GeneticAlgorithmForReplicas(ClusterDTO clusterData) {

        // Parametrization of population size and number of generations
        int populationSize = calculatePopulationSize(clusterData);
        int generations = calculateGenerations(clusterData);

        List<Integer> population = new ArrayList<>();

        for (int i = 0; i < populationSize; i++) {
            int replicas = calculatePodReplicas(clusterData); // Calculate the number of replicas based on resources
            population.add(replicas); // Add to population
        }

        log.info("Initial Population (size={}): {}", populationSize, population);
        log.info("Generations: {}", generations);

        for (int gen = 0; gen < generations; gen++) {
            population.sort(Comparator.comparingDouble(replica -> evaluateFitness((Integer) replica, clusterData)).reversed());
            List<Integer> newPopulation = new ArrayList<>();
            
            for (int i = 0; i < populationSize / 2; i++) {
                int parent1 = population.get(random.nextInt(populationSize / 2));
                int parent2 = population.get(random.nextInt(populationSize / 2));
                newPopulation.add(crossover(parent1, parent2));
            }
            
            for (int i = 0; i < populationSize / 2; i++) {
                int mutated = mutate(population.get(i));
                newPopulation.add(mutated);
            }

            population = newPopulation;
            log.info("Generation {}: Best Replicas: {}", gen, population.get(0));
        }

        log.info("Final Best Replicas: {}", population.get(0));

        return population.get(0);
    }

    private int calculatePodReplicas(ClusterDTO clusterData) {

        double cpuLoad = getCpuLoad(clusterData); 
        double memoryUsage = getMemoryUsage(clusterData); 
        double diskUsage = getDiskUsage(clusterData); 

        int replicas = 2; // Base value (2 replicas)

        // Resource combination
        double combinedFactor = (cpuLoad + memoryUsage + diskUsage) / 3.0;  
        // Average load (normalized between 0 and 1)

        // Based on this factor, we determine the number of replicas
        switch (combinedFactor) {
            case 1:
                combinedFactor > 0.85;
                replicas = 9;
                break;

            case 2: 
                combinedFactor > 0.75;
                replicas = 8;
                break;
            
            case 3:
                combinedFactor > 0.65;
                replicas = 7;
                break;
            
            case 4:
                combinedFactor > 0.55;
                replicas = 6;  
                break;
            
            case 5:
                combinedFactor > 0.45;
                replicas = 5;
                break;

            case 6:
                combinedFactor > 0.35;
                replicas = 4;
                break;

            case 7:
                combinedFactor > 0.25;
                replicas = 3;
                break;

            case 8:
                combinedFactor > 0.15;
                replicas = 2;
                break;
            
            default:
                replicas = 1;
                break;
        }

        // Adapting replicas number to specific conditions on each resource
        if (cpuLoad > 0.85) {
            // If CPU is overloaded, increase replicas
            replicas = Math.min(9, replicas + 1);  // Never exceed 9
        } 
        else if (cpuLoad < 0.4) {
            // If CPU is under 40%, decrease replicas
            replicas = Math.max(1, replicas - 1);  // Never go below 1
        }
    
        if (memoryUsage > 0.85) {
            // If memory is above 85%, increase replicas
            replicas = Math.min(9, replicas + 1);
        }
        else if (memoryUsage < 0.4) {
            // If memory is under 40%, decrease replicas
            replicas = Math.max(1, replicas - 1);
        }
    
        if (diskUsage > 0.85) {
            // If disk usage is above 85%, increase replicas
            replicas = Math.min(9, replicas + 1);
        }
        else if (diskUsage < 0.30) {
            // If disk usage is under 30%, decrease replicas
            replicas = Math.max(1, replicas - 1);
        }

        // Ensure the number of replicas is always between 1 and 9
        replicas = Math.min(9, Math.max(1, replicas));

        return replicas;
    }

    // Function to calculate population size based on complexity
    private int calculatePopulationSize(ClusterDTO clusterData) {

        double cpuLoad = getCpuLoad(clusterData);
        double memoryUsage = getMemoryUsage(clusterData);
        double diskUsage = getDiskUsage(clusterData);
    
        int basePopulation = 10; // Base population size

        // Calculate a "penalty" based on resource load (values between 0 and 1)
        double resourcePenalty = 0.0;

        // Penalize population based on resources in a combined manner
        if (cpuLoad > 0.8) {
            resourcePenalty += 0.4;  // If CPU is overloaded, add penalty
        } else if (cpuLoad < 0.3) {
            resourcePenalty -= 0.2;  // If CPU is underutilized, reduce penalty
        }
    
        if (memoryUsage > 0.8) {
            resourcePenalty += 0.3;  // If memory is high, add penalty
        } else if (memoryUsage < 0.2) {
            resourcePenalty -= 0.2;  // If memory is low, reduce penalty
        }
    
        if (diskUsage > 0.8) {
            resourcePenalty += 0.3;  // If disk usage is high, add penalty
        } else if (diskUsage < 0.2) {
            resourcePenalty -= 0.2;  // If disk usage is low, reduce penalty
        }

        // Modify base population based on combined penalty
        int adjustedPopulation = (int) Math.round(basePopulation * (1 + resourcePenalty));

        // Ensure population does not exceed limits
        adjustedPopulation = Math.max(5, Math.min(50, adjustedPopulation)); // Population between 5 and 50

        log.info("Calculated Population Size: {} based on resources (CPU: {}, Memory: {}, Disk: {})", 
                 adjustedPopulation, cpuLoad, memoryUsage, diskUsage);
    
        return adjustedPopulation;
    }


    // Function to calculate the number of generations based on complexity
    private int calculateGenerations(ClusterDTO clusterData) {
    
        double cpuLoad = getCpuLoad(clusterData);
        double memoryUsage = getMemoryUsage(clusterData);
        double diskUsage = getDiskUsage(clusterData);

        // Define a base number of generations
        int baseGenerations = 50;

        // Calculate a "penalty" for resource complexity
        double resourcePenalty = 0.0;

        // Penalize generations based on resource usage
        if (cpuLoad > 0.8) {
            resourcePenalty += 0.4;  // If CPU is overloaded, increase generations
        } else if (cpuLoad < 0.3) {
            resourcePenalty -= 0.2;  // If CPU is underutilized, reduce generations
        }

        if (memoryUsage > 0.8) {
            resourcePenalty += 0.3;  // If memory is high, increase generations
        } else if (memoryUsage < 0.2) {
            resourcePenalty -= 0.2;  // If memory is low, reduce generations
        }

        if (diskUsage > 0.8) {
            resourcePenalty += 0.3;  // If disk usage is high, increase generations
        } else if (diskUsage < 0.2) {
            resourcePenalty -= 0.2;  // If disk usage is low, reduce generations
        }

        // Modify generations based on combined penalty
        int adjustedGenerations = (int) Math.round(baseGenerations * (1 + resourcePenalty));

        // Ensure generations are within a reasonable range
        adjustedGenerations = Math.max(30, Math.min(100, adjustedGenerations)); // Generations between 30 and 100

        log.info("Calculated Generations: {} based on resources (CPU: {}, Memory: {}, Disk: {})", 
                adjustedGenerations, cpuLoad, memoryUsage, diskUsage);

        return adjustedGenerations;
    }

    // Fitness function to evaluate how good a solution is
    private double evaluateFitness(int replicas, ClusterDTO clusterData) {

        double cpuLoad = getCpuLoad(clusterData);
        double diskUsage = getDiskUsage(clusterData);
        double memoryUsage = getMemoryUsage(clusterData);

        // OBJECTIVE: minimize latency, CPU, memory and disk usage, while keeping errors low
        double fitness = (1 - cpuLoad) * 0.25 + // Maximize CPU usage
                        (1 - memoryUsage) * 0.15 + // Use memory in GiB (byte/GB)
                        (1 - diskUsage) * 0.2;  // Use disk as a percentage, already between 0 and 1

        // Penalize scenarios where resources are too high
        if (cpuLoad > 0.9) fitness *= 0.8;
        if (diskUsage > 0.9) fitness *= 0.5; 
        if (memoryUsage > 0.7) fitness *= 0.6;  

        return Math.max(0, fitness); // Ensure fitness is >= 0
    }

    // Crossover function to combine two parents
    private int crossover(int parent1, int parent2) {
        if (random.nextDouble() > 0.5) {
            return (parent1 + parent2) / 2;
        } else {
            return Math.max(2, Math.min(5, parent1 + random.nextInt(3) - 1)); 
            // Avoid scenarios where the number of replicas goes outside the range [2, 5]
        }
    }

    // Mutation function to introduce variability
    private int mutate(int value) {
        return Math.max(2, Math.min(5, value + random.nextInt(3) - 1)); 
        // Small random variation, staying within the range [2, 5]
    }

    // Fetch metrics methods form cluster data
    private double getCpuLoad(ClusterDTO clusterData) {
        return clusterData != null ? fetchMetric("cpuUsage", clusterData) / 100 : 0.0;
    }

    private double getMemoryUsage(ClusterDTO clusterData) {
        return clusterData != null ? fetchMetric("memUsage", clusterData)/100 : 0.0;
    }

    private double getDiskUsage(ClusterDTO clusterData) {
        return clusterData != null ? fetchMetric("diskUsage", clusterData)/100 : 0.0;
    }

    private double fetchMetric(String metricType, ClusterDTO clusterData) {
        try {
            return clusterData.getNodeMetricsMap().values().stream()
                .mapToDouble(metrics -> {
                    switch (metricType) {
                        case "cpuUsage": 
                            return Double.parseDouble(metrics.getCpuUsage().replace(" %", ""));
                        case "memUsage": 
                            return Double.parseDouble(metrics.getMemUsage().replace(" %", ""));
                        case "diskUsage": 
                            return Double.parseDouble(metrics.getDiskUsage().replace(" %", ""));
                        default: 
                            return 0;
                    }
                }).average().orElse(0);
        } catch (Exception e) {
            log.error("Error fetching {} metric: ", metricType, e);
            return 0;
        }
    }
    */
}
