#Change folder location - MOF MetaData files will be created on this location.
Set-Location c:\temp

#This is a configuration script for the Desired State Configuration (DSC) Local Configuration Manager (LCM) 
[DscLocalConfigurationManager()] #DscLocalConfigurationManager attribute.
Configuration AzureDscLcmConfig #Configuraion DSC script Starts
{ 
    param 
    ( 
        [Parameter(Mandatory=$True)][String[]]$ComputerName,  
        [Parameter(Mandatory=$True)][String]$AzureDscServerUrl,
        [Parameter(Mandatory=$True)][String]$AzureDscRegistrationKey,
        [Parameter(Mandatory=$True)][String]$AzureDSCNodeConfigurationName
    )
    Node $ComputerName
    {
        $ConfigurationNames = @($AzureDSCNodeConfigurationName)
        #local Configuration Manager (LCM) settings
        Settings 
        { 
            RefreshFrequencyMins = 30
            ConfigurationModeFrequencyMins = 15
            RefreshMode = 'Pull'
            ConfigurationMode = 'ApplyAndMonitor' 
            AllowModuleOverwrite = $False
            RebootNodeIfNeeded = $False 
            ActionAfterReboot = 'ContinueConfiguration'            
        }
        #Configure Azure DSC configuration pull Server Information 
        ConfigurationRepositoryWeb AzureAutomationDSC 
        { 
            ServerUrl = $AzureDscServerUrl
            RegistrationKey = $AzureDscRegistrationKey
            ConfigurationNames = $ConfigurationNames
        }
        #Configure Azure DSC resource pull Server Information
        ResourceRepositoryWeb AzureAutomationDSC
        {
            ServerUrl = $AzureDscServerUrl
            RegistrationKey = $AzureDscRegistrationKey
        }
        #Configure Azure DSC reporting pull Server Information
        ReportServerWeb AzureAutomationDSC 
        { 
            ServerUrl = $AzureDscServerUrl 
            RegistrationKey = $AzureDscRegistrationKey
        }
    } 
}

#Create the metaconfigurations, The DSC configuration that will generate metaconfigurations, need to uploaded to Azure DSC.
$Params = @{
    ComputerName = @($env:COMPUTERNAME)
    AzureDscServerUrl = 'https://wus2-agentservice-prod-1.azure-automation.net/accounts/dd4d88ef-e37a-41b3-ba6d-fda11354b725'
    AzureDscRegistrationKey = 'zrnxVStK6tHDPB7Div3vtDDZ24Ow0oR3aeLU+LbbBqXt2+6KaCYt/cCciTjMz6j9yHhxjxyTSvcIUCDxfSJxew=='
    AzureDSCNodeConfigurationName = 'CreateFileDemo.localhost'
}
AzureDscLcmConfig @Params

#Push the configuration on local server
Set-DscLocalConfigurationManager -Path C:\temp\AzureDscLcmConfig -Verbose