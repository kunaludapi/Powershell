#Load required libraries
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing 

[xml]$xaml = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApplication1"

        Title='Local Area Network (LAN) Settings' Height="380.609" Width="410.768" ResizeMode="NoResize">
    <Grid>
        <GroupBox x:Name="AutomaticConfGroup" Header="Automatic configuration" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" Height="147" Width="382">
            <DockPanel HorizontalAlignment="Left" LastChildFill="False" Margin="0,10,0,-5" Width="392">
                <Grid Height="123" VerticalAlignment="Top" Width="384" Margin="0,-9,0,0">
                    <Label x:Name="AutomaticConfLabel" Content="Automatic configuration may override manual settings. to Ensure the&#xD;&#xA;use of manual settings, disable automatic configuration." Height="45" VerticalAlignment="Top" Margin="-2,0,10,0"/>
                    <CheckBox x:Name="AutomaticDetectCheckBox" Content="Automatically detect settings" Height="23" VerticalAlignment="Top" Margin="6,43,120,0"/>
                    <CheckBox x:Name="UseAutomaticCheckBox" Content="Use automatic configuration script" HorizontalAlignment="Left" Margin="6,66,0,0" VerticalAlignment="Top" Width="278" Height="22"/>
                    <Label x:Name="AutoAddressLabel" Content="Address" HorizontalAlignment="Left" Margin="20,93,0,0" VerticalAlignment="Top" Width="58"/>
                    <RichTextBox x:Name="AutoAddressTextBox" HorizontalAlignment="Left" Height="26" Margin="83,93,0,0" VerticalAlignment="Top" Width="201"/>
                </Grid>
            </DockPanel>
        </GroupBox>
        <GroupBox x:Name="ProxyServerGroup" Header="Proxy server" HorizontalAlignment="Left" Margin="10,164,0,0" VerticalAlignment="Top" Height="143" Width="380">
            <DockPanel HorizontalAlignment="Left" Height="112" LastChildFill="False" Margin="0,10,-2,-1" VerticalAlignment="Top" Width="370">
                <Grid Height="112" VerticalAlignment="Top" Width="367">
                    <CheckBox x:Name="UseProxyCheckBox" Content="Use a proxy server for your LAN (These settings will not apply to&#xD;&#xA;dial-up or VPN connections)." HorizontalAlignment="Left" Margin="6,3,0,0" VerticalAlignment="Top" Width="361" Height="37"/>
                    <Label x:Name="ProxyAddressLabel" Content="Address:" HorizontalAlignment="Left" Margin="20,41,0,0" VerticalAlignment="Top"/>
                    <TextBox x:Name="ProxyAddressTextBox" HorizontalAlignment="Left" Height="26" Margin="80,41,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="96"/>
                    <Label x:Name="ProxyPortLabel" Content="Port:" HorizontalAlignment="Left" Margin="181,40,0,0" VerticalAlignment="Top"/>
                    <TextBox x:Name="ProxyPortTextBox" HorizontalAlignment="Left" Height="26" Margin="216,40,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="55"/>
                    <Button x:Name="ProxyAdvancedButton" Content="Advanced" HorizontalAlignment="Left" Margin="276,40,0,0" VerticalAlignment="Top" Width="81" Height="26"/>
                    <CheckBox x:Name="ProxyBypassCheckBox" Content="Bypass proxy server for local addresses" HorizontalAlignment="Left" Margin="6,73,0,0" VerticalAlignment="Top" Width="282" Height="22"/>
                </Grid>
            </DockPanel>
        </GroupBox>
        <Button x:Name="LANButton" Content="OK" HorizontalAlignment="Left" Margin="229,316,0,0" VerticalAlignment="Top" Width="75"/>
        <Button x:Name="CancelButton" Content="Cancel" HorizontalAlignment="Left" Margin="315,316,0,0" VerticalAlignment="Top" Width="75" RenderTransformOrigin="0.213,0.545"/>
        <Label x:Name="URL" Content="http://vcloud-lab.com" HorizontalAlignment="Left" Margin="10,314,0,0" VerticalAlignment="Top" Width="150" ToolTip='http://vcloud-lab.com'/>

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

