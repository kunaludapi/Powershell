##########################################
# Created by http://vcloud-lab.com
# Created using chart.js html
# Tested on Windows 10
##########################################
#Load required libraries
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing 
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
#$AssemblyLocation = Join-Path -Path $ScriptPath -ChildPath Charts

$Global:AllChartsPath = $ScriptPath
[xml]$xaml = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp2"

        Title="ChartDemo" Height="300" Width="300">
    <Grid>
        <Image Name='CornerImaage' HorizontalAlignment="Left" Height="228" VerticalAlignment="Top" Width="256"/>
        <WebBrowser Name='WebBrowser1' HorizontalAlignment="Left" Height="250" Margin="602,49,0,0" VerticalAlignment="Top" Width="396"/>
        <TextBox Name='ComputerName' HorizontalAlignment="Left" Margin="10,23,0,0" TextWrapping="Wrap" Text="$env:COMPUTERNAME" VerticalAlignment="Top" Height="20" Width="167"/>
        <Button Name='Button' Content="Get-Details" HorizontalAlignment="Left" Margin="182,23,0,0" VerticalAlignment="Top" Width="76"/>
        <Label Content="Services by status" HorizontalAlignment="Left" Margin="602,10,0,0" VerticalAlignment="Top" Width="396" HorizontalContentAlignment="Center" FontSize="18" Foreground="DeepSkyBlue"/>
        <Label Content="Top 5 processes by Count" HorizontalAlignment="Left" Margin="602,311,0,0" VerticalAlignment="Top" Width="396" HorizontalContentAlignment="Center" FontSize="18" Foreground="DeepSkyBlue"/>
        <WebBrowser x:Name='WebBrowser2' HorizontalAlignment="Left" Height="270" Margin="602,356,0,0" VerticalAlignment="Top" Width="396"/>
        <Label Content="Top 5 Processes consuming CPU" HorizontalAlignment="Left" Margin="193,311,0,0" VerticalAlignment="Top" Width="396" HorizontalContentAlignment="Center" FontSize="18" Foreground="DeepSkyBlue"/>
        <WebBrowser x:Name='WebBrowser3' HorizontalAlignment="Left" Height="250" Margin="193,356,0,0" VerticalAlignment="Top" Width="396"/> 
        <Ellipse Name='Ellipse1' HorizontalAlignment="Left" Height="111" Margin="473,44,0,0" VerticalAlignment="Top" Width="116" Fill="DeepSkyBlue"/>
        <Ellipse Name='Ellipse2' HorizontalAlignment="Left" Height="111" Margin="473,195,0,0" VerticalAlignment="Top" Width="116" Fill="DeepSkyBlue"/>
        <Ellipse Name='Ellipse3' HorizontalAlignment="Left" Height="111" Margin="323,44,0,0" VerticalAlignment="Top" Width="116" Fill="DeepSkyBlue"/>
        <Ellipse Name='Ellipse4' HorizontalAlignment="Left" Height="111" Margin="323,195,0,0" VerticalAlignment="Top" Width="116" Fill="DeepSkyBlue"/>        
        <Label Content="Memory" HorizontalAlignment="Left" Margin="323,8,0,0" VerticalAlignment="Top" Width="116" HorizontalContentAlignment="Center" FontSize="16" Foreground="DeepSkyBlue"/>
        <Label Content="All Cores" HorizontalAlignment="Left" Margin="473,8,0,0" VerticalAlignment="Top" Width="116" HorizontalContentAlignment="Center" FontSize="16" Foreground="DeepSkyBlue"/>
        <Label Content="Total Disk Size" HorizontalAlignment="Left" Margin="323,160,0,0" VerticalAlignment="Top" Width="116" HorizontalContentAlignment="Center" FontSize="16" Foreground="DeepSkyBlue"/>
        <Label Content="Total Nics" HorizontalAlignment="Left" Margin="473,160,0,0" VerticalAlignment="Top" Width="116" HorizontalContentAlignment="Center" FontSize="16" Foreground="DeepSkyBlue"/>
        <Label Name='Label1' HorizontalAlignment="Left" Margin="323,70,0,0" VerticalAlignment="Top" Width="116" HorizontalContentAlignment="Center" FontSize="32" Foreground="White"/>
        <Label Name='Label2' HorizontalAlignment="Left" Margin="473,70,0,0" VerticalAlignment="Top" Width="116" HorizontalContentAlignment="Center" FontSize="32" Foreground="White"/>
        <Label Name='Label3' HorizontalAlignment="Left" Margin="323,224,0,0" VerticalAlignment="Top" Width="116" HorizontalContentAlignment="Center" FontSize="32" Foreground="White"/>
        <Label Name='Label4' HorizontalAlignment="Left" Margin="473,224,0,0" VerticalAlignment="Top" Width="116" HorizontalContentAlignment="Center" FontSize="32" Foreground="White"/>
    </Grid>
