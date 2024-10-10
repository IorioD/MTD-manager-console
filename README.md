# MTD-manager-console
This is a JAVA application for managing the Moving Target Defense in cloud environment developed in collaboration with `University of Naples Federico II` in the context of [DEFEDGE - PRIN PNRR 2022 Project](https://github.com/DEFEDGE).
 
To use this application, you need to install a kubernetes cluster following this file [How to Kubernetes](How_to_kubernetes.md) and setup the environment following [Application setup](Application_setup.md).
Performance test explaination can be found in [Performance test](Performance_test.md).

The implemented techniques are:
1. `IP shuffling` (Changes the IP of the pod for the selected deployment making it restart)
2. `Service Account shuffling` (Changes the Service Account of the pod for the selected deployment)
3. `Dynamic Replica` (Creates a new replica of the pod for the selected deployment)
4. `Node Migration` (Migrate the pod of the selected deployment to another worker node)

The application is intuitive and easy to use.
- The `landing page` is the following:

![Alt text](miscConfig/Home.png "Home page")

in which information about the cluster and the single node are automatically retrieved.

- In the `Nodes List` page

![Alt text](miscConfig/List-node.png "Nodes")

![Alt text](miscConfig/addNode.png "Add Node Form")

the user can manage the node lifecycle (using add, edit and delete function).

- In the `Deployment List` page

![Alt text](miscConfig/List-deplo.png "Deployments")

![Alt text](miscConfig/addDeplo.png "Add Deployment Form")

the user can manage the deployment lifecycle (using add, edit and delete function) and can decide on which deplyment enable the MTD.  

- In the `Strategies List` page

![Alt text](miscConfig/List-strat.png "Strategies")

the user can enable one or more strtategy that will affect the enabled deployment.
In this case the user cannot edit the strategy directly in the UI but needs to modify the source code to change/add implementation logic.

- In the `Parameter` page

![Alt text](miscConfig/Param.png "Parameter")

the user can set the preferred execution window.
