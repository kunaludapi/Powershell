#Load required libraries
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing 

[xml]$xaml = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApplication2"

        Title="MainWindow" Height="300" Width="364">
    <Grid>
        <TextBox x:Name="textBox" HorizontalAlignment="Left" Height="23" Margin="10,41,0,0" TextWrapping="Wrap" Text='$env:ComputerName' VerticalAlignment="Top" Width="225"/>
        <Label x:Name="label" Content="ComputerName or IP" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" Width="175"/>
        <Button x:Name="button" Content="Get-DiskInfo" HorizontalAlignment="Left" Margin="240,41,0,0" VerticalAlignment="Top" Width="105" Height="24"/>
        <DataGrid x:Name="dataGrid" HorizontalAlignment="Left" Margin="10,69,0,0" VerticalAlignment="Top" Width="335" Height="141"/>
        <Label x:Name="label1" Content="http://vcloud-lab.com" HorizontalAlignment="Left" Margin="221,215,0,0" VerticalAlignment="Top" Width="125" Foreground="#FF0000EE"/>
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

$textBox.Add_GotFocus({
    if ($textBox.Text -eq '' -or $textBox.Text -match  '\s+') {
        $textBox.Foreground = 'Black'
        $textBox.Text = ''
    }
})
$textBox.Add_LostFocus({
    if ($textBox.Text -eq '' -or $textBox.Text -match '\s+') {
        $textBox.Foreground = 'Black'
        $textBox.Text = 'Type valid computername'
        $textBox.Foreground = 'Darkgray'
    }
})

function Get-DiskInfo {
    if ($textBox.Text -eq '') {
        $textBox.Text = "Type valid computername"
        $dataGrid.ItemsSource = $null
    }
    else {
        try {
            $DiskInfo = Get-CimInstance -ClassName Win32_Logicaldisk -ComputerName $textBox.Text -ErrorAction Stop | Select-Object DeviceID, DriveType, @{N='FreeGB'; E={[Math]::round($_.FreeSpace/1GB)}}, @{N='TotalGB'; E={[Math]::round($_.Size/1GB)}}
        }
        catch {
            $dataGrid.ItemsSource = $null
            $textBox.Text = "Can't Connect server"
            $textBox.Foreground = 'Red'
        }
    }
    $DiskList = New-Object System.Collections.ArrayList
    if ($DiskInfo -ne $null) {
        $DiskList.AddRange($DiskInfo)
        $dataGrid.ItemsSource = $DiskList
    }
}

#What happens when button is clicked
$button.Add_Click({Get-DiskInfo})

#Link Label
$label1.Add_MouseLeftButtonUp({[system.Diagnostics.Process]::start('http://vcloud-lab.com')})
$label1.Add_MouseEnter({
    $label1.Foreground = 'Purple'
})
$label1.Add_MouseLeave({
    $label1.Foreground = 'Blue'
})

#Mandetory last line of every script to load form
$Form.ShowDialog()