### General ###
aws_region = "us-east-2"

### Private Instance ###
enable_private_instance = false
ami                     = "ami-0285772523412a2f8"
instance_type           = "t4g.nano"

### VPN ###
enable_vpn                  = false
customer_gateway_ip_address = ""
customer_gateway_cidr       = "172.16.0.0/12"

### ACM ###
enable_acmpca      = false
acmpca_common_name = "example.com"
