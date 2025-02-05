# init.ps1 - Windows Server Initialization Script

# Enable WinRM for remote management
Write-Host "Enabling WinRM for remote management..."
Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $true
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
Enable-PSRemoting -Force

Write-Host "Configuring Windows Firewall rules..."
New-NetFirewallRule -DisplayName "Allow WinRM" -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow
Restart-Service -Name WinRM

# Checking to ensure that Base script is running
New-Item -Path C:\ -ItemType Directory -Name CheckDir
New-Item -Path C:\CheckDir -Name Check.txt
Add-Content -Path C:\CheckDir\Check.txt -Value "$env:computername"

# Install Windows Updates
Write-Host "Installing Windows Updates..."
Install-PackageProvider -Name NuGet -Force
Install-Module -Name PSWindowsUpdate -Force
Import-Module PSWindowsUpdate
Get-WindowsUpdate -Install -AcceptAll 

# Configure Time Zone
Write-Host "Configuring time zone..."
Set-TimeZone -Id "Singapore Standard Time"
# Setup complete
Write-EventLog -LogName "Application" -Source "BasePS1" -EventID 3001 -EntryType Information -Message "PowerShell Base script completed." -Category 1 -RawData 10,20
Write-Host "Initialization complete!"

Restart-Computer -Force