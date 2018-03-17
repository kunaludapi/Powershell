#Run on the target node
Configuration SetLCMPullMode {
    param([string]$ComputerName,
        [guid]$Guid
    )
    
    Node $ComputerName {
        LocalConfigurationManager {
            ConfigurationID                   = $Guid
            DownloadManagerName                = 'WebDownloadManager'
            RefreshMode                        = 'Pull' 
            RebootNodeIfNeeded                 = $true
            RefreshFrequencyMins               = 30
            ConfigurationModeFrequencyMins     = 30
            ConfigurationMode                  = 'ApplyAndAutoCorrect'
            DownloadManagerCustomData = @{
                ServerUrl                      = 'http://dscserver:8080/PSDSCPullServer.svc/'
                AllowUnsecureConnection        = $true
            }
        }
    }
}

#Create the .MOF meta file for the target node
cd C:\Temp
SetLCMPullMode -ComputerName srv01 -Guid 8b055a11-04fb-4eaf-b560-b5ea1fc3d298

#We're essenially turning on pull mode on the target
Set-DscLocalConfigurationManager -Path .\SetLCMPullMode -Verbose

#Forcefully pull update dsc configuration and apply it, check the status
Update-DscConfiguration -Wait -Verbose
Get-DscConfigurationStatus
