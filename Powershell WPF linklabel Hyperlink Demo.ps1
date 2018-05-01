#Created and designed by Kunal - http://vcloud-lab.com
#Load required libraries
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing 

[xml]$xaml = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApplication3"
        
        Title="LinkLabel Demo" Height="160" Width="329">
    <Grid>
        <Label x:Name="Link1"  HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" Width="45" FontSize='14' ToolTip='vmware'>
            <Hyperlink NavigateUri="http://www.vmware.com">Link1</Hyperlink>
        </Label>
        <Label x:Name="Link2" Content="Link2" HorizontalAlignment="Left" Margin="10,41,0,0" VerticalAlignment="Top" Width="45" FontSize='14' Foreground='DarkBlue' Cursor="Hand" ToolTip='Google'/>
        <Label x:Name="Link3" Content="Link3" HorizontalAlignment="Left" Margin="10,72,0,0" VerticalAlignment="Top" Width="45" Background='DarkGreen' Foreground='White' FontSize='14' ToolTip='vcloud-lab.com'/>

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

#Link1 - Mouse button event
$Link1.Add_PreviewMouseDown({[system.Diagnostics.Process]::start('http://www.vmware.com')})

#Link2 - My custom mouse button howver and click event
$Link2.Add_MouseLeftButtonUp({[system.Diagnostics.Process]::start('http://www.google.com')})
$Link2.Add_MouseEnter({$Link2.Foreground = 'Purple'})
$Link2.Add_MouseLeave({$Link2.Foreground = 'DarkBlue'})

#Link3 - My custom mouse button howver and click event
$Link3.Add_MouseLeftButtonUp({[system.Diagnostics.Process]::start('http://vcloud-lab.com')})
$Link3.Add_MouseEnter({$Link3.Background = 'DarkRed'; $Link3.Foreground = 'White'})
$Link3.Add_MouseLeave({$Link3.Background = 'DarkGreen'; $Link3.Foreground = 'White'})

#Mandetory last line of every script to load form
$Form.ShowDialog()