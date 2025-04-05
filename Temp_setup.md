# This guide helps you install a simple temperature sensor simulator on the edges sending encrypted information to the cloud.

## 1. Cloud-app-db setup
To be installed on one or more worker. From now on, every installation process must be executed on the master node via the kubesphere console.
1. Create new workload (`application workloads ->workloads`) cloud-app-db:
	- Basic info:
	- Name: `cloud-app-db`
	- Project: `default`
	- Pod setting: 
		- Docker hub: `vittolibre/cloud-app-db`
		- Container name: `cloud-app-db`
		- Delete port settings
	- No articular storage settings
	- Advanced settings:
		- select node on which the pod will be installed (`worker`)
2. In the workloads section, click on the pod, go to `edit yaml` and add in `spec.container` (same indent of ports on row 29)
	```yaml
        envFrom:
          - configMapRef:
              name: cloud-db-credentials
 	```
3. Execute the following commands to apply configmap and service for db (in `/miscConfig/cloud`):
	```sh
 	kubectl apply -f cloud-db-configmap.yaml
	kubectl apply -f cloud-db-service.yaml
	```
 
## 2. Cloud-app setup
This app simulates a situation in which the edge node sends temperature to the node that processes the information (source [Cloud-app-demo](https://github.com/vittolibre/mtd-cloud-app)).
1. Create new workload (application workloads ->workloads) cloud-app as before: 
	- Name: `cloud-app`
	- Project: `default`
	- Docker hub: `vittolibre/cloud-app`
	- Select the same `worker` node as before
2. Click on the pod, go to `edit yaml` and add in `spec.container` (same indent of image on row 29)
   	```yaml
          env:
            - name: DB_URL
              value: 'jdbc:postgresql://192.168.1.38:31215/cloud'
            - name: DB_USER
              value: cloudadmin
            - name: DB_PASSWORD
              value: cloud
	```
	- Change the `IP` with the ip of the worker node on which the DB is installed
	- The port 31215 is the one of the cloud-db-service (`application workloads ->service`)

## 3. Temperature mapper setup
This app simulates a temperature sensor on the edge node that sends data to the cluster. The code used is `temp-demo.go` in `/miscConfig/edge` (for deployment reference see [Deploymetn of Kube-edge temperature mapper](https://blog.csdn.net/w13657909078/article/details/120342636) and for architectural details see [KubeEdge environment](https://blog.csdn.net/w13657909078/article/details/120141490?spm=1001.2014.3001.5501) ).
1. Create a new workload as before:
	- Name: `temp-mapper`
	- Project: `default`
	- Docker hub: `iori0d/temp-mapper:latest`
	- Select the edge node in the advanced settings
2. Use the following command on the master node to verify the connection with temp mapper:
	```sh
	kubectl get device temperature -o yaml
	```
 
## 4. Mosquitto setup
1. To allow communication between master and edge nodes via a message broker, install `mosquitto` and `mosquitto-client` on both master and edge node:
	```sh
	sudo apt update -y && sudo apt install mosquitto mosquitto-clients -y
	```
2. On the master node modify `/etc/mosquitto/mosquitto.conf`:
	```sh
 	sudo nano /etc/mosquitto/mosquitto.conf
 	```
  	adding
	```sh
 	allow_anonymous true
	listener 1883 192.168.1.37
	```
	the `IP` must match the master node's IP while the port is standard
	- Then restart mosquitto daemon:
		```sh
		systemctl restart mosquitto
  		```
3. To verify setup:
	- On master node:
		```sh
		mosquitto_sub -h <master_IP> -p 1883 -t <topic_name> -d
  		```
	- On edge node:
		```sh
		mosquitto_pub -h <master_IP> -p 1883 -t <topic_name> -m <message>
  		```
	and on the master node console the message should appear

## 5. Gateway-db setup
1. Create a new workload for gateway-db as done before:
	- Name: `edge-db`
	- Project: `default`
	- Docker hub: `vittolibre/gateway-db`
	- Set the port to `5432` as port settings
	- Select the `edge node` in the advanced settings
2. Click on the pod, go to `edit yaml` and add in `spec.container` (same indent of ports on row 29)
   	```yaml
          envFrom:
            - configMapRef:
                name: cloud-db-credentials
	```
3. Apply the configmap in `/miscConfig/edge` with the following command:
	```sh
	kubectl apply -f edge-db-configmap.yaml
	```
 
## 6. Gateway-app setup
This app has the same purposes as cloud-app but is installed on edge node.
1. Create a new workload as before for gateway-app
	- Name: `edge-gateway`
	- Project: `default`
	- Docker hub: `iori0d/edge-gate`
	- select the `edge node` in the advanced settings
2. To verify connections and info coming from the app, execute the following command on the master node:
	```sh
 	mosquitto_sub -h 192.168.1.37 -p 1883 -t default/edgenode/temperature -d
	```
 
If you want to use multiple edge nodes and build multiple instances of the app, you need to download [Edge Gateway code](https://github.com/IorioD/Edge-gateway/tree/main) and change
- `application.property`:
	- set `spring.datasource.url` with the IP of the edge
	- set `mqtt.server.host` with the IP of the master 
	- set `mqtt.client.id` with another progressive id. 
- the `message` in MQTTPublisher line 51 to distinguish the instances.
- the `dockerfile` with the IP of the edge in the url
- modify and use the script `deploy.sh` executing the following commands to build the image and push it to docker hub making it available when creating the workload:
	```sh
	maven clean install
	docker build -t <account_name>/<container_name> .
	docker push <account_name>/<container_name>
   	```
