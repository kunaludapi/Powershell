<#  
   .NOTES  
   --------------------------------------------------------------------------------  
    Code generated using by: Visual Studio 2017
    Created on:              26 June 2018 4:57 AM  
    Get Help on:             http://vcloud-lab.com  
    Written by:              Kunal Udapi  
    Build & Tested on:       Windows 10  
    Purpose:                 This script is an example of styling Font on textbox.
    Useful Article:          http://www.wpf-tutorial.com/basic-controls/the-textblock-control-inline-formatting/
   --------------------------------------------------------------------------------  
   .DESCRIPTION  
     GUI script generated using Visual Studio 2017  
#>  

$Path = Split-Path -Parent $MyInvocation.MyCommand.Path
$ImgSrc = "$Path\BackGround.jpg"

#Load required libraries 
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing
[xml]$xaml = @"
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp10"
        Title="Server Audit" Height="390" Width="476" ResizeMode="NoResize" Topmost="True" WindowStartupLocation="CenterScreen">

    <Grid>
        <Image HorizontalAlignment="Left" Height="419" VerticalAlignment="Top" Width="469" Source="$ImgSrc"/>
        <Label Name='Url' Content='http://vcloud-lab.com' HorizontalAlignment="Left" Margin="334,7,0,0" VerticalAlignment="Top" Foreground="LightGray" Cursor='Hand' ToolTip='http://vcloud-lab.com'/>
        <TextBox Name='ComputerName' HorizontalAlignment="Left" Height="23" Margin="10,10,0,0" TextWrapping="Wrap" Text="$env:COMPUTERNAME" VerticalAlignment="Top" Width="177"/>
        <Button Name='Audit' Content="Audit" HorizontalAlignment="Left" Margin="192,10,0,0" VerticalAlignment="Top" Height="23" Width="75"/>
        <TextBlock Name='CompInfo' HorizontalAlignment="Left" Margin="10,38,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="449" Height="180"/>
        <RichTextBox Name='AuditPart' HorizontalAlignment="Left" Height="110" Margin="10,230,0,0" VerticalAlignment="Top" Width="440">
            <RichTextBox.Resources>
                <Style TargetType="{x:Type Paragraph}">
                    <Setter Property="Margin" Value="0" />
                </Style>
            </RichTextBox.Resources>
                <FlowDocument>
                    <Paragraph>
                        <!-- <Run Text="RichTextBox"/> -->
                    </Paragraph>
                </FlowDocument>
        </RichTextBox>
    </Grid>
</Window>
"@ 

#Read the form 
$Reader = (New-Object System.Xml.XmlNodeReader $xaml)  
$Form = [Windows.Markup.XamlReader]::Load($reader)  

#AutoFind all controls 
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")  | ForEach-Object {  
  New-Variable  -Name $_.Name -Value $Form.FindName($_.Name) -Force  
}

$AuditPart.IsReadOnly = $true
$Url.Add_MouseLeftButtonUp({[system.Diagnostics.Process]::start('http://www.google.com')})
$Url.Add_MouseEnter({$Url.Foreground = 'DarkGray'})
$Url.Add_MouseLeave({$Url.Foreground = 'LightGray'})

