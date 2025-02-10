function Remove-TerraformState {

    # 1) Find, Install and Load Az.Storage Modules
    # 2) Write down variables for the Storage Account
    # 3) Connect to the storage 
    # 4) Delete the file
    # 5) Destroy the Resource Group

    Connect-AzAccount -credential $cred -Subscription 357a5cd3-a5ef-489c-b770-7bbae655337c

    $StorageAccountName = "labstoragemanagement01"

    $Context = New-AzStorageContext -StorageAccountName $StorageAccountName -SasToken 
    
    Remove-AzStorageBlob -Container "terraform-state" -Blob "terraform.tfstate" -Context $Context

}

function Unlock-TerraformState {

    # 1) Find, Install and Load Az.Storage Modules
    # 2) Write down variables for the Storage Account
    # 3) Connect to the storage
    # 4) Acquire or release the lock

    if (())
    $Context = 
    
    Remove-AzStorageBlob -Container "terraform-state" -Blob "terraform.tfstate" -Context $Context

}

Set-AzCurrentStorageAccount -ResourceGroupName LabManagement -StorageAccountName labmanagementstorage01
$token = New-AzStorageContainerSASToken -Name templates -Permission r -ExpiryTime (Get-Date).AddHours(2.0)
$url = (Get-AzStorageBlob -Container templates -Blob Master_Template.json).ICloudBlob.uri.AbsoluteUri
New-AzResourceGroup -Name SeaLab01 -Location "southeastasia"
New-AzResourceGroupDeployment -Name SEALab01 -ResourceGroupName SeaLab01 -TemplateUri ($url + $token) -containerSasToken $token

$storageAccount = "labstoragemanagement01"
$containerName = "azure-terraform-demo"
$blobName = "terraform.tfstate"
# $expiry = (Get-Date).AddHours(2).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

$context = New-AzStorageContext -StorageAccountName $storageAccount -UseConnectedAccount
# $sasToken = New-AzStorageBlobSASToken -Container $containerName -Blob $blobName -Permission r -ExpiryTime $expiry -Context $context

Remove-AzStorageBlob -Container $containerName -Blob $blobName -Context $context 

Write-Output "SAS Token: $sasToken"
