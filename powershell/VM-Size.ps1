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


Get-AzVMImagePublisher -Location $Location
Get-AzVMImageOffer -Location $Location -PublisherName "RedHat"
Get-AzVMImageSku -Location $Location -PublisherName "ProComputers" -Offer "redhat-9-gen2"

$Location = "Southeast Asia"
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