functionn Get-VM-Size {
    # Specifies a path to one or more locations. Wildcards are permitted.
    [Parameter(Mandatory=$true,
               Position=Position,
               ParameterSetName="ParameterSetName",
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true,
               HelpMessage="Path to one or more locations.")]
    [ValidateNotNullOrEmpty()]
    [SupportsWildcards()]
    [string[]]
    $ParameterName


}
$Location = "Southeast Asia"
$Publisher = "ProComputers"
$Offer = "redhat-9-gen2"
$Sku = "redhat-9-gen2"

$Location = "Southeast Asia"
$Publisher = "RedHat"
$Offer = "RHEL"
$Sku = "95_gen2"

Get-AzVMImagePublisher -Location $Location
Get-AzVMImageOffer -Location $Location -PublisherName $Publisher 
Get-AzVMImageSku -Location $Location -PublisherName $Publisher -Offer $Offer
Get-AzMarketplaceterms -Publisher $Publisher -Product $Offer -Name $Sku



$linuxPublishers = @()

# Get all publishers in the location
$publishers = Get-AzVMImagePublisher -Location $Location

foreach ($publisher in $publishers.PublisherName) {
    # Get offers for each publisher
    $offers = Get-AzVMImageOffer -Location $Location -PublisherName $publisher
    
    # Filter for common Linux keywords
    $linuxOffers = $offers | Where-Object { $_.Offer -match "RHEL" }
    # Ubuntu|Debian|CentOS|SUSE|CoreOS|AlmaLinux|Rocky|Oracle|Linux
    if ($linuxOffers) {
        $linuxPublishers += [PSCustomObject]@{
            Publisher = $publisher
            Offers    = ($linuxOffers.Offer -join ", ")
        }
    }
}

$linuxPublishers | Format-Table -AutoSize


function FunctionName {
    param (
        OptionalParameters
    )
    
}


$vmSizes = Get-AzComputeResourceSku -Location $Location | Where-Object {
    $_.ResourceType -eq "virtualMachines" -and
    $_.Name -match "Standard" # Only include VM size names
}

$vmSizes | Select-Object Name, Locations | Format-Table -AutoSize

Find-Module Az.MarketplaceOrdering | install-Module

Get-AzMarketplaceterms -Publisher "RedHat" -Product "RHEL" -Name "95_gen2" | Set-AzMarketplaceterms -Accept



# Use Cloud Shell Azure Cli in Windows Terminal
az vm image list-offers --location "Southeast Asia" --publisher "RedHat"
az vm image list-sku --location "Southeast Asia" --publisher "RedHat" --offer "rh-rhel"
az vm image terms accept --publisher "RedHat" --offer "rh-rhel" --plan "rh-rhel9"