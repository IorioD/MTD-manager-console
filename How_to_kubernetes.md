# In this file will be provided a guide to setup the kubernetes cluster.

Each listed command must be executed in superuser mode.

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

7. The IP matches with the IP of the master node.

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

  
```sh
d 
```
