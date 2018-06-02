#Load required libraries
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing 

$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$AssemblyLocation = Join-Path -Path $ScriptPath -ChildPath Themes
foreach ($Assembly in (Dir $AssemblyLocation -Filter *.dll)) {
    [System.Reflection.Assembly]::LoadFrom($Assembly.fullName) | out-null
}
#$Icon = Join-Path -Path $ScriptPath -ChildPath Themes\Icons\GrayIcon.ico

[xml]$xaml = @"
<modern:ModernWindow 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp3"
        xmlns:modern="clr-namespace:ModernChrome;assembly=ModernChrome"
        
        Title="ModernChrome Theme" Height="370" Width="800">
    <Window.Resources>
        <ResourceDictionary>
            <ResourceDictionary.MergedDictionaries>
                <!-- Themes Available: Blend, Dark, DarkBlue, Generic, Light, LightBlue, Themes -->
                <ResourceDictionary Source="pack://application:,,,/ModernChrome;component/Themes/Dark.xaml" />
            </ResourceDictionary.MergedDictionaries>
        </ResourceDictionary>
    </Window.Resources>

   
    <modern:ModernWindow.StatusBar>
        <TextBlock Name="StatusBar" VerticalAlignment="Center">http://vcloud-lab.com</TextBlock>
    </modern:ModernWindow.StatusBar>

    <Grid>
        <Button Name="Button" Content="Button" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" Width="102"/>
        <ToggleButton Name="ToggleButton" Content="Toggle Button" HorizontalAlignment="Left" Margin="10,35,0,0" VerticalAlignment="Top" Width="102" />
        <RepeatButton Name="RepeatButton" Content="Repeat Button" HorizontalAlignment="Left" Margin="10,60,0,0" VerticalAlignment="Top" Width="102"/>
        <!--
        <CalendarButton Name="CalendarButton" Content="Calendar Button" HorizontalAlignment="Left" Margin="10,85,0,0" VerticalAlignment="Top" Width="102"/>
        -->
        <Label Name="Label1" Content="Label 1" HorizontalAlignment="Left" Margin="117,7,0,0" VerticalAlignment="Top" Width="76"/>
        <Label Name="Label2" Content="Label 2" HorizontalAlignment="Left" Margin="117,33,0,0" VerticalAlignment="Top" Width="76"/>
        <TextBlock Name="TextBlock" HorizontalAlignment="Left" Margin="117,62,0,0" TextWrapping="Wrap" Text="TextBlock" VerticalAlignment="Top" Width="76"/>
        <RadioButton Name="RadioButton1" Content="RadioButton" HorizontalAlignment="Left" Margin="198,13,0,0" VerticalAlignment="Top"/>
        <RadioButton Name="RadioButton2" Content="RadioButton" HorizontalAlignment="Left" Margin="198,38,0,0" VerticalAlignment="Top"/>
        <TextBox Name="TextBox" HorizontalAlignment="Left" Height="23" Margin="117,85,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="76"/>
        <Calendar Name="Calendar" HorizontalAlignment="Left" Margin="10,132,0,0" VerticalAlignment="Top"/>
        <ComboBox Name="ComboBox1" HorizontalAlignment="Left" Margin="198,60,0,0" VerticalAlignment="Top" Width="120"/>
        <ComboBox Name="ComboBox2" HorizontalAlignment="Left" Margin="198,86,0,0" VerticalAlignment="Top" Width="120"/>
        <CheckBox Name="CheckBox1" Content="CheckBox" HorizontalAlignment="Left" Margin="117,113,0,0" VerticalAlignment="Top"/>
        <CheckBox Name="CheckBox2" Content="CheckBox" HorizontalAlignment="Left" Margin="193,113,0,0" VerticalAlignment="Top"/>
        <Expander Name="Expander" Header="Expander" HorizontalAlignment="Left" Height="100" Margin="323,7,0,0" VerticalAlignment="Top" Width="100">
            <Grid Background="#FFE5E5E5"/>
        </Expander>
        <GroupBox Name="GroupBox" Header="GroupBox" HorizontalAlignment="Left" Height="167" Margin="194,133,0,0" VerticalAlignment="Top" Width="124"/>
        <ProgressBar Name="ProgressBar1" HorizontalAlignment="Left" Height="10" Margin="428,264,0,0" VerticalAlignment="Top" Width="354"/>
        <ProgressBar Name="ProgressBar2" HorizontalAlignment="Left" Height="21" Margin="428,279,0,0" VerticalAlignment="Top" Width="354"/>
        <RichTextBox Name="RichTextBox" HorizontalAlignment="Left" Height="100" Margin="323,159,0,0" VerticalAlignment="Top" Width="100">
            <FlowDocument>
                <Paragraph>
                    <Run Text="RichTextBox"/>
                </Paragraph>
            </FlowDocument>
        </RichTextBox>
        <Slider Name="Slider" HorizontalAlignment="Left" Margin="323,264,0,0" VerticalAlignment="Top" Width="100"/>
        <ScrollBar Name="ScrollBar1" HorizontalAlignment="Left" Margin="428,10,0,0" VerticalAlignment="Top" Height="98"/>
        <ScrollBar Name="ScrollBar2" HorizontalAlignment="Left" Margin="450,10,0,0" VerticalAlignment="Top" Orientation="Horizontal" Width="109"/>
        <DataGrid Name="DataGrid" HorizontalAlignment="Left" Height="146" Margin="428,113,0,0" VerticalAlignment="Top" Width="131"/>
        <TabControl Name="TabControl" HorizontalAlignment="Left" Height="248" Margin="564,11,0,0" VerticalAlignment="Top" Width="218">
            <TabItem Header="TabItem">
                <Grid Background="#FFE5E5E5"/>
            </TabItem>
            <TabItem Header="TabItem">
                <Grid Background="#FFE5E5E5"/>
            </TabItem>
        </TabControl>
        <DatePicker Name="DatePicker" HorizontalAlignment="Left" Margin="323,116,0,0" VerticalAlignment="Top" Width="105"/>
    </Grid>
</modern:ModernWindow>
"@

#Read the form
$Reader = (New-Object System.Xml.XmlNodeReader $xaml) 
$Form = [Windows.Markup.XamlReader]::Load($reader) 

#AutoFind all controls
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")  | ForEach-Object { 
  New-Variable  -Name $_.Name -Value $Form.FindName($_.Name) -Force 
}

$Form.Content.Children | Where-Object {$_.Name -match "Check|radio|Label|Group|Expander|TextBlock"} | foreach {$_.ForeGround = 'Gray'}


#$StatusBar.Text = 'http://vcloud-lab.com'

#Mandetory last line of every script to load form
$Form.ShowDialog()
