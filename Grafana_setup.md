# In this file will be explained the process for installing and setting up the Grafana interface.

The following actions must be performed on the master node.

## 1. Grafana setup
  1. execute:
    ```sh
      helm repo add grafana https://grafana.github.io/helm-charts
      helm install grafana grafana/grafana \
        --namespace monitoring --create-namespace \
        --set adminPassword='admin' \
        --set service.type=NodePort
    ```
    to install the Grafana system, create the monitoring namespace, and set up the environment.
  
  2. to grant persistence to the pod, create the following yaml file in the PVC section of the KubeSphere console
    ```yaml
      apiVersion: v1
      kind: PersistentVolumeClaim
      metadata:
        name: grafana-pvc
      spec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 1Gi
    ```
    and modify the yaml file of the deployment adding the volumes:
    ```yaml
            volumeMounts:
              - mountPath: /var/lib/grafana
                name: grafana-pv
        volumes:
          - name: grafana-pv
            persistentVolumeClaim:
              claimName: grafana-pvc
    ```
  
  3. once the service is up and running, in the services' menu of the KubeSphere console, retrieve the exposed port and connect to `http://<MASTER_IP>:<PORT>`
     to access the UI with `admin` as username and password (after the first access you are forced to change it).
  
  4. in the Grafana menu, go to `Connection` -> `Data Source` -> `Add data source` and choose `Prometheus`. In the tab just add `http://<MASTER_IP>:<PROMETHEUS_PORT>`
     in the `Connection` field then click `Save & test` to apply. Now Grafana is connected to Prometheus and allows metrics visualization.

## 2. Cluster metrics visualization
  1. in the Grafana menu, go to `Dashboard` -> `New` -> `New dashboard` -> `Add visualization`, and choose `Prometheus` as data source
  2. from the panel that opens you can compose your query in the lower section; click on `Code` to input the sting manually and then `Run queries` to test:
     
