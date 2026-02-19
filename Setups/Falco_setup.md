# In this file is explained how to install Falco component on the cluster

This component consumes event flows and evaluates security rules to detect anomalies. As a default setup, it consumes Linux kernel events and is installed on each node of the cluster using a DaemonSet. [Official guide to install Falco in Kubernetes](https://falco.org/docs/getting-started/falco-kubernetes-quickstart/).

## 1. Install Falco (probes installed on each node)
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
   
   For the implemented rules refer to [this file](../miscConfig/falco/falco-rules.yaml)

## 2. Test Falco
   1. install a test pod and use it to generate potential malicious events (open a shell and expose sensitive data)
   ```sh
   kubectl run test-pod --image=alpine --command -- sleep 3600
   kubectl exec -it test-pod -- sh
   touch /bin/evil.sh
   sh -c 'cat /etc/shadow'
   ```
   2. after that, you can access the logs of the Falco pod (via the Kubephere console or via `kubectl logs -n falco <FALCO_POD_NAME> -c falco` where FALCO_POD_NAME is the name of the falco pod on the same node on which the test pod has been installed)  showing something like
   ```sh
     10:57:56.364143568: Notice A shell was spawned in a container with an attached terminal (evt_type=execve user=root user_uid=0 user_loginuid=-1 process=sh proc_exepath=/bin/busybox parent=containerd-shim command=sh terminal=34816 exe_flags=EXE_WRITABLE|EXE_LOWER_LAYER container_id=c77ad69b9b96 container_image=alpine container_image_tag=latest container_name=k8s_test-pod_test-pod_default_ef73d4c1-fe2b-49e7-9437-486561d95c9d_0 k8s_ns=<NA> k8s_pod_name=<NA>)

     10:58:17.694265492: Warning Sensitive file opened for reading by non-trusted program (file=/etc/shadow gparent=containerd-shim ggparent=systemd gggparent=<NA> evt_type=open user=root user_uid=0 user_loginuid=-1 process=cat proc_exepath=/bin/busybox parent=sh command=cat /etc/shadow terminal=34816 container_id=c77ad69b9b96 container_image=alpine container_image_tag=latest container_name=k8s_test-pod_test-pod_default_ef73d4c1-fe2b-49e7-9437-486561d95c9d_0 k8s_ns=<NA> k8s_pod_name=<NA>)
   ``` 
  showing that a shell was created with sensitive files opened 
  
## 3. Install Falco Sidekick and access UI (Falco alerts borker)
   1. install the `falcosidekick` component to get the UI
   ```sh
    helm upgrade --namespace falco falco falcosecurity/falco --set falcosidekick.enabled=true --set falcosidekick.webui.enabled=true --set falcosidekick.webui.service.type=NodePort --set falcosidekick.config.talon.address=http://falco-talon:2803
   ```
   The last 2 options are used to send the alerts to the falco talon engine.

   2. run the following command to identify the name of the ui service
   ```sh
   kubectl -n falco get svc
   ```
   
   3. run the following command and change the `spec.type` from `ClusterIP` to `NodePort`.
   ```sh
   kubectl edit svc <SERVICE_NAME> -n falco
   ```
   once it is done, a node port will be assigned to the service.
   
   4. you can now connect to `http://<MASTER_IP>:<NODE_PORT>` to access the UI with `admin` as username and password.

Alternatively, you can edit the setting by locating the service in the Kubesphere UI and change the yaml. 

You can now try introducing a malicious pod on the cluster following the [attack guide](Attack.md).

## 4. Install Falco Talon (response engine)
   1. update the helm repo
   ```sh
    helm repo update falcosecurity
   ```

   2. deploy falco talon chart
   ```sh
   helm upgrade --install falco-talon falcosecurity/falco-talon --namespace falco
   ```
   
   3. check whether the pods are running properly
   ```sh
   kubectl get pods -n falco | grep falco-talon
   ```
   once it is done, Falco Talon is active and running and is ready to operate.

   For the implemented rules refer to [this file](../miscConfig/falco/falco-talon-rules.yaml)

## 5. Set Persistent Log Storage for Falco Talon
   1. First, you need to define the persistent storage request for Falco Talon (This PVC acts as a claim for storage space in your cluster) as done in  `miscConfig/falco/falco-talon-logs-pvc.yaml`
   ```sh
   kubectl apply -f falco-talon-logs-pvc.yaml
   ```

   2. modify the Falco Talon Deployment.yaml as follows
   ```yaml
   kind: Deployment
   apiVersion: apps/v1
   metadata:
     name: falco-talon
     namespace: falco
     labels:
       app.kubernetes.io/instance: falco-talon
       app.kubernetes.io/managed-by: Helm
       app.kubernetes.io/name: falco-talon
       app.kubernetes.io/part-of: falco-talon
       app.kubernetes.io/version: 0.3.0
       helm.sh/chart: falco-talon-0.3.0
     annotations:
       deployment.kubernetes.io/revision: '5'
       meta.helm.sh/release-name: falco-talon
       meta.helm.sh/release-namespace: falco
   spec:
     replicas: 1
     selector:
       matchLabels:
         app.kubernetes.io/instance: falco-talon
         app.kubernetes.io/name: falco-talon
     template:
       metadata:
         creationTimestamp: null
         labels:
           app.kubernetes.io/instance: falco-talon
           app.kubernetes.io/name: falco-talon
         annotations:
           secret-checksum: 74234e98afe7498fb5daf1f36ac2d78acc339464f950703b8c019892f982b90b
       spec:
         volumes: # <--- This is the 'volumes' section of the pod. Add the PVC volume here.
           - name: rules
             configMap:
               name: falco-talon-rules
               defaultMode: 420
           - name: config
             secret:
               secretName: falco-talon-config
               defaultMode: 420
           # --- START ADDITION FOR PVC VOLUME ---
           - name: falco-talon-logs-volume # Internal name for this volume.
             persistentVolumeClaim:
               claimName: falco-talon-logs-pvc # **IMPORTANT: This must match the PVC name from Phase 1.**
           # --- END ADDITION FOR PVC VOLUME ---
         containers:
           - name: falco-talon
             image: 'falco.docker.scarf.sh/falcosecurity/falco-talon:0.3.0'
             args:
               - server
               - '-c'
               - /etc/falco-talon/config.yaml
               - '-r'
               - /etc/falco-talon/rules.yaml
             ports:
               - name: http
                 containerPort: 2803
                 protocol: TCP
               - name: nats
                 containerPort: 4222
                 protocol: TCP
             env:
               - name: LOG_LEVEL
                 value: info
             resources: {}
             volumeMounts: # <--- This is the 'volumeMounts' section for the container. Mount the PVC volume here.
               - name: config
                 readOnly: true
                 mountPath: /etc/falco-talon/config.yaml
                 subPath: config.yaml
               - name: rules
                 readOnly: true
                 mountPath: /etc/falco-talon/rules.yaml
                 subPath: rules.yaml
               # --- START ADDITION FOR PVC VOLUME MOUNT ---
               - name: falco-talon-logs-volume # Must match the volume 'name' defined in the `volumes` section above.
                 mountPath: /var/falco-talon-logs # **IMPORTANT: This is the path inside the container where Falco Talon will write logs.**
               # --- END ADDITION FOR PVC VOLUME MOUNT ---
             livenessProbe:
               httpGet:
                 path: /healthz
                 port: http
                 scheme: HTTP
               initialDelaySeconds: 10
               timeoutSeconds: 1
               periodSeconds: 5
               successThreshold: 1
               failureThreshold: 3
             readinessProbe:
               httpGet:
                 path: /healthz
                 port: http
                 scheme: HTTP
               initialDelaySeconds: 10
               timeoutSeconds: 1
               periodSeconds: 5
               successThreshold: 1
               failureThreshold: 3
             terminationMessagePath: /dev/termination-log
             terminationMessagePolicy: File
             imagePullPolicy: Always
         restartPolicy: Always
         terminationGracePeriodSeconds: 30
         dnsPolicy: ClusterFirst
         serviceAccountName: falco-talon
         serviceAccount: falco-talon
         securityContext:
           runAsUser: 1234
           fsGroup: 1234
         schedulerName: default-scheduler
     strategy:
       type: RollingUpdate
       rollingUpdate:
         maxUnavailable: 25%
         maxSurge: 25%
     revisionHistoryLimit: 10
     progressDeadlineSeconds: 600
   ```
   Save the changes to your Deployment.yaml (ensure you're using the correct file name), then apply it to your cluster. Kubernetes will roll out the update, restarting the Falco Talon pod with the new volume configuration.
   ```sh
   kubectl apply -f your-falco-talon-deployment.yaml
   ```
   
   3. Access the logs
   Now that Falco Talon is configured to save logs to the PVC, and the PVC is powered by OpenEBS Local PV, here's how you can access those logs directly. Direct node access is the fastest and most efficient because your Local PV data is physically on the filesystem of the node where the PV is located.
   
   3.1  **Identify the PersistentVolume (PV) and its associated node/path:**
       First, find which node your `falco-talon-logs-pvc` is bound to and the specific path of the PV on that node.
   
   ```bash
    # Get the PV name associated with your PVC
    kubectl get pvc falco-talon-logs-pvc -n falco -o jsonpath='{.spec.volumeName}'
   
    # Then, describe the PV to find its node and path. Replace <PV_NAME_FROM_ABOVE> with the actual PV name.
    kubectl get pv pvc-62c0a4e7-dc4b-41fb-9eb1-87fe8d37a28b -o yaml | grep "path:"
   ```
       
   3.2  **SSH into the identified node:**
       Connect to the Kubernetes node you identified in the previous step (e.g., `worker1`) using SSH. You'll need the appropriate SSH user and the node's IP address or hostname.
   
   ```bash
       ssh <ssh_user>@<node_ip_or_hostname>
       # Example: ssh ubuntu@192.168.1.10 (if 'worker1' has IP 192.168.1.10)
   ```
   
   3.3  **Navigate and view logs on the node:**
       Once connected via SSH, you'll need to navigate to the PV's directory on the node, and then into the `falco-talon-logs/` subdirectory (which is the `mountPath` you specified in the Falco Talon Deployment).
   
   ```bash
       sudo su - # You might need root privileges to access /var/openebs directories
       cd /<PV_PATH_ON_NODE_FROM_STEP_1>/falco-talon-logs/
       # Example: cd /var/openebs/local/pv-62c0a4e7-dc4b-41fb-9eb1-87fe8d37a28b/falco-talon-logs/
   ```
