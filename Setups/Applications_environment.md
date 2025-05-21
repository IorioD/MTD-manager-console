# This file provides the steps to follow to create a workspace in the cluster for the application and set up HTTPS connections

## 1. Initial Configuration in Kubesphere
Configuration of the necessary workspaces and projects within Kubesphere.

1.  Access the **Kubesphere Control Panel**.
2.  Navigate to `Platform` (top left corner) -> `Access Control`.
3.  Select `Workspaces` and click on `Create`.
    * Name the new workspace `<APP_NAME>-workspace`.
    * Set `admin` (or another existing user in the cluster) as the **Administrator**.
    * Click `Create` to create the workspace.
4.  Access the newly created workspace (`<APP_NAME>-workspace`).
5.  Navigate to `Projects` -> `Create`.
    * Name the project `<APP_NAME>-project`.
    * Click `Create` to create the project.
---
  
## 2. Configure the Project

Within the `<APP_NAME>-project`, we will enable the Gateway and configure a TLS Secret to grant HTTPS access.

### 2.1 Enabling the Project Gateway

The Gateway is required to exhibit project services outside the cluster.

1.  Inside `<APP_NAME>-project`, navigate to `Project Settings` -> `Gateway Settings`.
2.  Click on `Enable Gateway`.
3.  Confirm the operation by clicking `OK` or `Enable`.

### 2.2 Configure the TLS Secret for HTTPS

To enable secure access via HTTPS, a TLS certificate is needed. We will create a self-signed certificate for testing purposes.

1.  On the master node execute the following command to generate a self-signed certificate and private key (not best practice, just as example):

    ```bash
    openssl req -x509 -nodes -newkey rsa:2048 -keyout tls.key -out tls.crt -days 365 -subj "/CN=bank.local"
    ```
    
    This command will create two files in the current directory: `tls.crt` (the certificate) and `tls.key` (the private key).
2.  Return to the Kubesphere UI, within `<APP_NAME>-project`.
3.  Navigate to `Configuration` -> `Secrets`.
4.  Click on `Create`.
    * Enter `https-secrets` as the **Name**.
    * Click `Next`.
    * Select `TLS Information` as the **Type**.
5.  Open the `tls.crt` file and copy the entire content including `-----BEGIN...-----` and `-----END...-----`.
6.  Paste the content of `tls.crt` into the section labeled **Certificate**.
7.  Open the `tls.key` file and copy the entire content including `-----BEGIN...-----` and `-----END...-----`.
8.  Paste the content of `tls.key` into the section labeled **Private Key**.
9.  Click `Create` to create the Secret.
