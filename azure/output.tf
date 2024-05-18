output "azure_vm_public_ip_address" {
  value = var.enable_virtual_machine ? module.vm_linux[0].public_ip : null
}

output "azure_vm_private_ip_address" {
  value = var.enable_virtual_machine ? module.vm_linux[0].private_ip_address : null
}

output "azure_ssh_vm" {
  value = var.enable_virtual_machine ? "ssh -i keys/temp_key azureuser@${module.vm_linux[0].public_ip}" : null
}

output "azure_firewall_public_ip_address" {
  value = var.enable_firewall ? module.firewall[0].public_ip : null
}
