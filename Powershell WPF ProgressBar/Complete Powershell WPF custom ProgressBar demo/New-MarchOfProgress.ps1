Add-Type –assemblyName PresentationFramework
 
$Runspace = [runspacefactory]::CreateRunspace()
$Runspace.ApartmentState = "STA"
$Runspace.ThreadOptions = "ReuseThread"
$Runspace.Open()
 
$code = {
 
#Build the GUI
[xml]$xaml = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp6"
        Title="MainWindow" Height="261.787" Width="779.468" Topmost="True">
    <Grid>
        <ProgressBar Name="ProgressBar" HorizontalAlignment="Left" Height="121" VerticalAlignment="Top" Width="497" Margin="115,29,0,0" Background="{x:Null}">
            <ProgressBar.OpacityMask>
                <ImageBrush ImageSource="C:\Temp\Images\MarchOfProgress.png"/>
            </ProgressBar.OpacityMask>
        </ProgressBar>
        <TextBlock Name="TextBlock" HorizontalAlignment="Left" Margin="330,155,0,0" TextWrapping="Wrap" VerticalAlignment="Top"/>
        <Button Name="Button" Content="Button" HorizontalAlignment="Left" Margin="686,201,0,0" VerticalAlignment="Top" Width="75"/>
    </Grid>
</Window>
"@
 
$syncHash = [hashtable]::Synchronized(@{})
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
$syncHash.Window=[Windows.Markup.XamlReader]::Load( $reader )
 
function Update-Progress {
param($syncHash,$ComputerName,$TargetBox)
$syncHash.Host = $host
$Runspace = [runspacefactory]::CreateRunspace()
$Runspace.ApartmentState = "STA"
$Runspace.ThreadOptions = "ReuseThread"
$Runspace.Open()
$Runspace.SessionStateProxy.SetVariable("syncHash",$syncHash) 

$Runspace.SessionStateProxy.SetVariable("ComputerName",$ComputerName)
$Runspace.SessionStateProxy.SetVariable("TargetBox",$TargetBox)
 
$code = {
    for ($i=0; $i -lt 100; $i++) {
        $syncHash.Window.Dispatcher.invoke(
            [action]{ $syncHash.ProgressBar.Value = $i }
        )
        Start-Sleep -Milliseconds 100
        #Update-Window TextBox Text $i
    }    
}
$PSinstance = [powershell]::Create().AddScript($Code)
$PSinstance.Runspace = $Runspace
$job = $PSinstance.BeginInvoke()
}
 
function NullCount {
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
[Microsoft.VisualBasic.Interaction]::MsgBox("Please select a ping count first",'OKOnly,Information',"Ping")
}
 
# XAML objects
# ComputerNames
$syncHash.ProgressBar = $syncHash.Window.FindName("ProgressBar")
$syncHash.Button = $syncHash.Window.FindName("Button")
 
# Click Actions
$syncHash.Button.Add_Click({
        Update-Progress -syncHash $syncHash
    })
 
$syncHash.Window.ShowDialog()
$Runspace.Close()
$Runspace.Dispose()
 
}
 
$PSinstance1 = [powershell]::Create().AddScript($Code)
$PSinstance1.Runspace = $Runspace
$job = $PSinstance1.BeginInvoke()