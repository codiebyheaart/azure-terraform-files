# Azure Terraform Configuration

Terraform configuration for deploying a Linux Virtual Machine on Microsoft Azure with virtual network, subnet, and network security group.

## 📋 Resources Created

- **Resource Group**: Container for all resources
- **Virtual Network**: VNet with custom address space
- **Subnet**: Subnet within the VNet
- **Network Security Group**: Firewall rules for SSH, HTTP, HTTPS
- **Public IP**: Static public IP address
- **Network Interface**: NIC for the VM
- **Linux Virtual Machine**: VM with customizable specifications
- **Storage Account**: For boot diagnostics (optional)

## 🔧 Prerequisites

### 1. Install Required Tools

```bash
# Install Terraform
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### 2. Azure Account Setup

1. Create an Azure account at https://azure.microsoft.com/
2. Get a subscription (free tier available)
3. Note your Subscription ID

### 3. Login to Azure

```bash
# Interactive login
az login

# Verify login
az account show

# List subscriptions
az account list --output table

# Set active subscription
az account set --subscription "<SUBSCRIPTION_ID>"
```

### 4. Create Service Principal (Recommended for CI/CD)

```bash
# Create service principal
az ad sp create-for-rbac --name "terraform-sp" --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"

# Output will show:
# {
#   "appId": "<CLIENT_ID>",
#   "displayName": "terraform-sp",
#   "password": "<CLIENT_SECRET>",
#   "tenant": "<TENANT_ID>"
# }

# Save these values securely!
```

## 🚀 Quick Start

### 1. Configure Variables

```bash
# Copy example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
vim terraform.tfvars
```

### 2. Generate SSH Key (if needed)

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
```

### 3. Set Authentication (Choose One)

**Option A: Using Azure CLI (Recommended for local development)**
```bash
az login
```

**Option B: Using Service Principal**
```bash
export ARM_CLIENT_ID="<CLIENT_ID>"
export ARM_CLIENT_SECRET="<CLIENT_SECRET>"
export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
export ARM_TENANT_ID="<TENANT_ID>"
```

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Review Plan

```bash
terraform plan
```

### 6. Deploy Infrastructure

```bash
terraform apply
```

### 7. Get Outputs

```bash
terraform output

# Get SSH connection string
terraform output ssh_connection
```

## 📝 Configuration Variables

### Required Variables

All variables have defaults, but you should customize:

| Variable | Description | Default |
|----------|-------------|----------|
| `location` | Azure region | `East US` |
| `resource_group_name` | Resource group name | `terraform-rg` |
| `vm_name` | Virtual machine name | `terraform-vm` |

### Optional Variables

| Variable | Description | Default |
|----------|-------------|----------|
| `vm_size` | VM size | `Standard_B2s` |
| `admin_username` | Admin username | `azureuser` |
| `vnet_address_space` | VNet address space | `10.0.0.0/16` |
| `subnet_address_prefix` | Subnet prefix | `10.0.1.0/24` |
| `os_disk_size_gb` | OS disk size | `30` |

## 🔐 SSH Access

### Connect to VM

```bash
# Get connection command
terraform output ssh_connection

# Or manually
ssh azureuser@<PUBLIC_IP>
```

### Fix Key Permissions

```bash
chmod 600 ~/.ssh/id_rsa
```

## 💻 Available VM Sizes

### General Purpose (B-Series - Burstable)
- `Standard_B1s` - 1 vCPU, 1 GB RAM
- `Standard_B1ms` - 1 vCPU, 2 GB RAM
- `Standard_B2s` - 2 vCPUs, 4 GB RAM (default)
- `Standard_B2ms` - 2 vCPUs, 8 GB RAM
- `Standard_B4ms` - 4 vCPUs, 16 GB RAM

### General Purpose (D-Series)
- `Standard_D2s_v5` - 2 vCPUs, 8 GB RAM
- `Standard_D4s_v5` - 4 vCPUs, 16 GB RAM
- `Standard_D8s_v5` - 8 vCPUs, 32 GB RAM

### Compute Optimized (F-Series)
- `Standard_F2s_v2` - 2 vCPUs, 4 GB RAM
- `Standard_F4s_v2` - 4 vCPUs, 8 GB RAM
- `Standard_F8s_v2` - 8 vCPUs, 16 GB RAM

### Memory Optimized (E-Series)
- `Standard_E2s_v5` - 2 vCPUs, 16 GB RAM
- `Standard_E4s_v5` - 4 vCPUs, 32 GB RAM

## 🖼️ Available Images

```hcl
# Ubuntu 22.04 LTS (default)
image_publisher = "Canonical"
image_offer     = "0001-com-ubuntu-server-jammy"
image_sku       = "22_04-lts-gen2"
image_version   = "latest"

# Ubuntu 20.04 LTS
image_publisher = "Canonical"
image_offer     = "0001-com-ubuntu-server-focal"
image_sku       = "20_04-lts-gen2"
image_version   = "latest"

# Debian 11
image_publisher = "Debian"
image_offer     = "debian-11"
image_sku       = "11-gen2"
image_version   = "latest"

# Red Hat Enterprise Linux 9
image_publisher = "RedHat"
image_offer     = "RHEL"
image_sku       = "9-lvm-gen2"
image_version   = "latest"

# CentOS 8 Stream
image_publisher = "OpenLogic"
image_offer     = "CentOS"
image_sku       = "8_5-gen2"
image_version   = "latest"
```

## 🌎 Available Azure Regions

```bash
# List all available regions
az account list-locations --output table
```

Common regions:
- `East US`
- `East US 2`
- `West US`
- `West US 2`
- `Central US`
- `North Europe`
- `West Europe`
- `Southeast Asia`
- `Australia East`

