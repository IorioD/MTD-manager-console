# MTD-manager-console
 This is a JAVA application for managing the Moving Target Defense in cloud environment.
 
To use this application, you need to install a kubernetes cluster following this file [How to Kubernetes](How_to_kubernetes.md) and setup the environment following [Application setup](Application_setup.md).

The implemented techniques are:
1. IP shuffling (Changes the IP of the pod for the selected deployment making it restart)
2. Service Account shuffling (Changes the Service Account of the pod for the selected deployment)
3. Dynamis Replica (Creates a new replica of the pod for the selected deployment)
4. Node Migration (Migrate the pod of the selected deployment to another worker node)