<#
01 - neither of those 2 auto config boxes are checked
05 - just the Use automatic configuration script is checked
09 - just the Automatically detect settings is checked
0d - both of them are checked
#>

#Automatically Detect Settings
$AutoDetectregpath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections'
$AutoConfScriptregpath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\'
Function Get-AutoDetect {
    $AutoDetectRegKey = Get-ItemProperty -Path $AutoDetectregpath 
    $Script:DefaultConnectionSettings = $AutoDetectRegKey.DefaultConnectionSettings
    if ($Script:DefaultConnectionSettings[8] -eq 13) {
        $AutomaticDetectCheckBox.IsChecked = $true
        $UseAutomaticCheckBox.IsChecked = $true
        $AutoAddressTextBox.IsEnabled = $true
    }
    elseif ($Script:DefaultConnectionSettings[8] -eq 05) {
        $AutomaticDetectCheckBox.IsChecked = $false
        $UseAutomaticCheckBox.IsChecked = $true
        $AutoAddressTextBox.IsEnabled = $true
    }
    elseif ($Script:DefaultConnectionSettings[8] -eq 09) {
        $AutomaticDetectCheckBox.IsChecked = $true
        $UseAutomaticCheckBox.IsChecked = $false
        $AutoAddressTextBox.IsEnabled = $false
    }
    else {
        $AutomaticDetectCheckBox.IsChecked = $false
        $UseAutomaticCheckBox.IsChecked = $false
        $AutoAddressTextBox.IsEnabled = $false
    }
    $AutoConfScriptRegKey = Get-ItemProperty -Path $AutoConfScriptregpath
    $AutoAddressTextBox.Document.Blocks.Clear()
    $AutoAddressTextBox.AppendText($AutoConfScriptRegKey.AutoConfigURL)
}
Get-AutoDetect

Function Set-AutodetectKey {
    if ($AutomaticDetectCheckBox.IsChecked -eq $false -and $UseAutomaticCheckBox.IsChecked -eq $false) {
        $AutomaticDetectCheckBox.IsChecked = $false
        $UseAutomaticCheckBox.IsChecked = $false
        $AutoAddressTextBox.IsEnabled = $false
        $Script:AutoGroup = 01
    }
    elseif ($AutomaticDetectCheckBox.IsChecked -eq $false -and $UseAutomaticCheckBox.IsChecked -eq $true) {
        $AutomaticDetectCheckBox.IsChecked = $false
        $UseAutomaticCheckBox.IsChecked = $true
        $AutoAddressTextBox.IsEnabled = $true
        $Script:AutoGroup = 05
    }
    elseif ($AutomaticDetectCheckBox.IsChecked -eq $true -and $UseAutomaticCheckBox.IsChecked -eq $false) {
        $AutomaticDetectCheckBox.IsChecked = $true
        $UseAutomaticCheckBox.IsChecked = $false
        $AutoAddressTextBox.IsEnabled = $false
        $Script:AutoGroup = 09
    }
    else {
        $AutomaticDetectCheckBox.IsChecked = $true
        $UseAutomaticCheckBox.IsChecked = $true
        $AutoAddressTextBox.IsEnabled = $true
        $Script:AutoGroup = 13
    }
}


$AutomaticDetectCheckBox.Add_Click({
    Set-AutodetectKey
})

$UseAutomaticCheckBox.Add_Click({
    Set-AutodetectKey
})


function Enable-ProxyConf {
    $ProxyServerGroup.Content.Children.Children | foreach {$_.IsEnabled = $true}
}
function Disable-ProxyConf {
    $ProxyServerGroup.Content.Children.Children | Where-Object {$_.Name -ne 'UseProxyCheckBox' -and $_.gettype().name -ne 'Label'} | foreach {$_.IsEnabled = $false}
}

