# Bank payment management system
To install this application on the cluster, you need the yaml files in `miscConfig/bank`.

The following image describes at high level how the application is intended to be deployed using MACM formalism.
![Alt text](miscConfig/App_MACM.png "MACM")

## 1. Database setup
1. download the `mysql-deployment.yaml` file on your master
2. change row 29 with the name of the worker you want to use
3. run
	```sh
  	kubectl create secret generic backend-secrets --from-literal=db_password='rootpassword' --from-literal=secret_key='rootpassword'
  	```
  	to create the secrets i.e., the database access credentials.
  
4. run
  	```sh
  	kubectl apply -f mysql-deployment.yaml
  	```
  	to apply the deployment on the cluster.
  
5. run
	```sh
  	kubectl get pods
  	```
  	to confirm that the pod is up and running (you can even use the kubesphere console).
  
6. run
  	```sh
  	kubectl exec -it <POD_NAME> -- mysql -u root -p
  	```
  	to access the pod and, when required, insert `rootpassword` as access password.
  
7. run
  	```sql
  	show databases;
  	```
  	to confirm that bankdb has been created. If not run
  	```sql
  	create database bankdb;
  	```
8. run
  	```sql
  	use bankdb;
  	```
  	to enter the database

9. build `users` and `transactions` tables with the following commands:
	```sql
	CREATE TABLE users ( 
	    id INT AUTO_INCREMENT PRIMARY KEY,
	    name VARCHAR(50) NOT NULL,
	    surname VARCHAR(50) NOT NULL,
	    email VARCHAR(100) NOT NULL UNIQUE,
	    password VARCHAR(255) NOT NULL,
	    balance DECIMAL(10,2) NOT NULL DEFAULT 0.00
	);

  	CREATE TABLE transactions(
 	    id INT AUTO_INCREMENT PRIMARY KEY,
 	    id_sender INT NOT NULL,
  	    email_sender VARCHAR(255) NOT NULL,
  	    id_receiver INT NOT NULL,
  	    email_receiver VARCHAR(255) NOT NULL,
  	    amount DECIMAL(10,2) NOT NULL,
  	    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  	    description TEXT NULL
 	);
 	```
10. populate the tables with example values
	```sql
  	INSERT INTO users (name, surname, email, password, balance) 
	VALUES 
	('Giovanni', 'Rossi', 'giovanni.rossi@email.com', 'pbkdf2:sha256:260000$D4kuLfbAZTEqwgNs$2a54fd573638b8579e8fe5065de2b98463ffb3063820938f6c2b965c969bbf2d', 500.00), 
	('Maria', 'Bianchi', 'maria.bianchi@email.com', 'pbkdf2:sha256:260000$cPNofnRIMNt88UYH$3bdcc1f225c222cb9cd1b9eac5f38e15434653848d01e81114c1a67eda0b2fc7', 1000.00),
	('Luca', 'Verdi', 'luca.verdi@email.com', 'pbkdf2:sha256:260000$eWmItAkdLFqZhggI$d7e39d8c9e101f6bbb98e641c1ad2c476ff5aa172d5c955b27683944444340f2', 1500.00),
	('Anna', 'Neri', 'anna.neri@email.com', 'pbkdf2:sha256:260000$vyyRyHIxtVKyr5Sk$11776308bf0b4a9d4bc6a6d6f02d2177db672ebcf0d8e1ea7be8679cf85af0fe', 2000.00),
	('Marco', 'Gialli', 'marco.gialli@email.com', 'pbkdf2:sha256:260000$23uECGvUNaUrWLCb$2fda8024bec75830fe97d7279867652b2933dc00d870fbfa9968c643b8c1228e', 2500.00);

 	INSERT INTO transactions (id_sender, email_sender, id_receiver, email_receiver, amount, description)
	VALUES (
 	    3, 
  	    'luca.verdi@email.com', 
  	    1, 
  	    'giovanni.rossi@email.com', 
  	    10.00, 
  	    'acconto vacanza'
 	);

	INSERT INTO transactions (id_sender, email_sender, id_receiver, email_receiver, amount, description)
	VALUES (
  	    1, 
  	    'giovanni.rossi@email.com', 
  	    3, 
  	    'luca.verdi@email.com', 
  	    10.00, 
  	    'rimborso vacanza'
 	);
  	```
 	To grant password security, in the database are stored hashed password values. The password itself is the name of the user with the capital letter.

## 2. Front & back end deployment

Depending on the names of your workers and how you connect to the cluster (via the VM browser if you used the linux lite configuration or via the host browser if you are using the server configuration with windows host), you need to perform only one of the following steps.

