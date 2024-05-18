# AWS Site-to-Site VPN

VPN connection between AWS VPN adn Network pfSense (running on Azure).

## Setup

### Azure (step 1)


Create a key pair to use for the VM configuration:

```sh
mkdir azure/keys
ssh-keygen -f azure/keys/temp_key
chmod 600 azure/keys/temp_key
```


ssh-keygen -f azure/keys/pfsense

- Username: `admin`
- Password: `pfsense`

```sh
cloud-init status
```


### AWS (step 1)


Download configuration: Generic, ikev2

### Azure (step 2)

### Azure (step 2)

### pfSense

Add firewall rules.



https://docs.netgate.com/pfsense/en/latest/troubleshooting/ipsec-traffic.html



### WSL

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