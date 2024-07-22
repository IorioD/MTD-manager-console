# In this file will be provided a guide to setup the kubernetes cluster.

# Cluster Setup Guide

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

Follow the steps below to add an edge node to your KubeSphere cluster.

## 1. Install KubeEdge on Master Node

### Install KubeEdge
Follow the instructions to install KubeEdge: [Install KubeEdge](https://www.kubesphere.io/docs/v3.4/pluggable-components/kubeedge/)

### Configure KubeEdge in KubeSphere

1. Log in to the KubeSphere console.
2. Go to the `CRDs` menu on the left.
3. Search for `clusterconfiguration` and click on it.
4. In Custom Resources, click on the right of `ks-installer` and select `Edit YAML`.
5. In this YAML file, navigate to `edgeruntime` (around row 71).
6. Change the value of `enabled` from `false` to `true`.
7. Change the `advertiseAddress` to the IP of the master node to enable all KubeEdge components.
8. Click `OK`.

### Verify Installation

Run the following command to verify the installation:

```sh
kubectl logs -n kubesphere-system $(kubectl get pod -n kubesphere-system -l 'app in (ks-install, ks-installer)' -o jsonpath='{.items[0].metadata.name}') -f
```
