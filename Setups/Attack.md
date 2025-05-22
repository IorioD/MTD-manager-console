# This file provides a guide to attack a pod in the cluster

1. Install a kali (yaml file in `miscConfig/kali-pod.yaml`) pod and access it:
   ```sh
   kubectl create namespace attack
   kubectl apply -f kali-pod.yaml --namespace attack
   kubectl exec -it kali -n attack -- bash
   ```
2. since it is an attacker used to test the system run:
   ```sh
     apt update
     apt install -y curl
     apt install -y nmap
     apt install -y hping3
     apt install -y sqlmap
     apt install -y apache2-utils
   ```
3. find the IP and the SERVICE PORT of the target pod and then you can run for example:
   ```sh
     curl http://<POD_IP>:<SERVICE_PORT>
     nmap -p 1-65535 <POD_IP>
     timeout 6000 ab -n 1000000 -c 100 http://<POD_IP>:<SERVICE_PORT>/
   ```
   the last command simulates a DoS attack.
