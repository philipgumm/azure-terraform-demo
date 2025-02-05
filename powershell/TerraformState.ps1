function Remove-TerraformState {

    # 1) Find, Install and Load Az.Storage Modules
    # 2) Write down variables for the Storage Account
    # 3) Connect to the storage 
    # 4) Delete the file
    # 5) Destroy the Resource Group

    $StorageAccountName = "labstoragemanagement01"

    $Context = New-AzStorageContext -StorageAccountName $StorageAccountName 
    
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

