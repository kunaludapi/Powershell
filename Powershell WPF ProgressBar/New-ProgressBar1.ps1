Begin { 

# Function to facilitate updates to controls within the window 
Function Update-Window { 
    Param ( 
        $Control, 
        $Property, 
        $Value, 
        [switch]$AppendContent 
    ) 
 
   # This is kind of a hack, there may be a better way to do this 
   If ($Property -eq "Close") { 
      $syncHash.Window.Dispatcher.invoke([action]{$syncHash.Window.Close()},"Normal") 
      Return 
   } 

   # This updates the control based on the parameters passed to the function 
   $syncHash.$Control.Dispatcher.Invoke([action]{ 
      # This bit is only really meaningful for the TextBox control, which might be useful for logging progress steps 
       If ($PSBoundParameters['AppendContent']) { 
           $syncHash.$Control.AppendText($Value) 
       } Else { 
           $syncHash.$Control.$Property = $Value 
       } 
   }, "Normal") 

} 


#Load required libraries
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing 

$syncHash = [hashtable]::Synchronized(@{}) 
$newRunspace =[runspacefactory]::CreateRunspace() 
$newRunspace.ApartmentState = "STA" 
$newRunspace.ThreadOptions = "ReuseThread"           
$newRunspace.Open() 
$newRunspace.SessionStateProxy.SetVariable("syncHash",$syncHash)           
$psCmd = [PowerShell]::Create().AddScript({ 
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
                <ImageBrush ImageSource="c:\temp\completed.png"/>
            </ProgressBar.OpacityMask>
        </ProgressBar>
        <TextBlock Name="TextBlock" HorizontalAlignment="Left" Margin="330,155,0,0" TextWrapping="Wrap" VerticalAlignment="Top"/>
        <Button Name="Button" Content="Button" HorizontalAlignment="Left" Margin="686,201,0,0" VerticalAlignment="Top" Width="75"/>
    </Grid>
</Window>
"@ 

    $reader=(New-Object System.Xml.XmlNodeReader $xaml) 
    $syncHash.Window=[Windows.Markup.XamlReader]::Load( $reader ) 
    $syncHash.ProgressBar = $syncHash.Window.FindName("ProgressBar") 
    $syncHash.TextBlock = $syncHash.Window.FindName("TextBlock") 
    $syncHash.Button = $syncHash.Window.FindName("Button") 
    $syncHash.Window.ShowDialog() | Out-Null 
    $syncHash.Error = $Error 
})

$psCmd.Runspace = $newRunspace 
$data = $psCmd.BeginInvoke() 
While (!($syncHash.Window.IsInitialized)) { 
   Start-Sleep -S 1 
} 
} # End Begin Block 


Process { 
 
# Any long running process can be implemented here, this is just an example 
#$syncHash.Button.Add_Click({
    for ($i=0; $i -lt 100; $i++) {

        Update-Window ProgressBar Value $i
        Start-Sleep -Milliseconds 100
        Update-Window TextBox Text $i
    }    
#})
# This closes the progress bar 
Update-Window Window Close 
 
}  # End Process Block 