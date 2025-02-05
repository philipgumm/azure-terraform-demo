# Generate a root certificate and a client certificate

# initial root certificate - to be exported to Azure 
$cert = New-SelfSignedCertificate -Type Custom -KeySpec Signature `
-Subject "CN=P2SRootCert_v2" `
-KeyExportPolicy Exportable `
-HashAlgorithm sha256 `
-KeyLength 2048 `
-CertStoreLocation "Cert:\CurrentUser\My" `
-NotAfter = (Get-Date).AddMonths(24) `
-KeyUsageProperty Sign `
-KeyUsage CertSign 

# Create client certificate - stored in certificate store
New-SelfSignedCertificate -Type Custom -DnsName P2SChildCert -KeySpec Signature `
-Subject "CN=P2SChildCert_v2" -KeyExportPolicy Exportable `
-HashAlgorithm sha256 -KeyLength 2048 ` -CertStoreLocation "Cert:\CurrentUser\My" `
-Signer $cert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")

# List your locally created personal certificates
Get-ChildItem -Path Cert:\CurrentUser\Root\ | Format-Table -AutoSize
Get-ChildItem -Path Cert:\CurrentUser\My\ | Format-Table -AutoSize

# Export root certificate as a precautionary backup
$cert = Get-ChildItem -Path Cert:\CurrentUser\Root\B73031049AD98B300C8AAF50258BE26F5B7B42ED
Export-Certificate -Cert $cert -FilePath C:\Certs\P2SRootCert_PFX_v2.cer -Type CERT

# Export client certificate to be imported into any OS 
$cert = Get-ChildItem -Path Cert:\CurrentUser\My\31DEA872891279EA05E1FB8301BF74D3A16C80D8
Export-Certificate -Cert $cert -FilePath C:\Certs\P2SClientCert_v2.cer

# Remember that PowerShell's Export-Certificate cmdlet does not offer the “Base-64 encoded X.509 (.CER) natively

# Found this on StackOverflow: https://stackoverflow.com/questions/19704156/powershell-how-to-export-a-certificate-to-base64-string
# To be used to copy the contents of the Root certificate into the Terraform deployment, via the Azure Key Vault if possible. 
$certificate = Get-ChildItem -path Cert:\CurrentUser\Root\B73031049AD98B300C8AAF50258BE26F5B7B42ED
$base64certificate = @"
-----BEGIN CERTIFICATE-----
$([Convert]::ToBase64String($certificate.Export('Cert'), [System.Base64FormattingOptions]::InsertLineBreaks)))
-----END CERTIFICATE-----
"@
Set-Content -Path "C:\Certs\P2SRootCert_PFX_v2.cer" -Value $base64certificate

# As a reminder: Create Root Certification with private key > Create Client Certificate with private key 
# Export the Root Certificate as CER without the private key and convert it to text. Upload into Terraform of Key Vault
# Install the Client Certificate or Export it with private key if you want to run it on another machine. 

# https://docs.azure.cn/en-us/vpn-gateway/point-to-site-certificates-linux-openssl
# https://docs.azure.cn/en-us/vpn-gateway/vpn-gateway-certificates-point-to-site

