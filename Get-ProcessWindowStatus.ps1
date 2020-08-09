#Add-Type -AssemblyName UIAutomationClient
function Get-ProcessState 
{
    <#
        Written by: http://vcloud-lab.com
        Last Edit: 06-July-2020
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProcessName = 'Notepad'
    )
    Begin 
    {
        Add-Type -AssemblyName UIAutomationClient
    }
    process
    {
        $processList = Get-Process -Name $ProcessName
        foreach ($process in $processList) 
        {
            $automationElement = [System.Windows.Automation.AutomationElement]::FromHandle($process.MainWindowHandle)
            $processPattern = $automationElement.GetCurrentPattern([System.Windows.Automation.WindowPatternIdentifiers]::Pattern)
            [PSCustomObject]@{
                Process = $process.MainWindowTitle
                ProcessState = $processPattern.Current.WindowVisualState
            }
        }
    }
}