## 🔄 Common Operations

### Update VM

```bash
# Modify variables in terraform.tfvars
terraform plan
terraform apply
```

### Resize VM

```bash
# Change vm_size in terraform.tfvars
vm_size = "Standard_B4ms"

terraform apply
# Note: This will stop and restart the VM
```

### Stop VM (to save costs)

```bash
az vm deallocate --resource-group terraform-rg --name terraform-vm
```

### Start VM

```bash
az vm start --resource-group terraform-rg --name terraform-vm
```

### Destroy Infrastructure

```bash
terraform destroy
```

### View State

```bash
terraform show
```

### Import Existing Resources

```bash
terraform import azurerm_linux_virtual_machine.main /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RG_NAME>/providers/Microsoft.Compute/virtualMachines/<VM_NAME>
```

## 🛡️ Security Best Practices

1. **Restrict SSH Access**
   ```hcl
   allowed_ssh_sources = ["YOUR_IP/32"]
   ```

2. **Use Azure Key Vault**
   - Store SSH keys and secrets
   - Reference in Terraform

3. **Enable Disk Encryption**
   - Azure disks are encrypted by default
   - Consider Azure Disk Encryption (ADE) for additional security

4. **Use Managed Identities**
   - Avoid storing credentials
   - Assign managed identity to VM

5. **Enable Azure Security Center**
   ```bash
   az security pricing create --name VirtualMachines --tier Standard
   ```

6. **Regular Updates**
   ```bash
   # SSH into VM
   sudo apt update && sudo apt upgrade -y  # Ubuntu/Debian
   sudo yum update -y  # RHEL/CentOS
   ```

7. **Use Network Security Groups**
   - Already configured
   - Review and restrict rules regularly

## 💰 Cost Estimation

### Standard_B2s VM (Default)
- **Compute**: ~$30/month (730 hours)
- **Storage**: ~$3/month (30 GB Standard SSD)
- **Public IP**: ~$3/month (Static)
- **Bandwidth**: First 100 GB free

**Total**: ~$36/month

### Cost Optimization Tips

1. **Use B-Series VMs** (Burstable)
   - Cost-effective for variable workloads
   - Already using Standard_B2s

2. **Stop VMs When Not Needed**
   ```bash
   az vm deallocate --resource-group terraform-rg --name terraform-vm
   ```
   - Deallocated VMs don't incur compute charges

3. **Use Spot VMs** (up to 90% discount)
   - For non-critical workloads
   - Can be evicted with 30-second notice

4. **Reserved Instances** (up to 72% discount)
   - 1-year or 3-year commitment

5. **Right-size VMs**
   - Use Azure Advisor recommendations
   ```bash
   az advisor recommendation list --output table
   ```

6. **Use Standard HDD** (instead of SSD)
   ```hcl
   os_disk_storage_type = "Standard_LRS"
   ```

## 🔍 Troubleshooting

### Authentication Errors

```bash
# Verify login
az account show

# Re-login
az login

# Clear cache
az account clear
az login
```

### SSH Connection Issues

```bash
# Check VM status
az vm get-instance-view --resource-group terraform-rg --name terraform-vm --query instanceView.statuses

# Check NSG rules
az network nsg rule list --resource-group terraform-rg --nsg-name terraform-vm-nsg --output table

# Reset SSH
az vm user update --resource-group terraform-rg --name terraform-vm --username azureuser --ssh-key-value "$(cat ~/.ssh/id_rsa.pub)"
```

### Quota Exceeded

```bash
# Check quotas
az vm list-usage --location "East US" --output table

# Request quota increase via Azure Portal
```

### Resource Provider Not Registered

```bash
# Register required providers
az provider register --namespace Microsoft.Compute
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.Storage

# Check registration status
az provider show --namespace Microsoft.Compute --query "registrationState"
```

### VM Creation Failed

```bash
# Check activity log
az monitor activity-log list --resource-group terraform-rg --output table

# Get detailed error
az monitor activity-log list --resource-group terraform-rg --max-events 1 --query "[0].properties.statusMessage"
```

## 🔒 Remote State Storage (Recommended)

For team collaboration, use Azure Storage backend:

### 1. Create Storage Account and Container

```bash
# Create resource group for state
az group create --name terraform-state-rg --location "East US"

# Create storage account
az storage account create \
  --name tfstatestorage$RANDOM \
  --resource-group terraform-state-rg \
  --location "East US" \
  --sku Standard_LRS \
  --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group terraform-state-rg --account-name tfstatestorage --query '[0].value' -o tsv)

# Create blob container
az storage container create \
  --name tfstate \
  --account-name tfstatestorage \
  --account-key $ACCOUNT_KEY
```

### 2. Update provider.tf

Uncomment the backend configuration in `provider.tf`

### 3. Initialize Backend

```bash
terraform init -migrate-state
```

## 📚 Additional Resources

- [Azure Virtual Machines Documentation](https://docs.microsoft.com/en-us/azure/virtual-machines/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/)
- [Azure Free Tier](https://azure.microsoft.com/en-us/free/)
- [Azure Well-Architected Framework](https://docs.microsoft.com/en-us/azure/architecture/framework/)

## 🤝 Support

For issues or questions:
1. Check Azure Portal for resource status
2. Review Terraform state: `terraform show`
3. Enable debug logging: `export TF_LOG=DEBUG`
4. Check Azure Activity Log
5. Use Azure CLI for diagnostics: `az vm show --resource-group terraform-rg --name terraform-vm`

---

**Note**: Always review the Terraform plan before applying changes to production environments.
