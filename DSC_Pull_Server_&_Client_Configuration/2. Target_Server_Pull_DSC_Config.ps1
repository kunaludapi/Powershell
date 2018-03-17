#1: Member server configuration
Configuration BasicConf {
    #Accepts a string value computername or defaults to localhost
    Param (
        [string[]]$ComputerName = 'Localhost'
    )
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    #Target node
    Node $ComputerName {
        #Ensure user is exist
        File TempFolder {
            Ensure             = 'Present'
            DestinationPath    = 'C:\TempFolder'
            Type               = 'Directory' 
        }

        Environment CustomApp {
            Ensure             = 'Present'
            Name               = 'CustomApp'
            Value              = 'C:\TempFolder'
            Path               = $true
            DependsOn          = "[File]TempFolder"
        }
    }
}

#3: Generate .mof file
cd C:\Temp
BasicConf -Computername srv01

#4: Copy .mof files to the DSC configuration location
#$Guid = [guid]::NewGuid()
$Guid = New-Guid | Select-Object -ExpandProperty Guid
$SourceMof = 'C:\Temp\BasicConf\srv01.mof'
$DestinationMof = "C:\Program Files\WindowsPowerShell\DscServer\Configuration\$Guid.mof"
Copy-Item $SourceMof $DestinationMof
New-DscChecksum $DestinationMof

