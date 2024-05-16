# aws-azure-site-to-site-vpn


az vm image terms accept --urn bitnami:rabbitmq:rabbitmq:latest

ssh-keygen -f azure/keys/pfsense

- Username: `admin`
- Password: `pfsense`

###


```sh
az vm image list --location eastus2 --publisher netgate --offer pfsense-plus-public-cloud-fw-vpn-router --sku pfsense-plus-public-tac-lite --all
```

```sh
az vm image list-publishers --location eastus2 --query [].name --output table | grep netgate
az vm image list-offers --location eastus2 --publisher netgate --output table
az vm image list-skus --location eastus2 --publisher netgate --offer pfsense-plus-public-cloud-fw-vpn-router --query [].name --output table
```

