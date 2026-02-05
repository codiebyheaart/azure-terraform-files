# Resource Group Outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.main.id
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}

# Virtual Machine Outputs
output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.name
}

output "vm_id" {
  description = "ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.id
}

output "vm_size" {
  description = "Size of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.size
}

output "admin_username" {
  description = "Admin username for the VM"
  value       = azurerm_linux_virtual_machine.main.admin_username
}

# Network Outputs
output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_address_space" {
  description = "Address space of the virtual network"
  value       = azurerm_virtual_network.main.address_space
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = azurerm_subnet.main.name
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = azurerm_subnet.main.id
}

output "subnet_address_prefix" {
  description = "Address prefix of the subnet"
  value       = azurerm_subnet.main.address_prefixes
}

# Network Security Group
output "nsg_name" {
  description = "Name of the network security group"
  value       = azurerm_network_security_group.main.name
}

output "nsg_id" {
  description = "ID of the network security group"
  value       = azurerm_network_security_group.main.id
}

# IP Address Outputs
output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.main.ip_address
}

output "private_ip_address" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.main.private_ip_address
}

output "public_ip_fqdn" {
  description = "Fully qualified domain name of the public IP"
  value       = azurerm_public_ip.main.fqdn
}

# Network Interface
output "network_interface_id" {
  description = "ID of the network interface"
  value       = azurerm_network_interface.main.id
}

# Connection Information
output "ssh_connection" {
  description = "SSH connection string"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.main.ip_address}"
}

output "http_url" {
  description = "HTTP URL to access the VM"
  value       = "http://${azurerm_public_ip.main.ip_address}"
}

output "https_url" {
  description = "HTTPS URL to access the VM"
  value       = "https://${azurerm_public_ip.main.ip_address}"
}

# Boot Diagnostics Storage Account
output "diagnostics_storage_account" {
  description = "Name of the boot diagnostics storage account"
  value       = var.enable_boot_diagnostics ? azurerm_storage_account.diagnostics[0].name : null
}

output "diagnostics_storage_uri" {
  description = "URI of the boot diagnostics storage account"
  value       = var.enable_boot_diagnostics ? azurerm_storage_account.diagnostics[0].primary_blob_endpoint : null
}
