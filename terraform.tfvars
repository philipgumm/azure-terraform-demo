resource_group = "azure-terraform-demo"

location = "southeast asia"

storage_account_name = "labmanagementstorage01"

ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCaoIEop7ziz8C89DSoKZMwNCTJwDIAZOgrAttit7ZfAf4mFB87ApYI5HijzIdpWEowIjo7LFb9frdHP39KgVGD3bwnk41YEzIDfdCpZRlk+mn0Aty49fXBebeK0McVgzn2lbKQ8ekAUKKVSeqzRRjFGUfrkHY27QEx/9BQNxC1WzmqYrkGDObG8kUPatWDFvx8CSKNTmDbLicRMHTgOjxafP5+Qf7QT1ILM041IscQaN/5MjvhG5IrjZdAVbHEOViYnb1e9y0OMpvDh3Id9A5O01oSX3jwXiYY1JVxklgkPhcJrrKl20zJzmdGrIUAKXWGfyn+/u/ivns615nHb3JrxDDw+BtEzvsHpRiWhfi3nolABn21JqiBsLrKkJEon8wv+064/LjAL7dZN9hy2YOepdO0/AKQqf1JOD8C3BLjlVCI2gJNvRYivtMnyv9s3gYTjLG0VvJJ5JKMd/VuVywhLeNICeVpNjbThXDYWo2zw+CPO9bMWMYcmELa5oxH/45aL+gqJwkotEmqHdiv+NnvgWa3IzTpIMjDLi+hgywZ9MYThJ+JsnpcQkrZQ4n9ak96egUclgI9SDmvdfMp4woOHTErqCss4yQzFNPy77xloA+1WqN5SONbfno4SF9odhFzhIoXbtt8m+lbr9HedF5dQpAzfeXuzhApNiK0PGOhrQ== azure-terraform-demo_ssh-key"

root_certificate = "MIIC7TCCAdWgAwIBAgIQSjj3auVMML1MJNQT1wT/KjANBgkqhkiG9w0BAQsFADAZMRcwFQYDVQQDDA5QMlNSb290Q2VydF92MjAeFw0yNTAyMDMwNDU4MzhaFw0yNjAyMDMwNTE4MzhaMBkxFzAVBgNVBAMMDlAyU1Jvb3RDZXJ0X3YyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApmBbK4M786ev46Bogu30mzIXxjOzIZIjUIsyK5w0JQ6VdADw4UUaqqlsa5YJfBHGQI/arQf1WowXgdPfRdph3E/XxztqPLf+n6lYnfySdK/Rcnb1dNY/KB489Ax7uP8/gFHLJauVoAPnffSTkFozkNY+H7SMu84TOt1GGQ7Zo0X1cBfXy3grzSYRqW+G72sxe9jWf1N2vtHB7yeK06sT+XJjUeG64NtVguv6b1dymPU7okW5DjXmaDA0w+aMgY4JpA3IseMtxUeLQywV7a2YN4mGNj9irtLH0qfFSn1LXtWzsgQ3s8w1xt/UJzmLPjhye0cHZyLm8/E6CAFlY41q0QIDAQABozEwLzAOBgNVHQ8BAf8EBAMCAgQwHQYDVR0OBBYEFLydFXOtOmHoJzNpOtuZIpbTcscjMA0GCSqGSIb3DQEBCwUAA4IBAQA/8hOwAi7BtFfoYfSHFl8ZZTNfnexwcm51UzTtk4cocYt/2oyBSMpVfXOqysSBCeH9Ta4SOT4TtFblreGXgK+ZS5r1cNpaZq7vdHwDGtqhPnwquENUocWsD32Vyy28EPoKJ1KxJiZF148POMwCJty8AMEajeXKMlTtOK7Qz27g5x6yfjuuD0m2gCizaIWZ4HmPEqUaMpAi9iCLPPBCseNwAmQAhLrwibx4zoPacFy3pAsJVOnJxag+hWt+lDc6ElM6Agxe0beNgrSk15E1RxvJKTblJYzZKVkeoK0swg0b3I2BVLAE81vJj27GaW8+3U5r+UT00zq1VrX6uxmBRnlh)"

sea-terraform = "sea-terraform"

rg-hon = "dev-hon-rg"

rg-sin = "dev-sin-rg"

subnet_map = {
  "web"      = "web-tier"
  "app"      = "application-tier"
  "dbs"      = "database-tier"
  "adm"      = "admin-tier"
}

keyvault_name = "azure-terraform-demo-kv"

LabManagement-rg = "LabManagement"

linux_vm_configurations = {
  linux_vm = {
    name            = "app-lin-srv"
    size            = "Standard_B2ms"
    os              = "Linux"
    version         = "latest"
    image_publisher = "RedHat"
    image_offer     = "rh-rhel"
    image_sku       = "rh-rhel9"
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


