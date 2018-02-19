#Load Assembly and Library
Add-Type -AssemblyName PresentationFramework

#Check server is reachable and get winevent
function Get-RestartEventLogs {
    param (
        $ComputerName = $ComputerNameBox.Text
    )
    if (Test-Connection $ComputerName -Quiet -Count 2) {
        try {
            Get-EventLog -LogName System -Source user32 -ComputerName $ComputerName -Newest 10 | Select-Object UserName, TimeWritten, MachineName
        }
        catch {
            [System.Windows.MessageBox]::Show("Cannot retrive event logs from server $ComputerName.", "Server unreachable")
        }
    }
    else {
        [System.Windows.MessageBox]::Show("Provided Server is not reachable.", "Server unreachable")
    }
}

#XAML form designed using Vistual Studio
[xml]$Form = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="RestartLogs" Height="375" Width="344" ResizeMode="NoResize">
    <Grid>
        <Label Name="ComputerLabel" Content="Computer or IP" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" Height="30" Width="110"/>
        <Button Name="RestartLogsButton" Content="Get-Restartlogs" HorizontalAlignment="Left" Margin="200,43,0,0" VerticalAlignment="Top" Width="126" RenderTransformOrigin="2,1.227"/>
        <TextBox Name="ComputerNameBox" HorizontalAlignment="Left" Height="28" Margin="125,10,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="201" ToolTip="Type valid Computer name or IP address" AutomationProperties.HelpText="Type valid Computer name or IP address" Text="127.0.0.1"/>
        <DataGrid Name="ResultDataGrid" HorizontalAlignment="Left" Margin="10,70,0,0" VerticalAlignment="Top" Height="257" Width="316"/>
        <TextBlock Name="Url" HorizontalAlignment="Left" Margin="206,331,0,0" TextWrapping="Wrap" Text="http://vcloud-lab.com" VerticalAlignment="Top" Width="120"/>
    </Grid>
</Window>
"@

#Create a form
$XMLReader = (New-Object System.Xml.XmlNodeReader $Form)
$XMLForm = [Windows.Markup.XamlReader]::Load($XMLReader)

#Load Controls
$ComputerNameBox = $XMLForm.FindName('ComputerNameBox')
$RestartLogsButton = $XMLForm.FindName('RestartLogsButton')
$ResultDataGrid = $XMLForm.FindName('ResultDataGrid')

#Create array object for Result DataGrid
$RestartEventList = New-Object System.Collections.ArrayList

#Button Action
$RestartLogsButton.add_click({
    #Computer name shouldn't be null
    if ($ComputerNameBox.Text -eq '') {
        [System.Windows.MessageBox]::Show("Please enter a valid Computername or IP before clicking Get-RestartLogs button.", "Textbox empty")
    }

    #Check server is reachable and get winevent
    $Events = Get-RestartEventLogs -ComputerName $ComputerNameBox.Text
    
    #Build Datagrid
    $RestartEventList.AddRange($Events)
    $ResultDataGrid.ItemsSource=@($RestartEventList)
})

#Show XMLform
$XMLForm.ShowDialog()