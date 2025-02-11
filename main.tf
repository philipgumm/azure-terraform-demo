# Configure the Azure provider
terraform {
  
  backend "azurerm" {
    resource_group_name  = "azure-terraform-demo"          
    storage_account_name = "labmanagementstorage01"
    container_name       = "azure-terraform-demo"                               
    key                  = "terraform.tfstate"                
                                       
    client_id            = "cb96e845-aa06-4954-b93c-ccf03f6353b5"  
    subscription_id      = "357a5cd3-a5ef-489c-b770-7bbae655337c"  
    tenant_id            = "1b4c23c2-2d33-4a53-ad59-3190309565e2"  
    use_azuread_auth     = true 
    use_oidc             = true                                    
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.16.0"
    }
  }
}

provider "azurerm" {
  features {
    
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
     
     virtual_machine {
      delete_os_disk_on_deletion            = true
    }

  }
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
  resource_group_name = var.resource_group
  depends_on          = [azurerm_resource_group.rg]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "example" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "linux-nic" {
  for_each = var.linux_vm_configurations

  name                = "${each.key}-nic"
  resource_group_name = var.resource_group
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
  resource_group_name = var.resource_group
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.0.255.0/27"]  
}

resource "azurerm_public_ip" "vpn-public-ip" {
  name                = "sealab-vpn-gateway-pip"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  lifecycle {
      create_before_destroy = true
  }

  depends_on = [azurerm_resource_group.rg]
}

data "azurerm_key_vault" "azure-terraform-demo-kv" {
  name                = "azure-terraform-demo-kv"
  resource_group_name = var.LabManagement-rg
}

data "azurerm_key_vault_certificate" "vpn_root_cert" {
  name         = "P2SRootCertv3"
  key_vault_id = data.azurerm_key_vault.azure-terraform-demo-kv.id
}

resource "azurerm_virtual_network_gateway" "vpn-gateway" {
  name                = "azure-lab-vpn-gateway"
  location            = var.location
  resource_group_name = var.resource_group
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
    address_space = ["172.16.201.0/24"]  

    root_certificate {
      name             = "MyRootCert"
      public_cert_data = data.azurerm_key_vault_certificate.vpn_root_cert.certificate_data_base64

    }

    vpn_client_protocols = ["SSTP"]  
  }
}

resource "azurerm_managed_disk" "linux_data_disk" {
  for_each = var.linux_vm_configurations
  
  name                 = "${each.value.name}-data-disk"
  location             = var.location
  resource_group_name  = var.resource_group
  storage_account_type = "Standard_LRS"
  disk_size_gb         = 50
  create_option        = "Empty"

  depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  for_each = var.linux_vm_configurations

  name                  = each.value.name
  resource_group_name   = var.resource_group
  location              = var.location
  network_interface_ids = [azurerm_network_interface.linux-nic[each.key].id]
  size                  = each.value.size
  admin_username        = "adminuser"
  computer_name         = each.value.name
  disable_password_authentication = true

  os_disk {
    name                  = "${each.value.name}-osdisk"
    caching               = "ReadWrite"
    storage_account_type  = "Standard_LRS"
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.ssh_public_key
  }
  
  source_image_reference {
    publisher = each.value.image_publisher
    offer     = each.value.image_offer
    sku       = each.value.image_sku
    version   = "latest"
  }

  plan {
    name      = each.value.image_sku
    publisher = each.value.image_publisher
    product   = each.value.image_offer
  }
}

resource "azurerm_managed_disk" "windows_data_disks" {
  for_each = var.windows_vm_configurations

  name                 = "${each.value.name}-data-disk"
  location             = var.location
  resource_group_name  = var.resource_group
  storage_account_type = "Standard_LRS"
  disk_size_gb         = 50
  create_option        = "Empty"

  depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_virtual_machine_data_disk_attachment" "windows-attach-disk" {
  for_each = azurerm_managed_disk.windows_data_disks
  
  managed_disk_id    = azurerm_managed_disk.windows_data_disks[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.windows_vm[each.key].id
  lun                = 0
  caching            = "ReadWrite"

}

resource "azurerm_windows_virtual_machine" "windows_vm" {
  for_each = var.windows_vm_configurations

  name                  = each.value.name
  resource_group_name   = var.resource_group
  location              = var.location
  network_interface_ids = [azurerm_network_interface.windows-nic[each.key].id]
  size                  = each.value.size
  admin_username        = "adminuser"
  admin_password        = var.local_windows_password  
  computer_name         = each.value.name 

  os_disk {
    name                  = "${each.value.name}-osdisk"
    caching               = "ReadWrite"
    storage_account_type  = "Standard_LRS"
  }
  
  source_image_reference {
    publisher = each.value.image_publisher
    offer     = each.value.image_offer
    sku       = each.value.image_sku
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "windows_base_script" {
  for_each             = azurerm_windows_virtual_machine.windows_vm
  name                 = "custom-script-extension-${each.key}"
  virtual_machine_id   = each.value.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
{
  "fileUris": ["https://labmanagementstorage01.blob.core.windows.net/public-azure-terraform-demo/windows_base.ps1"],
  "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -NoProfile -NonInteractive -File windows_base.ps1",
  "managedIdentity" : {}
}
SETTINGS
}

resource "azurerm_virtual_machine_extension" "linux_base_script" {
  for_each             = azurerm_linux_virtual_machine.linux_vm
  name                 = "custom-script-extension-${each.key}"
  virtual_machine_id   = each.value.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
  {
    "fileUris": ["https://labmanagementstorage01.blob.core.windows.net/public-azure-terraform-demo/linux_base.sh"],
    "commandToExecute": "bash linux_base.sh"
  }
  SETTINGS
}

output "inventory_json" {
  value = jsonencode({
    all = {
      children = {
        linux = {
          hosts = {
            for vm in azurerm_linux_virtual_machine.linux_vm :
            vm.name => {
              ansible_host = vm.public_ip_address
              ansible_user = "azureuser"
              ansible_ssh_private_key_file = "~/.ssh/id_rsa"
            }
          }
        },
        windows = {
          hosts = {
            for vm in azurerm_windows_virtual_machine.windows_vm :
            vm.name => {
              ansible_host = vm.public_ip_address
              ansible_user = "Administrator"
              ansible_connection = "winrm"
              ansible_winrm_transport = "ntlm"
              ansible_winrm_server_cert_validation = "ignore"
            }
          }
        }
      }
    }
  })
}


