# In this file will be provided a guide to setup the Kubernetes cluster.

- To use this configuration, you need a host machine with at least 32 GB of RAM and a CPU that supports virtualization.
- Each listed command must be executed in superuser mode.

## 1. VM Setup minimum requirements

| VM       | CPU | RAM (GB) | Disk (GB) | OS        |
|----------|-----|----------|-----------|-----------|
| Master   | 5   | 5        | 40        | Linux Lite|
| Worker   | 3   | 3        | 35        | Linux Lite|
| Worker_2 | 3   | 3        | 35        | Linux Lite|
| Edge     | 2   | 2        | 30        | Linux Lite|
| Edge_2   | 2   | 2        | 30        | Linux Lite|

- For each VM, set a bridged network card.
- Only if needed, set the IP of each VM as static.
- If you're installing the cluster on a local machine and you are using VirtulBox it is suggested to set 2 network interfaces: one NAT and the other HOST ONLY. 

If you want better performance, you can use virtual machines with Ubuntu server installed following [Ubuntu server guide](Ubuntu_Server.md).

On each VM install Docker [official guide](https://docs.docker.com/engine/install/ubuntu/) with `conntrack` and `socat` dependencies:  
   ```sh
    # Add Docker's official GPG key:
    sudo apt update
    sudo apt install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    
    # Add the repository to Apt sources:
    sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
    Types: deb
    URIs: https://download.docker.com/linux/ubuntu
    Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
    Components: stable
    Architectures: $(dpkg --print-architecture)
    Signed-By: /etc/apt/keyrings/docker.asc
    EOF
    
    sudo apt update

    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

    sudo apt install socat conntrack ebtables ipset -y
   ```
---    
## 2. Cluster Installation using [KubeKey](https://github.com/kubesphere/kubekey/tree/main/docs/en/installation)
### Steps:
1. Download KubeKey and make it executable:

    ```sh
    curl -sfL https://get-kk.kubesphere.io | sh -
    chmod +x kk
    ```

2. Check the installed version using `./kk version` if it is version 3 you can follow steps 3, 4, and 5 (check [this file](KubeKey_CMD.md) if you need more KubeKey cluster management commands) otherwise for version 4 skip to step 6
---
## KKv3
3. Create cluster config:

    ```sh
    ./kk create config --with-kubernetes v1.33.4
    ```

   Refer to [the official GitHub page](https://github.com/kubesphere/kubekey/blob/master/docs/kubernetes-versions.md) to check the latest Kubernetes supported version.

   The command using Kubesphere `./kk create config --with-kubernetes v1.23.10 --with-kubesphere v3.4.1` is not available anymore.

5. Edit configuration properly by setting `specs.hosts` with the name and the IPs, user, and password of the machine you set `specs.roleGroups` accordingly (etcd and control-plane must be set to the master node).
    ```yaml
    spec:
      hosts:
      - {name: <master_node_name>, address: <master_ip>, internalAddress: <master_ip>, user: <master_username>, password: "<password>"}
      - {name: <worker_name>, address: <worker_ip>, internalAddress: <worker_ip>, user: <worker_username>, password: "<password>"}
      # Add more worker entries as needed
      roleGroups:
        etcd:
        - <master_node_name>
        control-plane:
        - <master_node_name>
        worker:
        - <worker_name_1>
        # Add more worker names as needed
    # ... rest of the file
    ```
6. Create cluster:

    ```sh
    ./kk create cluster -f <config-name>.yaml
    ```
---
## KKv4
6. Create the node inventory and cluster configuration:
   
   ```sh
   ./kk create inventory -o .
   ./kk create config --with-kubernetes v1.33.4 -o .
   ```
   Generating `inventory.yaml` and `config-1.33.4.yaml`

7.  Configure the nodes.

      Edit `inventory.yaml` to define the SSH connection details and assign each node to a group. For example:
   ```yaml
         apiVersion: kubekey.kubesphere.io/v1
         kind: Inventory
         metadata:
           name: default
         spec:
           hosts:
             master:
               connector:
                 type: ssh
                 host: <master_ip>
                 port: 22
                 user: <master_username>
                 password: "<master_password>"
               internal_ipv4: <master_internal_ip>
         
             worker1:
               connector:
                 type: ssh
                 host: <worker_ip>
                 port: 22
                 user: <worker_username>
                 password: "<worker_password>"
               internal_ipv4: <worker_internal_ip>
         
           groups:
             k8s_cluster:
               groups:
                 - kube_control_plane
                 - kube_worker
         
             kube_control_plane:
               hosts:
                 - master
         
             kube_worker:
               hosts:
                 - worker1

             etcd:
               hosts:
                 - master
   ```
   Replace the placeholders with your node details. Add more entries under hosts and `kube_worker.hosts` for additional workers. The internal IP can be the same as the SSH address when the nodes communicate over that address.
   
   SSH keys can be used instead of passwords: set private_key under each node’s connector to the path of the private key on the machine running KubeKey. If using passwords, protect `inventory.yaml` because it contains credentials.
   
   If the cluster configuration uses external etcd, also define an etcd group and list its nodes. Consult the [inventory documentation](https://github.com/kubesphere/kubekey/blob/main/docs/en/installation/README.md) for the available fields.

8. Review the cluster configuration:

      Edit `config-v1.33.4.yaml` as needed, including the control-plane endpoint, network settings, container runtime and CNI plugin. See the official configuration reference.
      ## NOTE:
      
      If you are using Ubuntu server 26.04 with KKv4 you need to change the way sudo operates (otherwise cluster reation will fail) by using the following commands:
      ```sh
        sudo update-alternatives --set sudo /usr/bin/sudo.ws  # change from sudo-rs to sudo
        sudo update-alternatives --auto sudo                  # after lounching the creation command to return to sudo-rs
      ```

9. Create the cluster:
   ```sh
    ./kk create cluster -i inventory.yaml -c config-v1.33.4.yaml
   ```

      If your generated configuration file has a different name, use that name with -c.

10. Verify the cluster:

       On a machine with kubectl configured to access the new cluster, run: `kubectl get nodes`

Always refer to the [Official GitHub guide](https://github.com/kubesphere/kubekey) and [Support page](https://pkg.go.dev/github.com/kubesphere/kubekey#section-readme) if you need more KubeKey cluster management commands

---

If you want to install a custom application on the cluster that does not require edge nodes, you can skip the following steps and start the [setup of the framework](Framework_setup.md) itself. As an example of a cloud application, you can refer to the [bank application](Bank_setup.md) that provides a simple high-level money transfer mechanism like PayPal.

---
## 4. Adding an Edge Node in the Cluster
### N.B. The following guide relies on the use of Kubesphere, which is not open source anymore. Updates will follow.
[Add Edge Nodes Guide](https://www.kubesphere.io/docs/v3.4/installing-on-linux/cluster-operation/add-edge-nodes/)

### 1. Install KubeEdge on Master Node
[Install KubeEdge](https://www.kubesphere.io/docs/v3.4/pluggable-components/kubeedge/)
1. Log in to the KubeSphere console.
2. Go to the `CRDs` menu on the left.
3. Search for `clusterconfiguration` and click on it.
4. In Custom Resources, click on the right of `ks-installer` and select `Edit YAML`.
5. In this YAML file, navigate to `edgeruntime` (around row 71).
6. Change the value of `enabled` from `false` to `true`.
7. Change the value of `enabled` of `edgeruntime.kubeedge` from `false` to `true`.
8. Change the `advertiseAddress` to the IP of the master node to enable all KubeEdge components.
9. Click `OK`.
10. Run the following command to verify the installation:
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

As an example of an application using edge nodes, you can refer to the [temperature application](Temp_setup.md) that provides a simple application to collect simulated temperature values from the edges. More application examples are available at [official KubeEdge repository](https://github.com/kubeedge/examples).
