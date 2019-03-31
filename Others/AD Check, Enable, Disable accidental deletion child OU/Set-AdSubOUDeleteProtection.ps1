<#  
    .Synopsis  
     Get report, enable and disable parent OU (orgnaization unit) and its sub OU Protected from accidental deletion.
    .Description  
     Run this script on domain controller, or install RSAT tool on your client machine. Get report, enable and disable of OU (orgnaization unit) with Protected from accidental deletion status and creation date, It validates provided OU name and get the all its Sub OUs.
    .Example  
     .\Set-AdSubOUDeleteProtection.ps1 
             
     Execute script to get report, set enable or disable status of protected from accidental deletion.

    .Example
     .\Set-AdSubOUDeleteProtection.ps1 | Export-Csv c:\temp\Report.csv
             
     Use export-csv on report only option, this will pipeline selected report to csv file.
    .Notes
     NAME: Set-AdSubOUDeleteProtection.ps1
     AUTHOR: Kunal Udapi
     CREATIONDATE: 23 March 2019
     LASTEDIT: 24 March 2019
     KEYWORDS: Get report and enable disable  of OU (orgnaization unit) and its sub OU with Protected from accidental deletion.
     OS: Windows 2016

    .Link  
    #Check Online version: http://kunaludapi.blogspot.com
    #Check Online version: http://vcloud-lab.com
    #Requires -Version 3.0  
    #>  
#requires -Version 3   

[CmdletBinding()]
param
(  
    #[Parameter(Mandatory=$true, ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$true)]
    #[alias('ParentOU','OUName')]
    #[String]$Ou = 'Domain Controllers', #change
)

