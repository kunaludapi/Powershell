<#  
    .Synopsis  
     Get report of OU (orgnaization unit) and its sub OU with Protected from accidental deletion status and creation date.
    .Description  
     Run this script on domain controller, or install RSAT tool on your client machine. Get report of OU (orgnaization unit) with Protected from accidental deletion status and creation date, It validates provided OU name and get the all its Sub OUs.
    .Example  
     .\Get-AdSubOrgnizationUnitReport.ps1 
             
     You need to provide Ou name in parameter, it gets the report of all the Sub OUs in gridview, filter and select itmes in gridview information shows on console, You will need ot press ok.
    .Example
     .\Get-AdSubOrgnizationUnitReport.ps1 -NoOutGrid:$true

     If you provide Outgrid as true reports are shown on console.

    .Notes
     NAME: Get-AdSubOrgnizationUnitReport
     AUTHOR: Kunal Udapi
     CREATIONDATE: 18 February 2019
     LASTEDIT: 19 February 2019
     KEYWORDS: Get report of OU (orgnaization unit) and its sub OU with Protected from accidental deletion status and creation date.
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
    [Switch]$NoOutGrid
)

Begin 
{  
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

    #Source: https://docs.microsoft.com/en-us/powershell/scripting/samples/creating-a-custom-input-box?view=powershell-6
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'OU (Organization Unit)'
    $form.Size = New-Object System.Drawing.Size(300,200)
    $form.StartPosition = 'CenterScreen'
    $form.TopMost = $true

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(75,120)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = 'OK'
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point(150,120)
    $CancelButton.Size = New-Object System.Drawing.Size(75,23)
    $CancelButton.Text = 'Cancel'
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $CancelButton
    $form.Controls.Add($CancelButton)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,20)
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.Text = 'Type parent OU (Orgnization Unit) Name:'
    $form.Controls.Add($label)

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10,40)
    $textBox.Size = New-Object System.Drawing.Size(260,20)
    $textBox.Text = 'Domain Controllers'
    $form.Controls.Add($textBox)

    $form.Topmost = $true

    $form.Add_Shown({$textBox.Select()})
    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $ou = $textBox.Text
    }
    else 
    {
        break
    }
} #Begin

Process 
{
    try 
    {
        Write-Host -BackgroundColor DarkGray 'Verifying orgnazation group in AD...' -NoNewline
        $parentOuDn = Get-ADOrganizationalUnit -Filter {Name -eq $ou} -Properties ProtectedFromAccidentalDeletion, Created -ErrorAction Stop
        if ($null -eq $parentOuDn) {
            Write-Host -BackgroundColor DarkRed "...OU didn't find in AD"
        }
        else {
            Write-Host -BackgroundColor DarkGreen '...OU vefired in AD'
            $ouDn = $parentOuDn.DistinguishedName
            try {
                $ouInfo = Get-ADOrganizationalUnit -SearchBase $oUDN -SearchScope Subtree -Filter * -Properties ProtectedFromAccidentalDeletion, Created, Description, CanonicalName -ErrorAction Stop
            }
            catch {
                Write-Host -BackgroundColor DarkMagenta "`n`t"- $($Error[0].Exception.Message)
            }
        }

        if ($NoOutGrid -eq $false)
        {
            $ouInfo | Select-Object Name, DistinguishedName, Created, ProtectedFromAccidentalDeletion, ManagedBy, Country, Description, State, @{N='ParentOU';E={$_.CanonicalName.split('/')[-2]}} | Out-GridView -Title "OU '$ou' information" -PassThru
        }
        else 
        {
            $ouInfo | Select-Object Name, DistinguishedName, Created, ProtectedFromAccidentalDeletion, ManagedBy, Country, Description, State, @{N='ParentOU';E={$_.CanonicalName.split('/')[-2]}}
        }
        #| where {$_.ProtectedFromAccidentalDeletion -eq $false
    }
    catch
    {
        Write-Host -BackgroundColor DarkRed "...OU didn't find in AD"
        Show-MessageBox -Message $error[0].Exception.Message -Title 'OU Error' -Icon Error | Out-Null
    }
} #Process
end {
}