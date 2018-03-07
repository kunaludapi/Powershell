<# This form was created using POSHGUI.com  a free online gui designer for PowerShell 
   WrittenBy:  http://vcloud-lab.com
.NAME 
    SID to Account
    Account to SID

#> 

#Add-Type -AssemblyName System.Windows.Forms
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")  
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  
[System.Windows.Forms.Application]::EnableVisualStyles() 

function Get-SID { 
    try { 
            $LocalAccount = New-Object System.Security.Principal.NTAccount(($InputBox.Text).trim()) -ErrorAction Stop 
            $LocalSID = $LocalAccount.Translate([System.Security.Principal.SecurityIdentifier]) 
            $OutputResult.Text = $LocalSID.Value 
        } 
        catch { 
            [System.Windows.Forms.MessageBox]::Show("Typed Domain\AccountName not valid", "Invalid details") 
            $OutputResult.Text = '' 
        } 
} 

function Get-Account { 
    try { 
        $SID = New-Object System.Security.Principal.SecurityIdentifier(($InputBox.Text).trim()) -ErrorAction Stop 
        $DomainAccount = $SID.Translate([System.Security.Principal.NTAccount]) 
        $OutputResult.Text = $DomainAccount.Value 
    } 
    catch { 
        [System.Windows.Forms.MessageBox]::Show("Typed SID is not valid", "Invalid details") 
        $OutputResult.Text = '' 
    } 
} 

#region begin GUI{ 
$Tooltip = New-Object System.Windows.Forms.ToolTip 
$ShowHelp = { 
    Switch ($this.name) { 
        'InputBox'      {$Tip = "If local checked don't provide domainname"; Break} 
        'SidToUser'     {$Tip = 'Type Valid Domain\UserName'; Break} 
        'UserToSid'     {$Tip = 'Type Valid User SID'; Break} 
        'LocalCheckBox' {$Tip = "If local checked don't provide domainname"; Break} 
    } 
    $Tooltip.SetToolTip($this,$Tip) 
} 

$vcloudlabform                      = New-Object system.Windows.Forms.Form 
$vcloudlabform.ClientSize           = '396,172' 
$vcloudlabform.text                 = "SID to Account and Vice Versa" 
$vcloudlabform.TopMost              = $false 

$InputBox                           = New-Object system.Windows.Forms.TextBox 
$InputBox.Name                      = 'InputBox' 
$InputBox.multiline                 = $false 
$InputBox.width                     = 366 
$InputBox.height                    = 20 
$InputBox.location                  = New-Object System.Drawing.Point(8,19) 
$InputBox.Font                      = 'Microsoft Sans Serif,10' 
$InputBoxWaterMark                  = 'Type valid User, Group with Domain or SID' 
$InputBox.ForeColor                 = 'LightGray' 
$InputBox.Text                      = $InputBoxWaterMark 
$InputBox.add_MouseHover($ShowHelp) 
$InputBox.add_TextChanged({$InputBox.ForeColor = 'Black'}) 

$SidToAccount                       = New-Object system.Windows.Forms.Button 
$SidToAccount.Name                  = 'SidToUser' 
$SidToAccount.text                  = 'SID-To-Account' 
$SidToAccount.width                 = 115 
$SidToAccount.height                = 30 
$SidToAccount.location              = New-Object System.Drawing.Point(10,98) 
$SidToAccount.Font                  = 'Microsoft Sans Serif,10' 
$SidToAccount.add_MouseHover($ShowHelp) 
$SidToAccount.add_Click({Show-SIDToAccount}) 

$AccountToSid                       = New-Object system.Windows.Forms.Button 
$AccountToSid.Name                  = 'UserToSid' 
$AccountToSid.text                  = 'Account-To-SID' 
$AccountToSid.width                 = 115 
$AccountToSid.height                = 30 
$AccountToSid.location              = New-Object System.Drawing.Point(127,98) 
$AccountToSid.Font                  = 'Microsoft Sans Serif,10' 
$AccountToSid.add_MouseHover($ShowHelp) 
$AccountToSid.add_Click({Show-AccountToSID}) 

$OutputResult                       = New-Object system.Windows.Forms.TextBox 
$OutputResult.Name                  = 'OutputResult' 
$OutputResult.multiline             = $false 
$OutputResult.width                 = 366 
$OutputResult.height                = 20 
$OutputResult.location              = New-Object System.Drawing.Point(8,53) 
$OutputResult.Font                  = 'Microsoft Sans Serif,10' 
$OutputResult.ReadOnly              = $true 

$Site                               = New-Object system.Windows.Forms.LinkLabel 
$Site.Name                          = 'Site' 
$Site.text                          = "http://vcloud-lab.com" 
$Site.LinkColor                     = "#0074A2" 
$Site.ActiveLinkColor               = "#114C7F" 
$Site.AutoSize                      = $true 
$Site.width                         = 25 
$Site.height                        = 10 
$Site.location                      = New-Object System.Drawing.Point(260,154) 
$Site.Font                          = 'Microsoft Sans Serif,10' 
$Site.add_Click({[system.Diagnostics.Process]::start('http://vcloud-lab.com')}) 

$vcloudlabform.controls.AddRange(@($InputBox,$OutputResult,$SidToAccount,$AccountToSid,$Site)) 

#region gui events { 
function Show-AccountToSID { 
    if (($InputBox.Text -eq $InputBoxWaterMark) -or ($InputBox.Text -eq '')) { 
        [System.Windows.Forms.MessageBox]::Show("Please type valid Domain\Account", "Textbox empty") 
    } 
    else { 
        Get-SID 
    } 
} 

function Show-SIDToAccount { 
    if (($InputBox.Text -eq $InputBoxWaterMark) -or ($InputBox.Text -eq '')) { 
        [System.Windows.Forms.MessageBox]::Show("Please type valid SID", "Textbox empty") 
    } 
    else { 
        Get-Account 
    } 
} 
#endregion events } 
#endregion GUI } 
 
[void]$vcloudlabform.ShowDialog()
