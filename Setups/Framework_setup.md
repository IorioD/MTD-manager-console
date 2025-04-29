# The following operations must be performed to correctly setup the environment to use the Framework application. 
N.B. You need to install the cluster first (follow the "[How to Kubernetes](How_to_kubernetes.md)" file).

## 1. PGAdmin database setup

Use PostgreSQL db with PGAdmin interface to manage the information about the cluster.
1. Install postgreSQL
	```sh	
 	apt install postgresql
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
	- Install for desktop mode only:
	```sh
	sudo apt install pgadmin4-desktop
 	```
	- Install for web mode only:
	```sh
	sudo apt install pgadmin4-web
 	```
	- Configure the webserver, if you installed pgadmin4-web:
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
 	and use the new password in the pgadmin UI in the proper field
4. `127.0.0.1/pgadmin4` (<MASTER_NODE_IP>/pgadmin4 if you are using the server configuration) is the url to connecto to the db dashboard.
5. Create a new server named localhost with `localhost` as adress, `5432` as port and `postgres` as username and password
7. Create a new user called `mtdmanager` with all the privileges (in the privileges panel of the user properties) and set `mtdmanager` as password (in the description panel in the user properties).
8. Create new db named `mtdmanager` with mtdmanager as owner
9. Modify the `pgadmin.sql` (in `/miscConfig` row 307-309) with the IP of the nodes of the cluster and the names provided in the cluster configuration and apply it using the query tool to build the database schema.

## 2. Code setup
1. In `application.properties` (src/main/resources/application.properties):
  	- `spring.datasource.url`=jdbc:postgresql://localhost:5432/mtdmanager simply indicates the endpoint of the PGAdmin db installed on the local master machine.
  	- `kubernetes.master.url`=https://192.168.1.37:6443 indicates the IP of the master node and the port to connect to the cluster obtained using
      	```sh
      	kubectl describe svc kubernetes
      	```
      
	To make the application able to collect node metrics:
  	- apply permanent port forwarding with `NodePortProme.yaml` (in mtd-manager/miscConfig) using the command
    	```sh
    	kubectl apply -f NodePortProme.yaml
    	```
    
3. In `ClusterService` (src/main/java/mtd/manager/service/ClusterService.java):
	- change the ip of `PROMETHEUS_URL` to the master node IP

	To see the metrics without using the app, you can visit 
  	- http://<MASTER_NODE_IP>:30090/graph to perform the queries
  	- http://<MASTER_NODE_IP>:30090/targets to see the targets installed on each node

4. In `ClusrterController` (src/main/java/mtd/manager/controller/ClusterController.java):
  	- eventually change the frontend origin (row 24) if you plan to deploy the application on something different from http://localhost:8080

	N.B. If you are using the server configuration, you need to connect to http://<MASTER_NODE_IP>:8080

5. Once everything is set, execute the following commands to use the Java 17 version:
	```sh
	sudo apt install openjdk-17-jdk
	```
	to install and 
	```sh
	sudo update-alternatives --config java
	```
	to select the Java 17 version

6. Afterward, execute the following commands in the main folder:
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
