# init.ps1 - Windows Server Initialization Script

Start-Transcript -Path C:\Windows\Temp\base_script.log -Append
Write-Output "Custom Script Execution Started"

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

# Configure Time Zone
Write-Host "Configuring time zone..."
Set-TimeZone -Id "Singapore Standard Time"
# Setup complete
Write-Host "Initialization complete!"

Stop-Transcript
Restart-Computer -Force