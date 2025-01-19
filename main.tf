# Configure the Azure provider
terraform {
  
  backend "azurerm" {
    resource_group_name  = "azure-terraform-demo"          
    storage_account_name = "labmanagementstorage01"
    container_name       = "azure-terraform-demo"                               
    key                  = "terraform.tfstate"                
    use_oidc             = true                                    
    client_id            = "cb96e845-aa06-4954-b93c-ccf03f6353b5"  
    subscription_id      = "357a5cd3-a5ef-489c-b770-7bbae655337c"  
    tenant_id            = "1b4c23c2-2d33-4a53-ad59-3190309565e2"  
    use_azuread_auth     = true                                    
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.112.0"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
      client_id = var.azure_client_id
      client_secret = var.azure_client_secret
      tenant_id = var.azure_tenant_id
      subscription_id = var.azure_subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}


resource "azurerm_virtual_network" "network" {
  name                = "${var.sea-terraform}-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "linux-nic" {
  for_each = var.linux_vm_configurations

  name                = "${each.key}-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "windows-nic" {
  for_each = var.windows_vm_configurations

  name                = "${each.key}-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create Gateway Subnet for the VPN Gateway
resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.0.255.0/27"]  # Reserved for Gateway
}

# Create Public IP for VPN Gateway
resource "azurerm_public_ip" "vpn-public-ip" {
  name                = "sealab-vpn-gateway-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  lifecycle {
      create_before_destroy = true
  }
}

# Create Virtual Network Gateway for the P2S VPN
resource "azurerm_virtual_network_gateway" "vpn-gateway" {
  name                = "sealab-vpn-gateway"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = false
  enable_bgp          = false
  sku                 = "VpnGw2"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn-public-ip.id
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }

  vpn_client_configuration {
    address_space = ["172.16.201.0/24"]  # VPN Client address pool

    root_certificate {
      name             = "RootCert"
      public_cert_data = var.root_certificate_data
    }

    vpn_client_protocols = ["SSTP"]  # Define VPN protocols
  }
}

# Create virtual machines for both Linux 
resource "azurerm_virtual_machine" "linux_vm" {
  for_each = var.linux_vm_configurations

  name                  = each.value.name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  network_interface_ids = [azurerm_network_interface.linux-nic[each.key].id]
  vm_size               = each.value.vm_size
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  os_profile {
    computer_name  = each.value.name
    admin_username = "azureuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = var.ssh_public_key
    }
  }

  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8-lvm-gen2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${each.key}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    
  }
}

resource "azurerm_virtual_machine" "windows_vm" {
  for_each = var.windows_vm_configurations

  name                  = each.value.name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  network_interface_ids = [azurerm_network_interface.windows-nic[each.key].id]
  vm_size               = each.value.vm_size
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  os_profile {
    computer_name  = each.value.name
    admin_username = var.local_windows_user
    admin_password = var.local_windows_password
  }

  os_profile_windows_config {}

  storage_image_reference {
    publisher = each.value.image_publisher
    offer     = each.value.image_offer
    sku       = each.value.image_sku
    version   = "latest"
  }

  storage_os_disk {
    name              = "${each.key}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    
  }
  
  storage_data_disk {
    name              = "${each.key}-data-disk"
    lun               = 0
    caching           = "ReadOnly"
    create_option     = "Empty"
    disk_size_gb      = 50
    managed_disk_type = "Standard_LRS"
    
  }
}

resource "azurerm_virtual_machine_extension" "windows_base_script" {
  for_each             = azurerm_virtual_machine.windows_vm
  name                 = "custom-script-extension-${each.key}"
  virtual_machine_id   = each.value
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScriptExtension"
  type_handler_version = "2.0"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
{
  "fileUris": ["https://labmanagementstorage01.blob.core.windows.net/azure-terraform-demo/base.ps1"],
  "commandToExecute": "powershell.exe base.ps1",
  "managedIdentity" : {"objectID": "16a77fc9-b28c-474f-8210-63a41f9c6e02"}
}
SETTINGS
}

output "windows_vm_names" {
  value = [for vm in azurerm_windows_virtual_machine.windows_vm : vm.name]
}

output "linux_vm_names" {
  value = [for vm in azurerm_linux_virtual_machine.linux_vm : vm.name]
}

