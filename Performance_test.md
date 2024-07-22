# This file provides a guide to test the architecture with Postman and Jmeter

## 1. Postman Test
Install desktop agent and make it run on startup
Create the cloud-app-service using the following command (in mtd-manager/miscConfig/cloud): 
kubectl apply -f cloud-app-service.yaml
Connect to postman web interface and in environment create baseURL with 2 variables:
baseURL as the ip of the node on which cloud-app is installed and the port exposed in cloud-app-service
nextRequest as the name of the request
Enable env variable.
In the workspace create a new request with the provided script (ScriptPostman in mtd-manager/miscConfig/testing) into post-res and execute.
This script allows to evaluate the overhead of the requests while the pods are subject to a mtd strategy.
## 2. Jmeter test
Download jmeter tar and in the bin folder execute ./jmeter
Load the test plan (in mtd-manager/miscConfig/testing) and in the http request set the ip of the worker node on which  cloud-app is installed
Execute the test plan
This test allows us to retrieve more information from the execution of the activated mtd strategy.
