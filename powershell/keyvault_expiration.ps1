function Get-KV_Expiration {
    param (
        [Parameter(Mandatory=$true)][String]$Name,
        
    )
    
}


function Add-KV_Permissions {

    param (}


}

$servicePrincipal = 
$tenantId
$subscriptionId

Connect-AzAccount -ServicePrincipal "$servicePrincipal" -Tenant "$tenantId" -Subscription "$subscriptionId"

Connect-AzAccount
$vault = "azure-terraform-demo-kv"
$secretName = "azure-terraform-demo-root-certificate"
Get-AzKeyVaultSecret -VaultName $vault -Name $secretName -AsPlainText

Get-AzKeyVaultCertificate -VaultName "<your-key-vault-name>" -Name "ExampleCertificate"

$Password = ConvertTo-SecureString -String "xxx" -AsPlainText -Force
Import-AzKeyVaultCertificate -VaultName $ -Name $ -FilePath $ -Password $Password