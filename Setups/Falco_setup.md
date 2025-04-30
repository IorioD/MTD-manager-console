# In this file is explained how to install Falco component on the cluster

This component consumes event flows and evaluates security rules to detect anomalies. As a default setup, it consumes Linux kernel events and is installed on each node of the cluster using a DaemonSet.

## 1. Install Falco
   1. add the Helm repository using:
   ```sh
   helm repo add falcosecurity https://falcosecurity.github.io/charts
   helm repo update
   ```   
   2. install the component with a dedicated namespace
   ```sh
   helm install --replace falco --namespace falco --create-namespace --set tty=true falcosecurity/falco
   ```
   3. now wait for the pods to set up and run
   ```sh
   watch kubectl get pods -n falco
   ```
   now Falco is successfully installed.

## 2. Test Falco
   1. install a test pod and use it to generate potential malicious events (open a shell and expose sensitive data)
   ```sh
   kubectl run test-pod --image=alpine --command -- sleep 3600
   kubectl exec -it test-pod -- sh
   touch /bin/evil.sh
   sh -c 'cat /etc/shadow'
   ```
   2. after that, you can access the logs of the Falco pod (via the Kubephere console or via `kubectl logs -n falco <FALCO_POD_NAME> -c falco`)  showing something like
   ```sh
     10:57:56.364143568: Notice A shell was spawned in a container with an attached terminal (evt_type=execve user=root user_uid=0 user_loginuid=-1 process=sh proc_exepath=/bin/busybox parent=containerd-shim command=sh terminal=34816 exe_flags=EXE_WRITABLE|EXE_LOWER_LAYER container_id=c77ad69b9b96 container_image=alpine container_image_tag=latest container_name=k8s_test-pod_test-pod_default_ef73d4c1-fe2b-49e7-9437-486561d95c9d_0 k8s_ns=<NA> k8s_pod_name=<NA>)

     10:58:17.694265492: Warning Sensitive file opened for reading by non-trusted program (file=/etc/shadow gparent=containerd-shim ggparent=systemd gggparent=<NA> evt_type=open user=root user_uid=0 user_loginuid=-1 process=cat proc_exepath=/bin/busybox parent=sh command=cat /etc/shadow terminal=34816 container_id=c77ad69b9b96 container_image=alpine container_image_tag=latest container_name=k8s_test-pod_test-pod_default_ef73d4c1-fe2b-49e7-9437-486561d95c9d_0 k8s_ns=<NA> k8s_pod_name=<NA>)
   ``` 
  showing that a shell was created with sensitive files opened 
  
## 3. Monitor Falco
   1. install the `falcosidekick` component
   ```sh
    helm install falcosidekick falcosecurity/falcosidekick \
      --namespace falco \
      --set webui.enabled=false \
      --set config.prometheus.enabled=true
   ```
   2. apply the exporter (in `miscConfig/bank/metrics/metricsExporter-falco.yaml`):
   ```sh
    kubectl apply -f metricsExporter-falco.yaml.yaml
   ```

You can now try introducing a malicious pod on the cluster following the [attack guide](Attack.md).