function Get-CurrentProxyInfo {
    $Script:CurrentInternetProxyInfo = Get-ItemProperty -Path $AutoConfScriptregpath
    if ($Script:CurrentInternetProxyInfo.ProxyEnable -eq 1) {
        $UseProxyCheckBox.IsChecked = $true
        Enable-ProxyConf
    }
    else {
        $UseProxyCheckBox.IsChecked = $false
        Disable-ProxyConf
    }
    if ($Script:CurrentInternetProxyInfo.ProxyServer -match '=') {
        $MainProxyServer = $Script:CurrentInternetProxyInfo.ProxyServer -split ';'
        $MainHTTPAdvancedSettings = $($MainProxyServer -match 'http=').Split('http=')[-1] -split ':'
        #$ProxyAddressTextBox.Text = $MainHTTPAdvancedSettings[0]
        #$ProxyPortTextBox.Text = $MainHTTPAdvancedSettings[1]
        $ProxyAddressTextBox.IsEnabled = $false
        $ProxyPortTextBox.IsEnabled = $false
    }
    else {
        $CurrentProxyInfo = $Script:CurrentInternetProxyInfo.ProxyServer -split ':'
        $ProxyAddressTextBox.Text = $CurrentProxyInfo[0]
        $ProxyPortTextBox.Text = $CurrentProxyInfo[1]
        $ProxyAddressTextBox.IsEnabled = $true
        $ProxyPortTextBox.IsEnabled = $true
    }
<#    
    if ($UseProxyCheckBox.IsChecked -eq $true) {
        $ProxyAddressTextBox.IsEnabled = $true
        $ProxyPortTextBox.IsEnabled = $true
    } 
    else {
        $ProxyAddressTextBox.IsEnabled = $false
        $ProxyPortTextBox.IsEnabled = $false
    }
#>
    if ($Script:CurrentInternetProxyInfo.ProxyOverride -match '<local>') {
        $ProxyBypassCheckBox.IsChecked = $true
    }
    else {
        $ProxyBypassCheckBox.IsChecked = $false
    }
}
Get-CurrentProxyInfo

function Set-AutoProxyGroup {
    $Script:DefaultConnectionSettings[8] = $Script:AutoGroup
    Set-ItemProperty -Path $AutoDetectregpath -Name DefaultConnectionSettings -Value $Script:DefaultConnectionSettings

    if ($Script:AutoGroup -eq 05 -or $Script:AutoGroup -eq 13) {
        $AutoAddressTextBox.SelectAll()
        if ($AutoAddressTextBox.Selection.Text -eq "") {
            Remove-ItemProperty -Path $AutoConfScriptregpath -Name AutoConfigURL -ErrorAction SilentlyContinue
            #$UseAutomaticCheckBox.IsChecked = $false
        }
        else {
            Set-ItemProperty -Path $AutoConfScriptregpath -Name AutoConfigURL -Value $AutoAddressTextBox.Selection.Text
        }
    }
    else  {
        Remove-ItemProperty -Path $AutoConfScriptregpath -Name AutoConfigURL -ErrorAction SilentlyContinue
    }
    
    if ($ProxyBypassCheckBox.IsChecked -eq $true -and $Script:ChildExceptionBox -eq '') {
        Set-ItemProperty -Path $AutoConfScriptregpath -Name ProxyOverride -Value '<local>'
    }
    elseif ($ProxyBypassCheckBox.IsChecked -eq $false -and $Script:ChildExceptionBox -eq '') {
        Remove-ItemProperty -Path $AutoConfScriptregpath -Name ProxyOverride -ErrorAction SilentlyContinue
    }
    elseif ($ProxyBypassCheckBox.IsChecked -eq $false -and $Script:ChildExceptionBox -ne '') {
        Set-ItemProperty -Path $AutoConfScriptregpath -Name ProxyOverride -Value $Script:ChildExceptionBox
    }
    elseif ($ProxyBypassCheckBox.IsChecked -eq $true -and $Script:ChildExceptionBox -ne '') {
        $newexeptionconf = "{0},{1}" -f $Script:ChildExceptionBox, '<local>'
        Set-ItemProperty -Path $AutoConfScriptregpath -Name ProxyOverride -Value $newexeptionconf
    }
}

$UseProxyCheckBox.Add_Click({
    if ($UseProxyCheckBox.IsChecked -eq $true) {
        Enable-ProxyConf
    }
    else {
        Disable-ProxyConf
    }
})

