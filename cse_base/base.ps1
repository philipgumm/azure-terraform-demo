# init.ps1 - Windows Server Initialization Script

# Enable WinRM for remote management
Write-Host "Enabling WinRM for remote management..."
Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $true
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
Enable-PSRemoting -Force
Restart-Service -Name WinRM

# Install Windows Updates
Write-Host "Installing Windows Updates..."
Install-PackageProvider -Name NuGet -Force
Install-Module -Name PSWindowsUpdate -Force
Import-Module PSWindowsUpdate
Get-WindowsUpdate -Install -AcceptAll -AutoReboot

# Configure Time Zone
Write-Host "Configuring time zone..."
Set-TimeZone -Id "Singapore Standard Time"

# Enable basic firewall rules
Write-Host "Configuring Windows Firewall rules..."
New-NetFirewallRule -DisplayName "Allow WinRM" -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow

# Create logging test between two different requests
# Use variable to replace the URL, Repo, Branch and Script name. 
  
New-Item -Path C:\ -ItemType Directory -Name CheckDir
New-Item -Path C:\CheckDir -Name Check.txt
Add-Content -Path C:\CheckDir\Check.txt -Value "$env:computername"

# Setup complete
Write-Host "Initialization complete!"