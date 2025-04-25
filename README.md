# MTD-manager-console
This is a JAVA application for managing the Moving Target Defense in cloud environment developed in collaboration with `University of Naples Federico II` in the context of [DEFEDGE - PRIN PNRR 2022 Project](https://github.com/DEFEDGE).
 
To use this application, you need to install a kubernetes cluster following this file [How to Kubernetes](Setups/How_to_kubernetes.md) and setup the environment following [Framework setup](Setups/Framework_setup.md).

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

N.B. The name of the deployment is the corresponding workload. 

- In the `Strategies List` page

![Alt text](miscConfig/List-strat.png "Strategies")

the user can enable one or more strtategy that will affect the enabled deployment.
In this case the user cannot edit the strategy directly in the UI but needs to modify the source code to change/add implementation logic.
Whenever a new strategy is created, the following steps are needed:
1. the new classNameService.java file implementing the technique must be stored in the `src/main/java/mtd/manager/service` folder
2. insert in the `PGAdmin database` the new corresponding technique using the following query in the proper tool of the web page 
   ```sql
   INSERT INTO mtdmanager.strategy VALUES ('techniqueName', false, 'fixed', <n>);
   ```
   where "n" is the progressive technique number 
3. modify `src/main/resources/public/deplo.js` script to adapt the dropdown menu to the new scenario, adding
   ```js
   <option value="n" ${deployment.strategy === n ? 'selected' : ''}>techniqueName</option>
   ```
   after row 35.
4. in `src/main/resources/public/strats.js` script add the strategy description with the ID provided in `const strategyDescriptions`:
   ```js
   ID: 'Strategy description',
   ```
5. in `src/main/resources/public/add-deployment.js` update the function `isValidStrategy` (row 14), adding the numbers of the new technique.
6. in `src/main/java/mtd/manager/service/MTDStrategyService.java` add a new related thread to activate the service itself upon startup with
   ```java
   new Thread(classNameService, "name_alias").start();
   ```

- In the `Parameter` page

![Alt text](miscConfig/Param.png "Parameter")

the user can set the preferred execution window.
