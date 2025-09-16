# This file will provide some useful KubeKey commands for node management.

[Official GitHub guide](https://github.com/kubesphere/kubekey)

## ADD and DELETE node

To add a new node, append the new node information to the cluster config file generated when you installed the cluster and then apply the changes using the following command.
```sh
./kk add nodes -f <config-name>.yaml
```
    
To delete a node, select it from the node list
```sh
kubectl get nodes
```
    
and then execute 
```sh
./kk delete node <nodeName> -f <config-name>.yaml
```

## Delete the cluster

If you want to delete the whole cluster, just execute
```sh
./kk delete cluster [-f <config-name>.yaml.yaml]
```

## Upgrade the cluster

When using the Multi-node process, we can upgrade the cluster using a specific configuration file.
```sh
./kk upgrade [--with-kubernetes version] [(-f | --file) path] 
```
If running the commands using the -–with-kubernetes flag, the configuration file will also be amended. Alternatively, we can use the -f flag to specify which configuration file was built for the cluster creation.

If you don't have the configuration file, use the following command to retrieve it:
```sh
./kk create config [--from-cluster] [(-f | --filename) path] [--kubeconfig path]
```
