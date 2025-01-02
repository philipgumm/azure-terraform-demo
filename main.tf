# Configure the Azure provider
terraform {
  
  backend "azurerm" {
    resource_group_name  = "azure-terraform-demo"          # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "labmanagementstorage01"                              # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "azure-terraform-demo"                               # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "terraform.tfstate"                # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
    use_oidc             = true                                    # Can also be set via `ARM_USE_OIDC` environment variable.
    client_id            = "cd8d14eb-2c69-4a39-9f08-64a22f4dde1f"  # Can also be set via `ARM_CLIENT_ID` environment variable.
    subscription_id      = "357a5cd3-a5ef-489c-b770-7bbae655337c"  # Can also be set via `ARM_SUBSCRIPTION_ID` environment variable.
    tenant_id            = "1b4c23c2-2d33-4a53-ad59-3190309565e2"  # Can also be set via `ARM_TENANT_ID` environment variable.
    use_azuread_auth     = true                                    # Can also be set via `ARM_USE_AZUREAD` environment variable.
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
    admin_username = "azureuser"
    admin_password = "P@ssword1234!"
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

#    resource "azurerm_virtual_machine_extension" "dsc" {
#    name                 = "ApplyDSC"
#    virtual_machine_id   = azurerm_virtual_machine.vm.id
#    publisher            = "Microsoft.Compute"
#    type                 = "CustomScriptExtension"
#    type_handler_version = "2.0"
#
#    settings = <<SETTINGS
#    {
#        "commandToExecute": "powershell.exe -Command \"
#          Invoke-WebRequest -Uri https://<storage-url>/BaseConfiguration.ps1 -OutFile C:\\BaseConfiguration.ps1;
#          . C:\\BaseConfiguration.ps1; Start-DscConfiguration -Path C:\\BaseConfiguration -Wait -Verbose -Force;
#    }
#    SETTINGS
#}