function TextFormatting {
    [CmdletBinding(
        ConfirmImpact='Medium',
        HelpURI='http://vcloud-lab.com'
    )]
    Param (
        [parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [String]$Text,
        [Switch]$Bold, #https://docs.microsoft.com/en-us/uwp/api/windows.ui.text.fontweights
        [Switch]$Italic, #https://docs.microsoft.com/en-us/uwp/api/windows.ui.text.fontstyle
        [String]$TextDecorations, #https://docs.microsoft.com/en-us/uwp/api/windows.ui.text.textdecorations
        [Int]$FontSize,
        [String]$Foreground,
        [String]$Background,
        [Switch]$NewLine
    )
    Begin {
        #https://docs.microsoft.com/en-us/uwp/api/windows.ui.text
        $ObjRun = New-Object System.Windows.Documents.Run
        function TextUIElement {
            Param (
                    [parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
                    [String]$PropertyName
                )
            $Script:PropValue = $PropertyName
            Switch ($PropertyName) {
                'Bold' {'FontWeight'} #Thin, SemiLight, SemiBold, Normal, Medium, Light, ExtraLight, ExtraBold, ExtraBlack, Bold, Black
                'Italic' {'FontStyle'} #Italic, Normal, Oblique
                'TextDecorations' {'TextDecorations'} #None, Strikethrough, Underline
                'FontSize' {'FontSize'}
                'Foreground' {'Foreground'}
                'Background' {'Background'}
                'NewLine' {'NewLine'}
            }
        }
    }
    Process {
        if ($PSBoundParameters.ContainsKey('NewLine')) {
            $ObjRun.Text = "`n$Text "
        }
        else  {
            $ObjRun.Text = $Text
        }
        
        $AllParameters = $PSBoundParameters.Keys | Where-Object {$_ -ne 'Text'}

        foreach ($SelectedParam in $AllParameters) {
            $Prop = TextUIElement -PropertyName $SelectedParam
            if ($PSBoundParameters[$SelectedParam] -eq [System.Management.Automation.SwitchParameter]::Present) {
                $ObjRun.$Prop = $PropValue
            }
            else {
                $ObjRun.$Prop = $PSBoundParameters[$Prop]
            }
        }
        $ObjRun
    }
}
function Format-RichTextBox {
    #https://msdn.microsoft.com/en-us/library/system.windows.documents.textelement(v=vs.110).aspx#Propertiesshut
    param (
        [parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [System.Windows.Controls.RichTextBox]$RichTextBoxControl,
        [String]$Text,
        [String]$ForeGroundColor = 'Black',
        [String]$BackGroundColor = 'White',
        [String]$FontSize = '12',
        [String]$FontStyle = 'Normal',
        [String]$FontWeight = 'Normal',
        [Switch]$NewLine
    )
    $ParamOptions = $PSBoundParameters
    $RichTextRange = New-Object System.Windows.Documents.TextRange(<#$RichTextBoxControl.Document.ContentStart#>$RichTextBoxControl.Document.ContentEnd, $RichTextBoxControl.Document.ContentEnd)
    if ($ParamOptions.ContainsKey('NewLine')) {
        $RichTextRange.Text = "`n$Text"
    }
    else  {
        $RichTextRange.Text = $Text
    }

    $Defaults = @{ForeGroundColor='Black';BackGroundColor='White';FontSize='12'; FontStyle='Normal'; FontWeight='Normal'}
    foreach ($Key in $Defaults.Keys) {
        if ($ParamOptions.Keys -notcontains $Key) {
            $ParamOptions.Add($Key, $Defaults[$Key])
        }
    }  

    $AllParameters = $ParamOptions.Keys | Where-Object {@('RichTextBoxControl','Text','NewLine') -notcontains $_}
    foreach ($SelectedParam in $AllParameters) {
        if ($SelectedParam -eq 'ForeGroundColor') {$TextElement = [System.Windows.Documents.TextElement]::ForegroundProperty}
        elseif ($SelectedParam -eq 'BackGroundColor') {$TextElement = [System.Windows.Documents.TextElement]::BackgroundProperty}
        elseif ($SelectedParam -eq 'FontSize') {$TextElement = [System.Windows.Documents.TextElement]::FontSizeProperty}
        elseif ($SelectedParam -eq 'FontStyle') {$TextElement = [System.Windows.Documents.TextElement]::FontStyleProperty}
        elseif ($SelectedParam -eq 'FontWeight') {$TextElement = [System.Windows.Documents.TextElement]::FontWeightProperty}
        $RichTextRange.ApplyPropertyValue($TextElement, $ParamOptions[$SelectedParam])
    }
}

$Audit.Add_Click({

    $CompInfo.Text = ''
    $AuditPart.SelectAll()
    $AuditPart.Selection.Text = ''

    $OS = Get-WmiObject win32_OperatingSystem -ComputerName $ComputerName.Text
    $Bios = Get-WmiObject win32_Bios -ComputerName $ComputerName.Text
    $ComSys = Get-WmiObject win32_ComputerSystem -ComputerName $ComputerName.Text
    $Patch = Get-HotFix -ComputerName $ComputerName.Text | Sort-Object -Property InstalledOn -Descending | Select-Object HotFixID, InstalledOn -First 1
    $TimeZone = Get-WmiObject -Class win32_timezone -ComputerName $ComputerName.Text

    #$CompInfo.Inlines.Add($(TextFormatting -Text 'OS Name: ' -Bold -FontSize 14 -Italic -TextDecorations Underline -Foreground DarkGreen -Background DarkRed))
    $CompInfo.Inlines.Add($(TextFormatting -Text 'OS Name: ' -Bold -Italic))
    $CompInfo.Inlines.Add("$($OS.Caption) `n")
  
    $CompInfo.Inlines.Add($(TextFormatting -Text 'OS Version: ' -Bold))
    $CompInfo.Inlines.Add("$($OS.Version) `n") 
    $CompInfo.Inlines.Add($(TextFormatting -Text 'OS Architecture: ' -Bold))
    $CompInfo.Inlines.Add("$($OS.OSArchitecture) `n`n")

    $CompInfo.Inlines.Add($(TextFormatting -Text 'Hardware Manufacturer: ' -Bold -FontSize 16))
    $CompInfo.Inlines.Add("$($ComSys.Manufacturer) `n")
    $CompInfo.Inlines.Add($(TextFormatting -Text 'Hardware Model: ' -Bold))
    $CompInfo.Inlines.Add("$($ComSys.Model) `n")
    $CompInfo.Inlines.Add($(TextFormatting -Text 'Sr. Number: ' -Bold))
    $CompInfo.Inlines.Add("$($Bios.SerialNumber) `n")
    $CompInfo.Inlines.Add($(TextFormatting -Text 'Bios Version: ' -Bold))
    $CompInfo.Inlines.Add("$($Bios.Name) `n`n") 
   
    $CompInfo.Inlines.Add($(TextFormatting -Text 'Last patch and installed date: ' -Bold))
    $CompInfo.Inlines.Add($(TextFormatting -Text $Patch.HotFixID  -Italic -TextDecorations Underline -Foreground Blue -Bold))
    $CompInfo.Inlines.Add(" - $($Patch.InstalledOn) `n")

    $CompInfo.Inlines.Add($(TextFormatting -Text 'System TimeZone: ' -Bold))
    if ($TimeZone.StandardName -eq 'India Standard Time') {
        $CompInfo.Inlines.Add($(TextFormatting -Text $TimeZone.StandardName  -Italic -Background DarkRed -Foreground White))
    }
    else {
        $CompInfo.Inlines.Add($(TextFormatting -Text $TimeZone.StandardName  -Italic -Foreground DarkGreen))
    }
    $CompInfo.Inlines.Add(' - Should be EST, CST or PST')
    
    $CPU = Get-WmiObject win32_Processor -ComputerName $ComputerName.Text
    $Service = Get-Service -Name WinRM, RemoteRegistry -ComputerName $ComputerName.Text 
    Format-RichTextBox -RichTextBoxControl $AuditPart -Text 'Processor: ' -FontWeight Bold -FontSize 18
    Format-RichTextBox -RichTextBoxControl $AuditPart -Text $CPU.Name
    Format-RichTextBox -RichTextBoxControl $AuditPart -Text 'Virtualization Enabled: ' -FontWeight Bold -NewLine
    Format-RichTextBox -RichTextBoxControl $AuditPart -Text $CPU.VirtualizationFirmwareEnabled
    
    $AuditPart.AppendText("`n")
    Format-RichTextBox -RichTextBoxControl $AuditPart -Text 'Windows Remoting Service: ' -FontWeight Bold -NewLine
    $Winrm = $Service | Where-Object {$_.Name -eq 'WinRM'}
    if ($Winrm.Status -eq 'Running') {
        Format-RichTextBox -RichTextBoxControl $AuditPart -Text $Winrm.Status -BackGroundColor LightGreen
    }
    elseif ($Winrm.Status -eq 'Stopped') {
        Format-RichTextBox -RichTextBoxControl $AuditPart -Text $Winrm.Status -BackGroundColor DarkRed -ForeGroundColor White
    }
    else {
        Format-RichTextBox -RichTextBoxControl $AuditPart -Text $Winrm.Status -BackGroundColor Yellow
    }
    Format-RichTextBox -RichTextBoxControl $AuditPart -Text ' - WinRM must be Running'
    
    $RemoteRegistry = $Service | Where-Object {$_.Name -eq 'RemoteRegistry'}
    Format-RichTextBox -RichTextBoxControl $AuditPart -Text 'Remote Registry Service: ' -FontWeight Bold -NewLine
    if ($RemoteRegistry.Status -eq 'Running') {
        Format-RichTextBox -RichTextBoxControl $AuditPart -Text $RemoteRegistry.Status -BackGroundColor DarkRed -ForeGroundColor White
    }
    else {
        Format-RichTextBox -RichTextBoxControl $AuditPart -Text $RemoteRegistry.Status -BackGroundColor LightGreen
    }
    Format-RichTextBox -RichTextBoxControl $AuditPart -Text ' - Remove Registry must be stopped'

<#
$AuditPart.AppendText("New Text`n")
$AuditPart.Selection.Select($AuditPart.Selection.Start,$AuditPart.Selection.End)
$AuditPart.Selection.ApplyPropertyValue([System.Windows.Documents.TextElement]::ForegroundProperty,[System.Windows.Media.Brushes]::Red)
$AuditPart.AppendText("2nd Text`r")
$AuditPart.ScrollToEnd()
#>
  
})

#Mandetory last line of every script to load form 
[void]$Form.ShowDialog() 

