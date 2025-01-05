Configuration InstallActiveDirectory {
    param (
        [string]$DomainName,
        [PSCredential]$SafeModePassword
    )

    Import-DscResource -ModuleName 'xActiveDirectory'

    Node localhost {
        WindowsFeature ADDSInstall {
            Name = "AD-Domain-Services"
            Ensure = "Present"
        }

        xADDomain MyDomain {
            DomainName = $DomainName
            SafemodeAdministratorPassword = $SafeModePassword
            DependsOn = "[WindowsFeature]ADDSInstall"
        }
    }
}

InstallActiveDirectory -OutputPath "C:\DSC"