Begin 
{  
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    function Show-MessageBox 
    {   
        param (   
          [string]$Message = "Show user friendly Text Message",   
          [string]$Title = 'Title here',   
          [ValidateRange(0,5)]   
          [Int]$Button = 0,   
          [ValidateSet('None','Hand','Error','Stop','Question','Exclamation','Warning','Asterisk','Information')]   
          [string]$Icon = 'Error'   
        )   
        #Note: $Button is equl to [System.Enum]::GetNames([System.Windows.Forms.MessageBoxButtons])   
        #Note: $Icon is equl to [System.Enum]::GetNames([System.Windows.Forms.MessageBoxIcon])   
        $MessageIcon = [System.Windows.Forms.MessageBoxIcon]::$Icon   
        [System.Windows.Forms.MessageBox]::Show($Message,$Title,$Button,$MessageIcon)   
    }  
    Function Confirm-AD 
    {  
        $AllModules = Get-Module -ListAvailable ActiveDirectory  
        if (!$AllModules) 
        {  
            Show-MessageBox -Message 'Install RSAT tool or AD Management tools' -Title 'Missing Ad tools' -Icon Error | Out-Null
            #Write-Host -BackgroundColor DarkRed 'Install RSAT tool or AD Management tools'
            break
        }
        else 
        {
            try 
            {
                Import-Module ActiveDirectory -ErrorAction Stop
            }
            catch 
            {
                #Write-Host -BackgroundColor DarkRed 'Active Directory module loading failed'
                Show-MessageBox -Message 'Active Directory module loading failed' -Title 'AD Module failed' -Icon Error | Out-Null
                break
            }
        }
    }
    Confirm-AD

    function Show-FormGUI 
    {
        $form = New-Object System.Windows.Forms.Form
        $form.Text = 'Sub Ou report'
        $form.Size = New-Object System.Drawing.Size(300,200)
        $form.StartPosition = 'CenterScreen'

        $MyGroupBox = New-Object System.Windows.Forms.GroupBox
        $MyGroupBox.Location = New-Object System.Drawing.Point(5,5)
        $MyGroupBox.size = New-Object System.Drawing.Size(275,150)
        $MyGroupBox.text = 'OU selection, Run as Administrator'
    
        $OKButton = New-Object System.Windows.Forms.Button
        $OKButton.Location = New-Object System.Drawing.Point(75,120)
        $OKButton.Size = New-Object System.Drawing.Size(75,23)
        $OKButton.Text = 'OK'
        $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $form.AcceptButton = $OKButton

        $CancelButton = New-Object System.Windows.Forms.Button
        $CancelButton.Location = New-Object System.Drawing.Point(150,120)
        $CancelButton.Size = New-Object System.Drawing.Size(75,23)
        $CancelButton.Text = 'Cancel'
        $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $form.CancelButton = $CancelButton

        $label = New-Object System.Windows.Forms.Label
        $label.Location = New-Object System.Drawing.Point(10,20)
        $label.Size = New-Object System.Drawing.Size(260,20)
        $label.Text = 'Type parent OU (Orgnization Unit) Name:'
        #$form.Controls.Add($label)

        $textBox = New-Object System.Windows.Forms.TextBox
        $textBox.Location = New-Object System.Drawing.Point(10,40)
        $textBox.Size = New-Object System.Drawing.Size(260,20)
        $textBox.Text = 'Domain Controllers'
        #$form.Controls.Add($textBox)

        $Global:RadioButton1 = New-Object System.Windows.Forms.RadioButton
        $RadioButton1.Location = New-Object System.Drawing.Point(10,90)
        $RadioButton1.size = New-Object System.Drawing.Size(65,20)
        $RadioButton1.Checked = $true 
        $RadioButton1.Text = 'Reports'

        $label1 = New-Object System.Windows.Forms.Label
        $label1.Location = New-Object System.Drawing.Point(80,70)
        $label1.Size = New-Object System.Drawing.Size(185,20)
        $label1.Text = 'Sub OU protect accidental deletion'
        #$form.Controls.Add($label)

        $Global:RadioButton2 = New-Object System.Windows.Forms.RadioButton
        $RadioButton2.Location = New-Object System.Drawing.Point(80,90)
        $RadioButton2.size = New-Object System.Drawing.Size(65,20)
        $RadioButton2.Checked = $false
        $RadioButton2.Text = 'Enable'

        $Global:RadioButton3 = New-Object System.Windows.Forms.RadioButton
        $RadioButton3.Location = New-Object System.Drawing.Point(150,90)
        $RadioButton3.size = New-Object System.Drawing.Size(65,20)
        $RadioButton3.Checked = $false
        $RadioButton3.Text = 'Disable'

        $form.Controls.Add($MyGroupBox)
        $MyGroupBox.Controls.AddRange(@($OKButton, $CancelButton, $label, $textBox, $RadioButton1, $label1, $RadioButton2, $RadioButton3))
        $form.Add_Shown({$textBox.Select()})
        $form.TopMost = $true

        $Global:diagResult = $form.ShowDialog()
        $Global:ou = $textBox.Text
    }
    Show-FormGUI
    
    $tempFileName = [System.IO.Path]::GetTempFileName()
    Add-Content $tempFileName ('=' * 60)
} #Begin

