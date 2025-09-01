# This file provides a guide on the proper setup of the ubuntu servers.
The hardware requirements are the same as reported in [How to Kubernetes](How_to_kubernetes.md) and remember the bridged mode for the network.

## 1. ISO Download and setup
1. Visit the [official web page](https://ubuntu.com/download/server) to download the iso.
2. You can use both `VMware workstation` or `Virtual Box` or any other hypervisor to create and manage the VMs.
3. During the installation process, leave all the default settings and select "install the OpenSSH Server".
4. Once the installation is performed, access each machine and run:
     ```sh
    sudo apt update
    sudo apt upgrade
    ```
5. If you did not use the gui for the installation, you need to run
   ```sh
    sudo apt install openssh-server
    ```
   to install the ssh and then restart the system.

## 2. Static IP setup
To avoid the changing of the IP of the VMs, you can set a static IP as follows:
1. Run
    ```sh
    sudo nano /etc/netplan/50-cloud-init.yaml
    ```
    to access the netplan file
2. modify the file as follows
    ```yaml
    network:
      version: 2
      ethernets:
        ens33:
          addresses:
            - <VM_Address>/24
          routes:
          - to: default
            via: <GatewayIP>
          nameservers:
            addresses: [8.8.8.8, 8.8.4.4]
    ```
    where `ens33` is the name of the network card, `<VM_Address>` is the IP that you want for your machine (use the same provided when running `ip a` in your terminal) and `<GatewayIP>` is the IP that allows you to connect to your router dashboard.
3. run:
    ```sh
    sudo netplan apply
    ```
4. Now your machine configuration is complete.

N.B. If you're using the NAT+HOST ONLY configuration, check the gateway IP of the ethernet adapter (192.168.56.x) to set the static IP.

## 3. Advanced management
If you are using a Windows machine as host and want to ease the VMs management, you can install a tool such as [MobaXTerm](https://mobaxterm.mobatek.net/). 
On each VM check if the ssh server is running:
```sh
systemctl status ssh
```

If it is not running, execute the following commands:

```sh
sudo systemctl start ssh
sudo systemctl enable ssh
```

Once everything is setup, you can create a MobaxTerm session for each VM using the selected static IP and use the VM credentials to access it. Furthermore, you can access all the dashboards from the browser of the host machine.

Now you can continue with step 2 of [How to Kubernetes](How_to_kubernetes.md).
