# The following operations must be performed to correctly setup the environment to use the Framework application. 
N.B. You need to install the cluster first (follow the "[How to Kubernetes](How_to_kubernetes.md)" file).

First of all, clone this repository on the master node:
```sh	
git clone https://github.com/DEFEDGE/MTD-manager-console.git
```

## 1. PGAdmin database setup

Use PostgreSQL db with PGAdmin interface to manage the information about the cluster.
1. Install postgreSQL
	```sh	
 	sudo apt install -y postgresql
 	```
2. Install PGadmin:
	- Install the public key for the repository (if not done previously):
	```sh	
 	curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
 	```
 	- Create the repository configuration file:
	```sh
	sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
 	```
	- Install pgadmin for both desktop and web modes:
	```sh
 	sudo apt install pgadmin4
 	```
	If you want, you can install desktop `sudo apt install pgadmin4-desktop` or web `sudo apt install pgadmin4-web` mode only.
	- Configure the webserver credentials, if you installed pgadmin4-web or both versions:
	```sh
	sudo /usr/pgadmin4/bin/setup-web.sh
 	```
3. Set a password for the postgres username with the following commands:
 	```sh
	sudo -u postgres psql
 	```
	then
 	```sh
 	ALTER USER postgres PASSWORD 'postgres';
 	```
4. `127.0.0.1/pgadmin4` (<MASTER_NODE_IP>/pgadmin4 if you are using the server configuration) is the url to connect to the db dashboard.
5. Access with the credentials you inserted;
6. Create a new server (`Right click on servers->register->server`) named `localhost` and in the `connection` tab set `localhost` as address, `5432` as port and `postgres` as username and password
7. Create a new user (`Right click on the server you created->create->Login/Group role`) called `mtdmanager`, set `mtdmanager` as password (in the `definition` panel) and allow all the privileges (in the `privileges` panel).
8. Create new DB (`Right click on databases->create->database`) named `mtdmanager` with mtdmanager as owner.
9. Modify the `pgadmin.sql` (in `/miscConfig` row 304-319) with the IP of the nodes of the cluster and the name provided in the cluster configuration as follows:
```sql
--
-- Data for Name: node; Type: TABLE DATA; Schema: mtdmanager; Owner: mtdmanager
--
--                                  hostname    IP            ID  Role    availab Type
INSERT INTO mtdmanager.node VALUES ('master', '192.168.x.y', 1, 'master', true, 'cloud');
INSERT INTO mtdmanager.node VALUES ('worker1', '192.168.x.z', 2, 'worker', true, 'cloud');
INSERT INTO mtdmanager.node VALUES ('worker2', '192.168.x.h', 3, 'worker', true, 'cloud');


--
-- Data for Name: node_label; Type: TABLE DATA; Schema: mtdmanager; Owner: mtdmanager
--

INSERT INTO mtdmanager.node_label VALUES (1, 'name', 'master', 1);
INSERT INTO mtdmanager.node_label VALUES (2, 'name', 'worker', 2);
INSERT INTO mtdmanager.node_label VALUES (3, 'name', 'worker', 3);
```
type can be `cloud` or `edge` if you are planning to use edge nodes.

10. Copy paste the code in the query tool (`Right click on mtdmanager->Query Tool`) and apply to build the database schema.
11. Now you can query the database:
```sql
select * from mtdmanager.node;

--select * from mtdmanager.service_account;

--select * from mtdmanager.parameter;

--select * from mtdmanager.deployment;

--select * from mtdmanager.node_label;

--select * from mtdmanager.strategy;
```

## 2. Code setup
1. In `application.properties` (src/main/resources/application.properties):
  	- `spring.datasource.url`=jdbc:postgresql://localhost:5432/mtdmanager simply indicates the endpoint of the PGAdmin db installed on the local master machine.
  	- `kubernetes.master.url`=https://192.168.1.37:6443 indicates the IP of the master node and the port to connect to the cluster obtained using
      	```sh
      	kubectl describe svc kubernetes
      	```
5. In `ClusrterController` (src/main/java/mtd/manager/controller/ClusterController.java):
  	- eventually change the frontend origin (row 24) if you plan to deploy the application on something different from http://localhost:8080

	N.B. If you are using the server configuration, you need to connect to http://<MASTER_NODE_IP>:8080

## 3. Metrics collection
1. In `ClusterService` (src/main/java/mtd/manager/service/ClusterService.java) change the IP of `PROMETHEUS_URL` (row 44) to the master node IP.

2. Install Prometheus:
	```sh
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
   	helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace kubernetes-monitoring-system --create-namespace
    ```
   
   To check the pod status:
	```sh
   	kubectl get pods -n kubernetes-monitoring-system
   	```
   
4. When all the pods are up and unning, apply permanent port forwarding with `PrometheusPortFWD.yaml` (in mtd-manager/miscConfig) using the command
    ```sh
    kubectl apply -f PrometheusPortFWD.yaml
    ```
   
	To see the metrics, you can visit: 
  	- http://<MASTER_NODE_IP>:30090/graph to perform the queries
  	- http://<MASTER_NODE_IP>:30090/targets to see the targets installed on each node
    in any case, they are automatically retrieved by the framework.

5. If the node port doesn't work, check whether the name, instance and prometheus values in the yaml file are corresponding to the lables returned by:	
	```sh
   	kubectl get pods -n kubernetes-monitoring-system --show-labels
 	```

## 4.Final steps
1. Once everything is set, execute the following commands to install the Java 17 version
	```sh
	sudo apt install openjdk-17-jdk
	```
	and to select it 
	```sh
	sudo update-alternatives --config java
	```

2. Install maven
	```sh
	sudo apt install maven -y
	```
 
3. Afterward, execute the following commands in the main folder:
	```sh
	sudo chmod +x build-and-run.sh
	```
	and then run
	```sh
	./build-and-run.sh
	```
	to perform:
  	- building: mvn clean install
  	- execution: java -jar ./target/mtd-manager.jar  

	Now you can connect to http://localhost:8080 (or http://<MASTER_NODE_IP>:8080) to access the MTD console.

You can now install [Grafana](Grafana_setup.md) and [Falco](Falco_setup.md).