Process 
{
    while ($diagResult -ne [System.Windows.Forms.DialogResult]::Cancel)
    {
        if ($ou.trim() -eq '')
        {
            Show-MessageBox -Message 'OU (Orgnization Unit) inputbox empty' -Icon Error -Title 'OU name error' | Out-Null
        } #if ($ou.trim() -eq '')
        else 
        {
            try
            {
                $parentOuDn = Get-ADOrganizationalUnit -Filter {Name -eq $ou} -Properties ProtectedFromAccidentalDeletion, Created -ErrorAction Stop
                if ($null -eq $parentOuDn) {
                    Show-MessageBox -Message "OU '$ou' doesn't exist in AD" -Icon Error -Title 'OU not found' | Out-Null
                    #break
                } #if ($null -eq $parentOuDn) {
                else 
                {
                    $ouDn = $parentOuDn.DistinguishedName
                    Show-MessageBox -Message 'Filter and select OU from next GridView and Click OK button to process' -Icon Information -Title 'Select OU from gridview' | Out-Null
                    try 
                    {
                        $ouInfo = Get-ADOrganizationalUnit -SearchBase $oUDN -SearchScope Subtree -Filter * -Properties ProtectedFromAccidentalDeletion, Created, Description, CanonicalName -ErrorAction Stop
                        if ($RadioButton1.Checked)
                        {
                            $ouInfo | Select-Object Name, DistinguishedName, Created, ProtectedFromAccidentalDeletion, ManagedBy, Country, Description, State, @{N='ParentOU';E={$_.CanonicalName.split('/')[-2]}} | Out-GridView -Title "OU '$ou' information" -PassThru
                            break
                        }
                        elseif ($RadioButton2.Checked) 
                        {
                            $childOusFalse = $ouInfo | Where-Object {$_.ProtectedFromAccidentalDeletion -eq $false} | Out-GridView -Title "OU '$ou' information" -PassThru
                            if ($null -ne $childOusFalse) 
                            {
                                Add-Content $tempFileName 'Enable Logs - Run tool as administrator if failing'
                                Add-Content $tempFileName $('=' * 60)
                                $logs = @()
                                foreach ($childOu in $childOusFalse) 
                                {
                                    try 
                                    {
                                        $childOu | Set-adobject -ProtectedFromAccidentalDeletion $true -ErrorAction Stop
                                        $logs += "Ou $($childOu.Name) - Protect from accidental deletion - Enabled successful`n"
                                    }
                                    catch 
                                    {
                                        $logs += "Ou $($childOu.Name) - Protect from accidental deletion - Enabled failed`n"
                                    }
                                } #foreach ($childOu in $childOusFalse)
                                Add-Content $tempFileName $logs
                                $notepadApp = Start-Process notepad $tempFileName -PassThru
                                [void](New-Object -ComObject WScript.Shell).AppActivate(($notepadApp).MainWindowTitle)
                                break
                            }
                            else 
                            {
                                Show-MessageBox -Message 'Select OU from GridView and Click OK button to enable' -Icon Information -Title 'No Ou selected' | Out-Null
                            }
                        }
                        elseif ($RadioButton3.Checked = $true)
                        {
                            $childOusFalse = $ouInfo | Where-Object {$_.ProtectedFromAccidentalDeletion -eq $true} | Out-GridView -Title "OU '$ou' information" -PassThru
                            if ($null -ne $childOusFalse) 
                            {
                                Add-Content $tempFileName 'Disable Logs - Run tool as administrator if failing'
                                Add-Content $tempFileName $('=' * 60)
                                $logs = @()
                                foreach ($childOu in $childOusFalse) 
                                {
                                    try 
                                    {
                                        $childOu | Set-adobject -ProtectedFromAccidentalDeletion $false -ErrorAction Stop
                                        $logs += "Ou $($childOu.Name) - Protect from accidental deletion - Disabled successful`n"
                                    }
                                    catch 
                                    {
                                        $logs += "Ou $($childOu.Name) - Protect from accidental deletion - Disabled failed`n"
                                    }
                                } #foreach ($childOu in $childOusFalse)
                                Add-Content $tempFileName $logs
                                $notepadApp = Start-Process notepad $tempFileName -PassThru
                                [void](New-Object -ComObject WScript.Shell).AppActivate(($notepadApp).MainWindowTitle)
                                break
                            }
                            else 
                            {
                                Show-MessageBox -Message 'Select OU from GridView and Click OK button to disable' -Icon Information -Title 'No Ou selected' | Out-Null
                            }
                        }
                    } #try
                    catch 
                    {
                        Show-MessageBox -Message $Error[0].Exception.Message -Icon Error -Title 'ERROR' | Out-Null
                        break
                    } #catch
                
                } #else
            } #try
            catch
            {
                Show-MessageBox -Message $error[0].Exception.Message -Title "Error" -Icon Error | Out-Null
                
            } #catch
        }
        Show-FormGUI
    } #do
} #Process
end {
}