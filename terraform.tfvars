resource_group = "azure-terraform-demo"

location = "southeast asia"

storage_account_name = "labmanagementstorage01"

ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDVAMdnkZS//tGf9/w9QOBAniMIKLb6EavbKDpLBJcNh2/SZb/bv90OM0cA3s+RqQRF52nvDDUi1FHrnD1zH7AB6N0TCSBWfcFgSOf1NlyIrf/PjAF3yHcrXItzzzHllpUhwoDtPUzI7MN1t3UpWJRaGdPdgJPFZinC3CSHxrfhTgqwzi4vgPwFfemAmJFoe2SsLj0WVWG/zsuW4Erv2kXadcO/eCxcK99w2UVCoyyu81ehFSKuqHzdpO/ykuqR715/XF+ub1r0jg5RTYGj5hxDE5AMljxJ6LfIFNhXRLNU1EQhRIkOdzQ2zpWTY/pfzB51k4CJJ+Al86NaewrvsaFv wlb\\gummp@SYS003306222157"

admin_password = "Nights2k!!"

sea-terraform = "sea-terraform"

rg-hon = "dev-hon-rg"

rg-sin = "dev-sin-rg"

linux_vm_configurations = {
  linux_vm = {
    name            = "app-lin-srv"
    vm_size         = "Standard_B2s"
    os              = "Linux"
    version         = "latest"
    image_publisher = "ntegralinc1586961136942"
    image_offer     = "ntg_fedora_40"
    image_sku       = "ntg_fedora_40"
  }
}
 
windows_vm_configurations = {
  windows_vm = {
    name            = "web-win-srv"
    vm_size         = "Standard_B2ms"
    os              = "Windows"
    image_publisher = "MicrosoftWindowsServer"
    image_offer     = "WindowsServer"
    image_sku       = "2019-Datacenter"
  }
    windows_vm2 = {
    name            = "dbs-win-srv"
    vm_size         = "Standard_B2ms"
    os              = "Windows"
    image_publisher = "MicrosoftWindowsServer"
    image_offer     = "WindowsServer"
    image_sku       = "2019-Datacenter"
  }
}


