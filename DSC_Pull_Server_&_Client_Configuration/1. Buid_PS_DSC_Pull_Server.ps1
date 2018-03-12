#1: Download and Install required modules powershell DSC Modules
Install-Module -Name xPSDesiredStateConfiguration

#2: Install roles and configure the Pull Server
Configuration DscServer {
    param (
        [String[]]$ComputerName = 'Localhost'
    )
    Import-DscResource -ModuleName xPSDesiredStateConfiguration
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    
    Node $Computername {
        WindowsFeature DSCServiceFeature {
            Ensure = 'Present'
            Name = 'DSC-Service'
        }

        xDSCWebService DscServer {
            Ensure                      = 'Present'
            EndpointName                = 'DscServer'
            Port                        = 8080
            PhysicalPath                = "$env:SystemDrive\inetpub\wwwroot\DscServer"
            CertificateThumbPrint       = 'AllowUnencryptedTraffic'
            ModulePath                  = "$env:PROGRAMFILES\WindowsPowershell\DscServer\Module"
            ConfigurationPath           = "$env:PROGRAMFILES\WindowsPowershell\DscServer\Configuration"
            State                       = "Started"
            UseSecurityBestPractices    = $false
            DependsOn                   = "[WindowsFeature]DSCServiceFeature"
        }
    }
}

#3: Creates the Pull server .mof file
cd C:\Temp
DscServer 

#4: Apply the Pull Server configuration to the Pull Server
Start-DscConfiguration C:\Temp\DscServer -Force -Wait -Verbose