Function Set-NewProxyConfiguration {
    Switch ($UseProxyCheckBox.IsChecked) {
        True {
            Set-ItemProperty -Path $AutoConfScriptregpath -Name ProxyEnable -Value 1 
            $GetInternetProxyInfo = Get-ItemProperty -Path $AutoConfScriptregpath 
            if ($ProxyAddressTextBox.Text -ne '') {
                #$NewProxy = "{0}:{1}" -f $ProxyAddressTextBox.Text, $ProxyPortTextBox.Text
                Set-ItemProperty -Path $AutoConfScriptregpath -Name ProxyServer -Value $Script:Proxyunchecked
            }
        }
        False {
            Set-ItemProperty -Path $AutoConfScriptregpath -Name ProxyEnable -Value 0
        }
    }
}

$ProxyAdvancedButton.Add_Click({
    [xml]$xaml1 = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"

        Title="Proxy Settings" Height="468.25" Width="442.125">
    <Grid>
        <GroupBox Header="Servers" HorizontalAlignment="Left" Height="228" Margin="10,10,0,0" VerticalAlignment="Top" Width="408">
            <Grid HorizontalAlignment="Left" Height="205" VerticalAlignment="Top" Width="395">
                <Label Content="Type&#x9;     Proxy address to use&#x9;&#x9;             Port" HorizontalAlignment="Left" Margin="44,0,0,0" VerticalAlignment="Top" Width="341"/>
                <Label Content="HTTP:" HorizontalAlignment="Left" Margin="44,31,0,0" VerticalAlignment="Top" Width="55"/>
                <Label Content="Secure:" HorizontalAlignment="Left" Margin="44,62,0,0" VerticalAlignment="Top" Width="55"/>
                <Label Content="FTP:" HorizontalAlignment="Left" Margin="44,93,0,0" VerticalAlignment="Top" Width="46"/>
                <Label Content="Socks:" HorizontalAlignment="Left" Margin="44,124,0,0" VerticalAlignment="Top" Width="55"/>
                <CheckBox Name="SameProxyCheckBox" Content="Use the same proxy server for all protocols" HorizontalAlignment="Left" Margin="49,166,0,0" VerticalAlignment="Top" Width="257"/>
                <TextBox Name="HTTPTextBox" HorizontalAlignment="Left" Height="23" Margin="113,34,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="193"/>
                <TextBox x:Name="SecureTextBox" HorizontalAlignment="Left" Height="23" Margin="113,66,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="193" />
                <TextBox x:Name="FTPTextBox" HorizontalAlignment="Left" Height="23" Margin="113,96,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="193" />
                <TextBox x:Name="SocksTextBox" HorizontalAlignment="Left" Height="23" Margin="113,124,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="193" />
                <Label Content=":" HorizontalAlignment="Left" Margin="311,31,0,0" VerticalAlignment="Top" Width="15"/>
                <Label Content=":" HorizontalAlignment="Left" Margin="311,63,0,0" VerticalAlignment="Top" Width="15"/>
                <Label Content=":" HorizontalAlignment="Left" Margin="311,93,0,0" VerticalAlignment="Top" Width="15"/>
                <Label Content=":" HorizontalAlignment="Left" Margin="311,121,0,0" VerticalAlignment="Top" Width="15"/>
                <TextBox x:Name="HTTPPortBox" HorizontalAlignment="Left" Height="23" Margin="331,34,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="54"/>
                <TextBox x:Name="SecurePortBox" HorizontalAlignment="Left" Height="23" Margin="331,66,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="54"/>
                <TextBox x:Name="FTPPortBox" HorizontalAlignment="Left" Height="23" Margin="331,96,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="54"/>
                <TextBox x:Name="SocksPortBox" HorizontalAlignment="Left" Height="23" Margin="331,124,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="54"/>
                <Image Name="Image1" HorizontalAlignment="Left" Height="33" Margin="0,10,0,0" VerticalAlignment="Top" Width="36"/>
            </Grid>
        </GroupBox>
        <GroupBox Header="Exceptions" HorizontalAlignment="Left" Height="141" Margin="10,243,0,0" VerticalAlignment="Top" Width="406">
            <Grid HorizontalAlignment="Left" Height="117" Margin="0,0,-2,0" VerticalAlignment="Top" Width="396">
                <Label Content="Do not use proxy server for addresses beginning with:" HorizontalAlignment="Left" Margin="48,0,0,0" VerticalAlignment="Top" Width="308"/>
                <TextBox Name="ExceptionsTextBox" HorizontalAlignment="Left" Height="44" Margin="48,36,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="338" ScrollViewer.VerticalScrollBarVisibility="Visible"/>
                <Label Content="Use semicolons ( ; ) to separate entries." HorizontalAlignment="Left" Margin="48,85,0,0" VerticalAlignment="Top" Width="308"/>
                <Image Name="Image2" HorizontalAlignment="Left" Height="33" Margin="0,10,0,0" VerticalAlignment="Top" Width="36"/>
            </Grid>
        </GroupBox>
        <Button Name="SecondOKButton" Content="OK" HorizontalAlignment="Left" Margin="250,398,0,0" VerticalAlignment="Top" Width="75"/>
        <Button x:Name="SecondCancelButton" Content="Cancel" HorizontalAlignment="Left" Margin="341,398,0,0" VerticalAlignment="Top" Width="75"/>
    </Grid>
</Window>
"@

    #Read the form
    $Reader1 = (New-Object System.Xml.XmlNodeReader $xaml1) 
    $Form1 = [Windows.Markup.XamlReader]::Load($reader1) 

    #AutoFind all controls
    $xaml1.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")  | ForEach-Object { 
        New-Variable  -Name $_.Name -Value $Form1.FindName($_.Name) -Force 
    }

    $AdvancedProxySettings = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\'
    function Get-AdvancedProxySettings {
        $AdvancedProxyServer = Get-ItemProperty -Path $AdvancedProxySettings
        if ($AdvancedProxyServer.ProxyServer -match '=') {
            $SameProxyCheckBox.IsChecked = $false
            $Segragate = $AdvancedProxyServer.ProxyServer -split ';'
            $HTTPAdvancedSettings = $($Segragate -match 'http=').Split('http=')[-1] -split ':'
            $HTTPTextBox.Text = $HTTPAdvancedSettings[0]
            $HTTPPortBox.Text = $HTTPAdvancedSettings[1]
            $HTTPsAdvancedSettings = $($Segragate -match 'https=').Split('https=')[-1] -split ':'
            $SecureTextBox.Text = $HTTPsAdvancedSettings[0]
            $SecurePortBox.Text = $HTTPsAdvancedSettings[1]
            $FTPAdvancedSettings = $($Segragate -match 'ftp=').Split('ftp=')[-1] -split ':'
            $FTPTextBox.Text = $FTPAdvancedSettings[0]
            $FTPPortBox.Text = $FTPAdvancedSettings[1]
            if ($($Segragate -match 'socks=') -ne $null) {
                $SocksAdvancedSettings = $($Segragate -match 'socks=').Split('socks=')[-1] -split ':'
                $SocksTextBox.Text = $SocksAdvancedSetting[0]
                $SocksPortBox.Text = $SocksAdvancedSetting[1]
            }
        }
        else {
            $SameProxyCheckBox.IsChecked = $true
            $CommonProxyServer = $AdvancedProxyServer.ProxyServer -split ':'
            $HTTPTextBox.Text = $CommonProxyServer[0]
            $HTTPPortBox.Text = $CommonProxyServer[1]
            $SecureTextBox.Text = $CommonProxyServer[0]
            $SecurePortBox.Text = $CommonProxyServer[1]
            $FTPTextBox.Text = $CommonProxyServer[0]
            $FTPPortBox.Text = $CommonProxyServer[1]
        }
    }

    Get-AdvancedProxySettings 

    function Enable-AdvancedProxy {
        $SecureTextBox.IsEnabled = $true
        $SecurePortBox.IsEnabled = $true
        $FTPTextBox.IsEnabled = $true
        $FTPPortBox.IsEnabled = $true
        $SocksTextBox.IsEnabled = $true
        $SocksPortBox.IsEnabled = $true
    }
    function Disable-AdvancedProxy {
        $SecureTextBox.IsEnabled = $false
        $SecurePortBox.IsEnabled = $false
        $FTPTextBox.IsEnabled = $false
        $FTPPortBox.IsEnabled = $false
        $SocksTextBox.IsEnabled = $false
        $SocksPortBox.IsEnabled = $false
    }

    if ($SameProxyCheckBox.IsChecked -eq $true) {
        Disable-AdvancedProxy
    }
    else {
        Enable-AdvancedProxy
    }

    $SameProxyCheckBox.Add_Click({
        if ($SameProxyCheckBox.IsChecked -eq $true) {
            Disable-AdvancedProxy
            $ProxyAddressTextBox.IsEnabled = $false
        }
        else {
            Enable-AdvancedProxy
            $ProxyPortTextBox.IsEnabled = $true
        }
    })

    $ExceptionsProxyServer = Get-ItemProperty -Path $AdvancedProxySettings
    if ($ExceptionsProxyServer.ProxyOverride -eq '<local>') {
        $ExceptionsTextBox.Text = ''
    }
    else {
        $ExceptionsTextBox.Text = ($ExceptionsProxyServer.ProxyOverride -replace ',',';') -replace ';<local>',''
    }

    $HTTPTextBox.Add_Textchanged({
        $SecureTextBox.Text = $HTTPTextBox.Text
        $SecurePortBox.Text = $HTTPPortBox.Text
        $FTPTextBox.Text = $HTTPTextBox.Text
        $FTPPortBox.Text = $HTTPPortBox.Text
    })
    
    $HTTPPortBox.Add_Textchanged({
        $SecureTextBox.Text = $HTTPTextBox.Text
        $SecurePortBox.Text = $HTTPPortBox.Text
        $FTPTextBox.Text = $HTTPTextBox.Text
        $FTPPortBox.Text = $HTTPPortBox.Text
    })

    $SecondOKButton.Add_Click({
        if ($SameProxyCheckBox.IsChecked -eq $false) {
            $http = "http={0}:{1}" -f $HTTPTextBox.Text,$HTTPPortBox.Text
            $https = "https={0}:{1}" -f $SecureTextBox.Text,$SecurePortBox.Text
            $ftp = "ftp={0}:{1}" -f $FTPTextBox.Text,$FTPPortBox.Text
            $Script:Proxyunchecked = $http,$https,$ftp -join ';'
            if ($SocksTextBox.Text -ne '' -or $SocksPortBox.Text) {
                $socks = "socks={0}:{1}" -f $SocksTextBox.Text,$SocksPortBox.Text
                $Script:Proxyunchecked = $http,$https,$ftp,$socks -join ';'
            }
            $ProxyAddressTextBox.IsEnabled = $false
            $ProxyPortTextBox.IsEnabled = $false
            $UseProxyCheckBox.IsChecked = $true
        }
        else {
            $Script:Proxyunchecked = "{0}:{1}" -f $HTTPTextBox.Text,$HTTPPortBox.Text
            $ProxyAddressTextBox.IsEnabled = $true
            $ProxyPortTextBox.IsEnabled = $true
            $UseProxyCheckBox.IsChecked = $true
        }

        $ProxyAddressTextBox.Text = $HTTPTextBox.Text
        $ProxyPortTextBox.Text = $HTTPPortBox.Text
    
        $Script:ChildExceptionBox = $ExceptionsTextBox.Text
        $Form1.Close()
        
    })

    $SecondCancelButton.Add_Click({
        $Form1.Close()
    })

    [void]$Form1.ShowDialog() 
})

$LANButton.Add_Click({
    Set-AutoProxyGroup 
    Set-NewProxyConfiguration
    $Form.Close()
})

$CancelButton.Add_Click({
    $Form.Close()
})

$URL.Add_MouseLeftButtonUp({[system.Diagnostics.Process]::start('http://vcloud-lab.com')})
$URL.Add_MouseEnter({$URL.Foreground = 'Purple'})
$URL.Add_MouseLeave({$URL.Foreground = 'DarkBlue'})

#Mandetory last line of every script to load form
[void]$Form.ShowDialog() 