1. Use of the `VM BROWSER` and nodes are named `master`, `worker1` and `worker2`: 
   on the master run
   ```sh
   kubectl apply -f backend_deployment.yaml
   kubectl apply -f frontend_deployment.yaml
   ```

2. Use of the `VM BROWSER` and nodes are named differently than `master`, `worker1` and `worker2`: 
   enter the `/etc/hosts` file of your master machine and add the machine name on the same row where kubekey hosts are specified
   changing from this
   ```yaml
   # kubekey hosts BEGIN
        <IP_WORKER>  worker1.cluster.local worker01
        <IP_WORKER2>  worker2.cluster.local worker02
   ```
   to this
   ```yaml
   # kubekey hosts BEGIN
        <IP_WORKER>  worker1.cluster.local worker01 worker1
        <IP_WORKER2>  worker2.cluster.local worker02 worker2
   ```
   i.e., add a space after your machine name (worker01, and worker02) and then the correct name (worker1, and worker2). Change row 16 of `backend_deployment.yaml` and row 23 of `frontend_deployment.yaml` using your machine name. Afterward, on the master run:
   ```sh
   kubectl apply -f backend_deployment.yaml
   kubectl apply -f frontend_deployment.yaml
   ```
   
3. Use of the `HOST BROWSER` and nodes are named `master`, `worker1` and `worker2`: 
   go to `C:\Windows\System32\drivers\etc\hosts` and add the IP and the names master, worker1, worker2 (use TAB to space):
   ```yaml
	# Copyright (c) 1993-2009 Microsoft Corp.
	…
	# localhost name resolution is handled within DNS itself.
	# 127.0.0.1       localhost
	# ::1             localhost

	<IP_MASTER>	master
	<IP_WORKER1>	worker1
	<IP_WORKER2>	worker2 
	------
   ```
   and then on the master run
   ```sh
   kubectl apply -f backend_deployment.yaml
   kubectl apply -f frontend_deployment.yaml
   ```

4. Use of the `HOST BROWSER` and nodes are named differently than `master`, `worker1` and `worker2`: 
   go to `C:\Windows\System32\drivers\etc\hosts` and add the IP and the names master, worker1, worker2 (use TAB to space):
   ```yaml
	# Copyright (c) 1993-2009 Microsoft Corp.
	…
	# localhost name resolution is handled within DNS itself.
	# 127.0.0.1       localhost
	# ::1             localhost

	<IP_MASTER>	master
	<IP_WORKER1>	worker1
	<IP_WORKER2>	worker2 
	------
   ```
   then enter the `/etc/hosts` file on your master machine and add the machine name on the same row where kubekey hosts are specified
   changing from this
   ```yaml
   # kubekey hosts BEGIN
        <IP_WORKER>  worker1.cluster.local worker01
        <IP_WORKER2>  worker2.cluster.local worker02
   ```
   to this
   ```yaml
   # kubekey hosts BEGIN
        <IP_WORKER>  worker1.cluster.local worker01 worker1
        <IP_WORKER2>  worker2.cluster.local worker02 worker2
   ```
   i.e., add a space after your machine name (worker01, and worker02) and then the correct name (worker1, and worker2). Change row 16 of `backend_deployment.yaml` and row 23 of `frontend_deployment.yaml` using your machine name. Afterward, on the master run:
   ```sh
   kubectl apply -f backend_deployment.yaml
   kubectl apply -f frontend_deployment.yaml
   ```

It is important that you use `master`, `worker1` and `worker2` as machine names in the DNS files to keep consistency between frontend and backend callbacks.

After checking that every service is installed and running using the kubesphere console, you can connect to http://worker1:31566/ to access the main login page of the application.

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
     helm install mysql-exporter prometheus-community/prometheus-mysql-exporter --namespace default --values <FILE_PATH>
   ```
   where <FILE_PATH> is the path to the MySQL metrics exporter yaml file (`miscConfig/bank/metrics/metricsExporter-mysql.yaml`)
   
   3. now you can import the dashboard from `miscConfig/bank/metrics/grafanaDashboard-MySQL-metrics.json`

### 2. Frontend metrics
   1. to setup the exporter, run:
   ```sh
     kubectl apply -f metricsExporter-frontend.yaml.yaml
   ```
   where metricsExporter-frontend.yaml is in the miscConfig directory (`miscConfig/bank/metrics/metricsExporter-frontend.yaml`).
   
   2. now you can import the dashboard from `miscConfig/bank/metrics/grafanaDashboard-frontend-metrics.json`

### 3. Backend metrics
   In this case, no exporters are needed, since they are included in the deployment file. You can import the dashboard from `miscConfig/bank/metrics/grafanaDashboard-backend-metrics.json`
