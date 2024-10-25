# The following operations must be performed to correctly setup the environment to use the application. 
N.B. You need to install the cluster first (follow the "[How to Kubernetes](How_to_kubernetes.md)" file).

In `application.properties`:
  - `spring.datasource.url`=jdbc:postgresql://localhost:5432/mtdmanager simply indicates the endpoint of the PGAdmin db installed on the local master machine
  - `kubernetes.master.url`=https://192.168.1.37:6443 indicates the IP of the master node and the port to connect to the cluster obtained using
      ```sh
      kubectl describe svc kubernetes
      ```
      
To make the application able to collect node metrics:
  - apply a permanent port forwarding with `NodePortProme.yaml` (in mtd-manager/miscConfig) using the command
    ```sh
    kubectl apply -f NodePortProme.yaml
    ```
    
In `ClusterService`:
  - change the ip of `PROMETHEUS_URL` to the master node IP

To see the metrics without using the app, you can visit 
  - http://<MASTER_NODE_IP>:30090/graph to perform the queries
  - http://<MASTER_NODE_IP>:30090/targets to see the targets installed on each node

In `ClusrterController`:
  - eventually change the frontend origin (row 24) if you plan to deploy the application on something different from http://localhost:8080

Once everything is set, execute the following command in the main folder:
```sh
sudo chmod +x build-and-run.sh
```
and then run `./build-and-run.sh` to perform:
  - building: mvn clean install
  - execution: java -jar ./target/mtd-manager.jar  

Now you can connect to http://localhost:8080 to access the MTD console.
