variable "resource_group" {
  description = "The name of the resource group in which the resources will be created"
}

variable "azure_tenant_id" {
  description = "The tenant ID of the Service Principal used to authenticate to Azure."
}

variable "azure_client_id" {
  description = "The client ID of the Service Principal used to authenticate to Azure."
}

variable "azure_client_secret" {
  description = "The client secret of the Service Principal used to authenticate to Azure."
}

variable "azure_subscription_id" {
  description = "The subscription ID in which the resources will be created."
}

variable "root_certificate" {
  description = "The root certificate for the VPN gateway"
}

variable "sea-terraform" {
  description = "The Azure Region in which all resources in this example should be created."
}

variable "keyvault_name" {
  description = "root certificate key vault"
}

variable "LabManagement-rg" {
  description = "resource group name for external management resources"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
}

variable storage_account_name {
  description = "The name of the storage account to store Terraform state file"
}

variable ssh_public_key {
    description = "this is the public key held in terraform.tfvars"
}
variable local_windows_user{
    description = "this is the public key held in terraform.tfvars"
}
variable local_windows_password{
    description = "this is the public key held in terraform.tfvars"
}

variable "root_certificate_data" {
  type        = string
  description = "Base64-encoded root certificate data"
}

variable "rg-hon" {
  type        = string
  description = "Creating two resource groups"
}

variable "rg-sin" {
  type        = string
  description = "Creating two resource groups"
}

# Define a list of allowed keywords
variable "allowed_tiers" {
  default = ["admin", "web", "database", "application"]
}

variable "linux_vm_configurations" {
  type = map(object({
    name            = string
    size         = string
    image_publisher = string
    image_offer     = string
    image_sku       = string
    os              = string
    version         = string
  }))
  description = "Map of VM configurations with different OS types"
}

variable "windows_vm_configurations" {
  type = map(object({
    name            = string
    size            = string
    image_publisher = string
    image_offer     = string
    image_sku       = string
    os              = string
  }))
  description = "Map of VM configurations with different OS types"
}

