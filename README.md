# AWS Site-to-Site VPN

IPSec connection between AWS VPN and Netgate pfSense from the Azure Marketplace.

<img src=".assets/aws-pfsense.png" />

## Setup

### 1. Create the Azure resources

Copy the `.auto.tfvars` template:

```sh
cp azure/config/template.tfvars azure/.auto.tfvars
```

Set your IP CIDR address for management of the Azure resources:

```terraform
local_administrator_cidr = "1.2.3.4"
```

Create a key pair to use for the Virtual Machines configuration:

```sh
mkdir azure/keys
ssh-keygen -f azure/keys/temp_key
chmod 600 azure/keys/temp_key
```

Init and apply the Terraform configuration:

```sh
terraform init
terraform apply -auto-approve
```

Connect with SSH and check VM startup script:

```sh
cloud-init status
```

Connect to pfSense and setup the initial WAN configuration:

- Username: `admin`
- Password: `pfsense`

Now, create the AWS infrastructure and continue the Azure configuration in the next section.


### 2. Create the AWS resources

Copy the `.auto.tfvars` template:

```sh
cp aws/config/template.tfvars aws/.auto.tfvars
```

Get the pfSense public IP running on Azure and set in the configuration:

```terraform
customer_gateway_ip_address = "1.2.3.4"
```

Init and apply the Terraform configuration:

```sh
terraform init
terraform apply -auto-approve
```

In the VPC console, open the VPN Connection and download the configuration:

- Vendor: `Generic`
- Platform: `Generic`
- Software: `Vendor Agnostic`
- IKE version: `ikev2`

Connect with SSM Session Manager and check the instance startup script:

```sh
cloud-init status
```

### 3. Set the AWS tunnel IPs into the Azure configuration

While in the AWS VPN section, get the `Outside IP address` for the IPSec tunnels.

Go back to the Azure configuration, and set the IP addresses for each tunnel:

```terraform
aws_remote_gateway_ip_address_tunnel_1 = "1.2.3.4"
aws_remote_gateway_ip_address_tunnel_2 = "1.2.3.4"
```

Re-apply the configuration:

```sh
terraform apply -auto-approve
```

### 4. Configure pfSense IPSec

#### IPSec

Follow the steps detailed in the instructions downloaded from AWS for a Generic provider, add Phase 1 and Phase 2 configuration in pfSense.

<img src=".assets/aws-pfsense-ipsec-tunnels.png" />

#### Firewall rules

Add the firewall to allow traffic within the tunnels:

- IPSec
- WAN


## Let's Encrypt certificates

sudo -e /etc/wsl.conf

wsl --shutdown


```toml
[boot]
systemd=true
```

https://certbot.eff.org/instructions?ws=other&os=ubuntufocal
https://snapcraft.io/install/certbot/ubuntu


```sh
sudo certbot certonly --manual --preferred-challenges dns \
    -d vpn-azure.pomatti.io \
    -m evandro@pomatti.io
```

```sh
sudo certbot certonly --manual --preferred-challenges dns \
    -d vpn-aws.pomatti.io \
    -m evandro@pomatti.io
```

```
Certificate is saved at: /etc/letsencrypt/live/vpn-azure.example.com/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/vpn-azure.example.com/privkey.pem
```

```
Certificate is saved at: /etc/letsencrypt/live/vpn-azure.example.com/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/vpn-azure.example.com/privkey.pem
```

 https://toolbox.googleapps.com/apps/dig/#TXT/_acme-challenge.vpn-azure.pomatti.io.

## Setup pfSense

https://eff-certbot.readthedocs.io/en/stable/using.html#manual


vpn-azure.example.com
vpn-aws.example.com


A registry


Set the name

Set the domain

### CA

https://www.comparitech.com/blog/vpn-privacy/openvpn-server-pfsense/

Create the internal CA
Create the server internal certificate

https://docs.netgate.com/pfsense/en/latest/recipes/openvpn-s2s-tls.html


https://youtu.be/I61t7aoGC2Q


https://www.youtube.com/watch?v=nz__4KBKIGE

https://c86.medium.com/setup-site-to-site-vpn-to-aws-with-pfsense-1cac16623bd6
https://youtu.be/15amNny_kKI

###


```sh
az vm image list --location eastus2 --publisher netgate --offer pfsense-plus-public-cloud-fw-vpn-router --sku pfsense-plus-public-tac-lite --all
```

```sh
az vm image list-publishers --location eastus2 --query [].name --output table | grep netgate
az vm image list-offers --location eastus2 --publisher netgate --output table
az vm image list-skus --location eastus2 --publisher netgate --offer pfsense-plus-public-cloud-fw-vpn-router --query [].name --output table
```

## Reference

https://youtu.be/p83RmeT2Q-A