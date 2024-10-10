# In this file will be provided a guide to setup the Kubernetes cluster.

- To use this configuration, you need a host machine with at least 32 GB of RAM and a CPU that supports vierualization.
- Each listed command must be executed in superuser mode.

## 1. VM Setup

| VM       | CPU | RAM (GB) | Disk (GB) | OS        |
|----------|-----|----------|-----------|-----------|
| Master   | 5   | 5        | 40        | Linux Lite|
| Worker   | 3   | 3        | 35        | Linux Lite|
| Worker_2 | 3   | 3        | 35        | Linux Lite|
| Edge     | 2   | 2        | 30        | Linux Lite|
| Edge_2   | 2   | 2        | 30        | Linux Lite|

- For each VM, set a bridged network card.
- Ensure that the IP of each VM is static.
- Install Docker on each VM.

## 2. Cluster Installation
- Follow the guide: [KubeSphere Multi-node Installation](https://kubesphere.io/docs/v3.4/installing-on-linux/introduction/multioverview/)
- Video guide: [YouTube Video Guide](https://www.youtube.com/watch?v=nYOYk3VTSgo)

### Steps:
1. Pay attention to node requirements (mainly on SSH connection).
2. Install `conntrack` and `socat` dependencies.
3. Install KubeKey:

    ```sh
    curl -sfL https://get-kk.kubesphere.io | VERSION=v3.0.13 sh -
    chmod +x kk
    ```

4. Create cluster config:

    ```sh
    ./kk create config --with-kubernetes v1.23.10 --with-kubesphere v3.4.1
    ```

5. Edit configuration properly setting `specs.hosts` and `specs.roleGroups` as explained in the guide.
6. Create cluster:

    ```sh
    ./kk create cluster -f <config-name>.yaml
    ```
At the end something like this will be shown:

![Alt text](miscConfig/kube.png)

with the IP matches with the IP of the master node.

## 3. Check Installation:
```sh
kubectl logs -n kubesphere-system $(kubectl get pod -n kubesphere-system -l 'app in (ks-install, ks-installer)' -o jsonpath='{.items[0].metadata.name}') -f
```

## 4. Adding an Edge Node in the Cluster
[Add Edge Nodes Guide](https://www.kubesphere.io/docs/v3.4/installing-on-linux/cluster-operation/add-edge-nodes/)

### 1. Install KubeEdge on Master Node
[Install KubeEdge](https://www.kubesphere.io/docs/v3.4/pluggable-components/kubeedge/)
1. Log in to the KubeSphere console.
2. Go to the `CRDs` menu on the left.
3. Search for `clusterconfiguration` and click on it.
4. In Custom Resources, click on the right of `ks-installer` and select `Edit YAML`.
5. In this YAML file, navigate to `edgeruntime` (around row 71).
6. Change the value of `enabled` from `false` to `true`.
7. Change the `advertiseAddress` to the IP of the master node to enable all KubeEdge components.
8. Click `OK`.
9. Run the following command to verify the installation:
    ```sh
    kubectl logs -n kubesphere-system $(kubectl get pod -n kubesphere-system -l 'app in (ks-install, ks-installer)' -o jsonpath='{.items[0].metadata.name}') -f
    ```
    
### 2. Configure Edge Mesh on the nodes
1. Edit the `/etc/nsswitch.conf` file:
    ```sh
    sudo nano /etc/nsswitch.conf
    ```
2. Add the following line to the file and save:
    ```sh
    hosts:          dns files mdns4_minimal [NOTFOUND=return]
    ```
3. Run:
    ```sh
    sudo echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
    ```
4. Verify modification:
    ```sh
    sudo sysctl -p | grep ip_forward
    ```
    “net.ipv4.ip_forward = 1” is the expected result. 

### 3. Add the edge node
1. Log in to the console as admin and click Platform in the upper-left corner
2. Select Cluster Management and navigate to Edge Nodes under Nodes.
3. Click Add. In the dialog that appears, set a node name and enter an internal IP address of your edge node. Click Validate to continue
4. Copy the command automatically created under Edge Node Configuration Command and run it on your edge node.
e.g.
        ```sh
        arch=$(uname -m); if [[ $arch != x86_64 ]]; then arch='arm64'; fi;  curl -LO https://kubeedge.pek3b.qingstor.com/bin/v1.13.0/$arch/keadm-v1.13.0-linux-$arch.tar.gz  && tar xvf keadm-v1.13.0-linux-$arch.tar.gz && chmod +x keadm && ./keadm join --kubeedge-version=1.13.0 --cloudcore-ipport=192.168.1.37:30000 --quicport 30001 --certport 30002 --tunnelport 30004 --edgenode-name edgenode --edgenode-ip 192.168.1.45 --token 04632e3afc95ca52c36baaf6c537bc022c63b328bc1cf20dbc23b24fadf9bab4.eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MTY0NzM5NDl9.ke_uAXNu5pWKvkyBHAUKAEXGbQbtGSERDpEHB5qZOPs --with-edge-taint -r docker
        ```

    Notes:
    - Ports used are `30000-30004` instead of `10000-10004`
    - At the end there is `-r docker` to explicit the use of docker on the edge 
    - Make sure wget is installed on your edge node before you run the command
5. Edit the `edgecore.yaml` file:
   ```sh
    sudo nano /etc/kubeedge/config/edgecore.yaml 
    ```
   and change `cgroupDriver` to `systemd` if necessary and  `edgeStream.enable` to `true` then save and exit
6. On the master machine:
    - Log in to the KubeSphere console.
    - Go to the `CRDs` menu on the left.
    - Search for `clusterconfiguration` and click on it.
    - In Custom Resources, click on the right of `ks-installer` and select `Edit YAML`.
    - Navigate to `metrics_server` (around row 104) and change the value of `enabled` from `false` to `true`.
    - Click `OK`.
7. On the edge machine use
    ```sh
    sudo systemctl restart edgecore.service
    ```
    to restart the service and start collecting metrics about the edge node.
From now on, you’ll have a cluster with 3 cloud-nodes and 1 edge-node with the kubesphere console installed on the master node (if you need more than one edge, repeat steps 2 and 3).

## 5. Cloud-app-db setup
(To be installed on one or more worker)
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
2. Click on the pod, go to `edit yaml` and add in `spec.container` (same indent of ports on row 29)
	```sh
        envFrom:
          - configMapRef:
              name: cloud-db-credentials
 	```
3. Execute the following commands to apply configmap and service for db (in `/miscConfig/cloud`):
	```sh
 	kubectl apply -f cloud-db-configmap.yaml
	kubectl apply -f cloud-db-service.yaml
	```
 
## 6. Cloud-app setup
This app simulates a situation in which the edge node sends temperature to the node that processes the information.
1. Create new workload (application workloads ->workloads) cloud-app as before: 
	- Name: `cloud-app`
	- Project: `default`
	- Docker hub: `vittolibre/cloud-app`
	- Select the same `worker` node as before
2. Click on the pod, go to `edit yaml` and add in `spec.container` (same indent of image on row 29)
   	```sh
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

## 7. Temperature mapper setup
This app simulates a temperature sensor on the edge node that sends data to the cluster. The code used is `temp-demo.go` in `/miscConfig/edge`.
1. Create a new workload as before:
	- Name: `temp-mapper`
	- Project: `default`
	- Docker hub: `iori0d/temp-mapper:latest`
	- Select the edge node in the advanced settings
2. Use the following command on the master node to verify the connection with temp mapper:
	```sh
	kubectl get device temperature -o yaml
	```
 
## 8. Mosquitto setup
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

## 9. Gateway-db setup
1. Create a new workload for gateway-db as done before:
	- Name: `edge-db`
	- Project: `default`
	- Docker hub: `vittolibre/gateway-db`
	- Set the port to `5432` as port settings
	- Select the `edge node` in the advanced settings
2. Click on the pod, go to `edit yaml` and add in `spec.container` (same indent of ports on row 29)
   	```sh
          envFrom:
            - configMapRef:
                name: cloud-db-credentials
	```
3. Apply the configmap in `/miscConfig/edge` with the following command:
	```sh
	kubectl apply -f edge-db-configmap.yaml
	```
 
## 10. Gateway-app setup
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

## 11. PGAdmin database setup
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
3. `127.0.0.1/pgadmin4` is the url to connecto to the db dashboard
4. Create new user mtdmanager
5. Create new db named mtdmanager with  mtdmanager as owner
6. Modify the `pgadmin.sql` (row 307-309 with the IP of the nodes of the cluster) in `/miscConfig`
7. To solve some conflicts delete (delete force) the mtdmanager db and recreate it again using the file via the query tool of pgadmin.
