### General ###
aws_region = "us-east-2"

### Private Instance ###
enable_private_instance = true
ami                     = "ami-0285772523412a2f8"
instance_type           = "t4g.nano"

### VPN ###
enable_vpn                  = true
customer_gateway_ip_address = ""
customer_gateway_cidr       = "172.16.0.0/16"

### ACM ###
enable_acmpca      = false
acmpca_common_name = "example.com"
