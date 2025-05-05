## 3. Application metrics retrieval using Grafana

If you installed [Grafana](Grafana_setup.md) it is now possible to manage and visualize all the metrics related to the single pods. To use such a mechanism, you need to set up the proper exporters.

### 1. MySQL metrics
   1. To setup the environment run:
   ```sh
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts/
   helm repo update prometheus-community
   helm search repo prometheus-community
   ```
   If in the output of the last command you see the entry `prometheus-community/prometheus-mysql-exporter` everything is working correctly.
   
   2. to install the exporter run:
   ```sh
   helm install mysql-exporter prometheus-community/prometheus-mysql-exporter --namespace bank-project --values <FILE_PATH>
   ```
   where <FILE_PATH> is the path to the MySQL metrics exporter yaml file (`miscConfig/bank/metrics/metricsExporter-mysql.yaml`).
   The resulting NOTES section often provides access methods, but for integrating with Prometheus within the cluster, the exporter's service is what Prometheus will scrape, not typically accessed via port-forward.
   
   3. now you can import the dashboard from `miscConfig/bank/metrics/grafanaDashboard-MySQL-metrics.json`
---
### 2. Frontend metrics
   1. to setup the exporter, run:
   ```sh
   kubectl apply -f metricsExporter-frontend.yaml.yaml -n bank-project
   ```
   where metricsExporter-frontend.yaml is in the miscConfig directory (`miscConfig/bank/metrics/metricsExporter-frontend.yaml`).
   
   2. now you can import the dashboard from `miscConfig/bank/metrics/grafanaDashboard-frontend-metrics.json`
---
### 3. Backend metrics
   In this case, no exporters are needed, since they are included in the deployment file. You can import the dashboard from `miscConfig/bank/metrics/grafanaDashboard-backend-metrics.json`