</Window>
"@

#Read the form
$Reader = (New-Object System.Xml.XmlNodeReader $xaml) 
$Form = [Windows.Markup.XamlReader]::Load($reader) 

#AutoFind all controls
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")  | ForEach-Object { 
    New-Variable -Name $_.Name -Value $Form.FindName($_.Name) -Force 
}

$CornerImaage.Source = "$ScriptPath\PsScripts\corner.png"

$HtmlCharts = "$ScriptPath\htmlCharts"
$Button.Add_Click({
    $Label1.Content = "$((Get-WmiObject Win32_PhysicalMemory -ComputerName $ComputerName.Text | Select-Object -ExpandProperty Capacity | Measure-Object -Sum).Sum / 1GB)" + " GB"
    $Label2.Content = $(Get-WmiObject Win32_Processor -ComputerName $ComputerName.Text).NumberOfLogicalProcessors
    $Label3.Content = "$([System.Math]::Round((get-wmiobject Win32_DiskDrive -ComputerName $ComputerName.Text).size / 1gb))" + " GB"
    $Label4.Content = (Get-WmiObject win32_NetworkAdapter -ComputerName $ComputerName.Text | Where-Object {$_.PhysicalAdapter}).Count

    $AllProcesses = Get-Process -ComputerName $ComputerName.Text
    $ProcessByCpu = $AllProcesses | Group-object -Property Name
    $Top5ProcessesByCPU = $ProcessByCpu | Select-Object Name, @{N='CpuUsage';E={$_.Group.cpu | Measure-Object -Sum | Select-Object -ExpandProperty Sum}} | Sort-Object -Property CpuUsage -Descending | Select-Object -First 5
    $TopCpuNames = ($Top5ProcessesByCPU.Name | ForEach-Object {"'{0}'" -f $_}) -join ', '
    $TopCpuUsage = ($Top5ProcessesByCPU | Select-Object -ExpandProperty CpuUsage) -join ', '
    & "$ScriptPath\Psscripts\New-LineChart.ps1" -TopCpuNames $TopCpuNames -TopCpuUsage $TopCpuUsage -LegendLabel CpuUsage
    $WebBrowser3.Navigate("file:///$HtmlCharts\Line.html")

    $Form.Height="620" 
    $Form.Width="1016"

    $ProcessByCount = $AllProcesses| Group-Object -Property Name | Sort-Object -Property Count -Descending | Select-Object -First 5
    $Top5ProcName = ($ProcessByCount.Name | ForEach-Object {"'{0}'" -f $_}) -join ', '
    $Top5ProcCount = ($ProcessByCount | Select-Object -ExpandProperty Count) -join ', '
    & "$ScriptPath\Psscripts\New-BarChart.ps1" -Top5ProcName $Top5ProcName -Top5ProcCount $Top5ProcCount -LegendLabel Count
    $WebBrowser2.Navigate("file:///$HtmlCharts\Bar.html")

    $AllServices = Get-Service -ComputerName $ComputerName.Text
    $ServicesByCount = $AllServices | Group-Object -Property Status
    $ServicesNames = ($ServicesByCount.Name | ForEach-Object {"'{0}'" -f $_}) -join ', '
    $ServicesStatusCount = ($ServicesByCount | Select-Object -ExpandProperty Count) -join ', '
    & "$ScriptPath\Psscripts\New-DoughnutChart.ps1" -ServicesNames $ServicesNames -ServicesCount $ServicesStatusCount -LegendLabel Status
    $WebBrowser1.Navigate("file:///$HtmlCharts\Doughnut.html")

})

#Mandetory last line of every script to load form
[void]$Form.ShowDialog() 
