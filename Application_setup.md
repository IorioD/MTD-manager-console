# The following operations must be performed to correctly setup the environment to use the application. 
N.B. You need to install the cluster first (follow the "[How to Kubernetes](How_to_kubernetes.md)" file).

In `application.properties`:
  - `spring.datasource.url`=jdbc:postgresql://localhost:5432/mtdmanager simply indicates the endpoint of the PGAdmin db installed on the local master machine
  - `kubernetes.master.url`=https://192.168.1.37:6443 indicates the IP of the master node and the port to connect to the cluster obtained using
      ```sh
      kubectl describe svc kubernetes
      ```
      
To make the application able to collect node metrics:
  - apply a permanent port forwarding with `NodePortPromete.yaml` (in mtd-manager/miscConfig) using the command
    ```sh
    kubectl apply -f NodePortProme.yaml
    ```
    
In `ClusterService`:
  - change the ip of `PROMETHEUS_URL` to the master node IP

In `ClusrterController`:
  - eventually change the frontend origin (row 24) if you plan to deploy the application on something different from `http://localhost:8080`

Once everything is set, just execute `./build-and-run.sh` to perform:
  - building: mvn clean install
  - execution: java -jar ./target/mtd-manager.jar
