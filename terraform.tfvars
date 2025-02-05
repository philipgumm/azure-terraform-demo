resource_group = "azure-terraform-demo"

location = "southeast asia"

storage_account_name = "labmanagementstorage01"

ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDVAMdnkZS//tGf9/w9QOBAniMIKLb6EavbKDpLBJcNh2/SZb/bv90OM0cA3s+RqQRF52nvDDUi1FHrnD1zH7AB6N0TCSBWfcFgSOf1NlyIrf/PjAF3yHcrXItzzzHllpUhwoDtPUzI7MN1t3UpWJRaGdPdgJPFZinC3CSHxrfhTgqwzi4vgPwFfemAmJFoe2SsLj0WVWG/zsuW4Erv2kXadcO/eCxcK99w2UVCoyyu81ehFSKuqHzdpO/ykuqR715/XF+ub1r0jg5RTYGj5hxDE5AMljxJ6LfIFNhXRLNU1EQhRIkOdzQ2zpWTY/pfzB51k4CJJ+Al86NaewrvsaFv wlb\\gummp@SYS003306222157"

root_certificate = "MIIC7TCCAdWgAwIBAgIQSjj3auVMML1MJNQT1wT/KjANBgkqhkiG9w0BAQsFADAZMRcwFQYDVQQDDA5QMlNSb290Q2VydF92MjAeFw0yNTAyMDMwNDU4MzhaFw0yNjAyMDMwNTE4MzhaMBkxFzAVBgNVBAMMDlAyU1Jvb3RDZXJ0X3YyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApmBbK4M786ev46Bogu30mzIXxjOzIZIjUIsyK5w0JQ6VdADw4UUaqqlsa5YJfBHGQI/arQf1WowXgdPfRdph3E/XxztqPLf+n6lYnfySdK/Rcnb1dNY/KB489Ax7uP8/gFHLJauVoAPnffSTkFozkNY+H7SMu84TOt1GGQ7Zo0X1cBfXy3grzSYRqW+G72sxe9jWf1N2vtHB7yeK06sT+XJjUeG64NtVguv6b1dymPU7okW5DjXmaDA0w+aMgY4JpA3IseMtxUeLQywV7a2YN4mGNj9irtLH0qfFSn1LXtWzsgQ3s8w1xt/UJzmLPjhye0cHZyLm8/E6CAFlY41q0QIDAQABozEwLzAOBgNVHQ8BAf8EBAMCAgQwHQYDVR0OBBYEFLydFXOtOmHoJzNpOtuZIpbTcscjMA0GCSqGSIb3DQEBCwUAA4IBAQA/8hOwAi7BtFfoYfSHFl8ZZTNfnexwcm51UzTtk4cocYt/2oyBSMpVfXOqysSBCeH9Ta4SOT4TtFblreGXgK+ZS5r1cNpaZq7vdHwDGtqhPnwquENUocWsD32Vyy28EPoKJ1KxJiZF148POMwCJty8AMEajeXKMlTtOK7Qz27g5x6yfjuuD0m2gCizaIWZ4HmPEqUaMpAi9iCLPPBCseNwAmQAhLrwibx4zoPacFy3pAsJVOnJxag+hWt+lDc6ElM6Agxe0beNgrSk15E1RxvJKTblJYzZKVkeoK0swg0b3I2BVLAE81vJj27GaW8+3U5r+UT00zq1VrX6uxmBRnlh)"

sea-terraform = "sea-terraform"

rg-hon = "dev-hon-rg"

rg-sin = "dev-sin-rg"

keyvault_name = "azure-terraform-demo-kv"

LabManagement-rg = "LabManagement"

linux_vm_configurations = {
  linux_vm = {
    name            = "app-lin-srv"
    size            = "Standard_B2s"
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
    size            = "Standard_B2ms"
    os              = "Windows"
    image_publisher = "MicrosoftWindowsServer"
    image_offer     = "WindowsServer"
    image_sku       = "2019-Datacenter"
  }
    windows_vm2 = {
    name            = "dbs-win-srv"
    size            = "Standard_B2ms"
    os              = "Windows"
    image_publisher = "MicrosoftWindowsServer"
    image_offer     = "WindowsServer"
    image_sku       = "2019-Datacenter"
  }
}


