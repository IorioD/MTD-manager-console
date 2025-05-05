# In this file will be explained the process for installing and setting up the Grafana interface.

The following actions must be performed on the master node.

## 1. Grafana setup
  1. execute:
   ```bash
      kubectl apply -f grafana-deployment.yaml --namespace=monitoring
   ```
  to install the Grafana system, persistent volume claims and service within the monitoring namespace. `grafana-deployment.yaml` is in `miscConfig` folder.
  
  Wait a few moments for Grafana pods to start. Check their status:
   ```bash
   kubectl get pods -n monitoring
   ```
   Wait until the pod shows a Running status.
  
  2. Once the service is up and running, in the services' menu of the KubeSphere console, retrieve the exposed port and connect to `http://<MASTER_IP>:<PORT>` to access the UI with `admin` as username and password (after the first access you are forced to change it).
  
  3. in the Grafana menu, go to `Connection` -> `Data Source` -> `Add data source` and choose `Prometheus`. In the tab just add `http://<MASTER_IP>:<PROMETHEUS_PORT>` in the `Connection` field then click `Save & test` to apply (PROMETHEUS_PORT can be found in the services menu under prometheus-nodeport). Now Grafana is connected to Prometheus and allows metrics visualization.

## 2. Cluster metrics visualization
  1. in the Grafana menu, go to `Dashboard` -> `New` -> `New dashboard` -> `Add visualization`, and choose `Prometheus` as data source
  2. from the panel that opens, you can compose your query in the lower section; click on `Code` to input the sting manually and then `Run queries` to test it
  3. you can change the refresh period of the query by changing the `Refresh` value on top of the diagram.
  4. save the dashboard, rename it, and then the query diagram will appear in the dashboard section of Grafana.

You can import a dashboard using the menu `Dashboard` -> `New` -> `Import` and selecting a json file or copy-pasting the code (`miscConfig/grafanaDashboard-cluster-metrics.json` is the file for the cluster metrics dashboard).

The following queries are for CPU, Memory and Disk usage.
```sh
100 - (avg by (instance)(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
100 * (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes))
100 - (avg by (instance) (node_filesystem_free_bytes{fstype!="tmpfs",fstype!="overlay"}) / avg by (instance) (node_filesystem_size_bytes{fstype!="tmpfs",fstype!="overlay"})) * 100
``` 
If you want, you can retrieve metrics of a specific service after setting up and deployng the proper metric extractor (see [step 3 of the bank app setup](Bank_setup.md) as an example).
