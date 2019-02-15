#http://vcloud-lab.com

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing 

[xml]$xaml = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp4"

        Title="MainWindow" Height="450" Width="800">
    <Grid>
        <GroupBox x:Name="Group1" Header="Populate your clock for Group1" HorizontalAlignment="Left" Height="140" Margin="10,10,0,0" VerticalAlignment="Top" Width="332" IsHitTestVisible="False" IsTabStop="True">
            <Grid>

                <TextBox x:Name="TextBoxHoursGroup1" HorizontalAlignment="Left" Height="68" Margin="10,10,0,0" TextWrapping="Wrap" Text="88" VerticalAlignment="Top" Width="68" FontSize="45"/>
                <Label Content=":" HorizontalAlignment="Left" Margin="83,6,0,0" VerticalAlignment="Top" FontSize="40"/>
                <TextBox x:Name="TextBoxMinutesGroup1" HorizontalAlignment="Left" Height="68" Margin="107,10,0,0" TextWrapping="Wrap" Text="88" VerticalAlignment="Top" Width="64" FontSize="45"/>
                <Label Content=":" HorizontalAlignment="Left" Margin="176,6,0,0" VerticalAlignment="Top" FontSize="40"/>
                <TextBox x:Name="TextBoxSecondsGroup1" HorizontalAlignment="Left" Height="51" Margin="200,27,0,0" TextWrapping="Wrap" Text="88" VerticalAlignment="Top" Width="50" FontSize="30"/>
                <DatePicker x:Name="DatepickerGroup1" HorizontalAlignment="Left" Margin="10,87,0,0" VerticalAlignment="Top" Width="142"/>
                <RadioButton x:Name="RadioButtonAmGroup1" Content="AM" HorizontalAlignment="Left" Margin="263,28,0,0" VerticalAlignment="Top" FontSize="18"/>
                <RadioButton x:Name="RadioButtonPmGroup1" Content="PM" HorizontalAlignment="Left" Margin="263,52,0,0" VerticalAlignment="Top" FontSize="18"/>
            </Grid>
        </GroupBox>
        <Button x:Name="ButtonStopGroup1" Content="Stop" HorizontalAlignment="Left" Margin="267,155,0,0" VerticalAlignment="Top" Width="75" Height="23"/>

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

$TimeZone = Get-TimeZone 
$Group1.Header = $TimeZone.StandardName

function AutoUpdateClock($TextBoxHours, $TextBoxMinutes, $TextBoxSeconds){
    $DateTime = Get-Date #"MM dd yyyy HH mm ss tt"
    $TextBoxHours.Text = $DateTime.Hour.ToString("00")
    $TextBoxMinutes.Text = $DateTime.Minute.ToString("00")
    $TextBoxSeconds.Text = $DateTime.Second.ToString("00")
    $AMPM = [Datetime]::Now.ToString('tt')
    switch ($AMPM) {
        'AM' {$RadioButtonAmGroup1.isChecked = $True; break}
        'PM' {$RadioButtonPmGroup1.isChecked = $True; break}
    }
    $DatepickerGroup1.SelectedDate = $DateTime
    $DatepickerGroup1.SelectedDate
    }

$Local:Group1timer = New-Object System.Windows.Forms.Timer
$Group1timer.Interval = 1
$Group1timer.Add_Tick({AutoUpdateClock -TextBoxHours $TextBoxHoursGroup1 -TextBoxMinutes $TextBoxMinutesGroup1 -TextBoxSeconds $TextBoxSecondsGroup1})
$Group1timer.Enabled = $True

$ButtonStopGroup1.Add_click({
    $Group1timer.Enabled = $false
    $Group1timer.Stop()
    $Group1timer.Dispose()
    
})

<#
#$script:seconds =([timespan]0).Add('0:2')  # 2 minutes
$script:timer = new-object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]'0:0:1.0'
$timer.Add_Tick.Invoke({UpdateClock -TextBoxHours $TextBoxHoursGroup1 -TextBoxMinutes $TextBoxMinutesGroup1 -TextBoxSeconds $TextBoxSecondsGroup1})
$timer.Start()
#>

<#
$timer = New-Object System.Timers.Timer
$counter = 0
$timer.Interval = 1000
$timer.AutoReset = $true
$wait = $true
Register-ObjectEvent -InputObject $timer -EventName Elapsed -Action { if ( $counter -eq 5 ) {$timer.Stop(); write-host "counter stopped"; $global:wait=$false } else {$counter = $counter +1; write-host "counter is: " $counter; }}
$timer.Start()

while ($wait) { "sleeping..."; Start-Sleep -Milliseconds 500 }
$timer.Close()
"exiting..."
#>

$Form.ShowDialog()
