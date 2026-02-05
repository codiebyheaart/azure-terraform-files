# Azure Location Configuration
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

# Resource Group Configuration
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "terraform-rg"
}

# Virtual Network Configuration
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "terraform-vnet"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "terraform-subnet"
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# Virtual Machine Configuration
variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "terraform-vm"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

# SSH Configuration
variable "ssh_public_key_path" {
  description = "Path to SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "allowed_ssh_sources" {
  description = "List of CIDR blocks allowed to SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# OS Disk Configuration
variable "os_disk_caching" {
  description = "Caching type for OS disk"
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_type" {
  description = "Storage account type for OS disk"
  type        = string
  default     = "Standard_LRS"
}

variable "os_disk_size_gb" {
  description = "Size of OS disk in GB"
  type        = number
  default     = 30
}

# Image Configuration
variable "image_publisher" {
  description = "Publisher of the VM image"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "Offer of the VM image"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "SKU of the VM image"
  type        = string
  default     = "22_04-lts-gen2"
}

variable "image_version" {
  description = "Version of the VM image"
  type        = string
  default     = "latest"
}

# Boot Diagnostics
variable "enable_boot_diagnostics" {
  description = "Enable boot diagnostics for the VM"
  type        = bool
  default     = true
}

# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

# Custom Data (Cloud-Init)
variable "custom_data" {
  description = "Custom data script to run on VM creation"
  type        = string
  default     = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Azure VM deployed with Terraform</h1>" > /var/www/html/index.html
  EOF
}
