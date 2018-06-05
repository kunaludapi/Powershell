#Load required libraries
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing 

$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$AssemblyLocation = Join-Path -Path $ScriptPath -ChildPath .\themes
foreach ($Assembly in (Dir $AssemblyLocation -Filter *.dll)) {
    [System.Reflection.Assembly]::LoadFrom($Assembly.fullName) | out-null
}

[xml]$xaml = @"
<Controls:MetroWindow 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:Controls="clr-namespace:MahApps.Metro.Controls;assembly=MahApps.Metro"
        Title="MainWindow" Height="450" Width="800">

        <Window.Resources>
            <ResourceDictionary>
                <ResourceDictionary.MergedDictionaries>
                <!-- MahApps.Metro resource dictionaries. Make sure that all file names are Case Sensitive! -->
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Controls.xaml" />
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Fonts.xaml" />
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Colors.xaml" />
                <!-- Accent and AppTheme setting -->
                <!--“Red”, “Green”, “Blue”, “Purple”, “Orange”, “Lime”, “Emerald”, “Teal”, “Cyan”, “Cobalt”, “Indigo”, “Violet”, “Pink”, “Magenta”, “Crimson”, “Amber”, “Yellow”, “Brown”, “Olive”, “Steel”, “Mauve”, “Taupe”, “Sienna” -->
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/Yellow.xaml" />
                <!-- “BaseLight”, “BaseDark” -->
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/BaseDark.xaml" />
                </ResourceDictionary.MergedDictionaries>
            </ResourceDictionary>
        </Window.Resources>

        <Grid>
        <Label Content="Buttons" HorizontalAlignment="Left" Margin="10,3,0,0" VerticalAlignment="Top" Width="112"/>
        <Button Content="Button" HorizontalAlignment="Left" Margin="10,29,0,0" VerticalAlignment="Top" Width="112"/>
        <ToggleButton Content="ToggleButton" HorizontalAlignment="Left" Margin="10,58,0,0" VerticalAlignment="Top" Width="112" IsChecked="True"/>
        <RepeatButton Content="RepeatButton" HorizontalAlignment="Left" Margin="10,85,0,0" VerticalAlignment="Top" Width="112"/>

        <Label Content="CheckBoxes" HorizontalAlignment="Left" Margin="127,3,0,0" VerticalAlignment="Top" Width="112"/>
        <CheckBox Content="CheckBox1" HorizontalAlignment="Left" Margin="127,32,0,0" VerticalAlignment="Top" Height="20"/>
        <CheckBox Content="CheckBox2" HorizontalAlignment="Left" Margin="127,60,0,0" VerticalAlignment="Top" IsChecked="{x:Null}"/>
        <CheckBox Content="CheckBox3" HorizontalAlignment="Left" Margin="127,87,0,0" VerticalAlignment="Top" IsChecked="True"/>

        <Label Content="RadioButtons" HorizontalAlignment="Left" Margin="244,3,0,0" VerticalAlignment="Top" Width="112"/>
        <RadioButton Content="RadioButton1" HorizontalAlignment="Left" Margin="244,32,0,0" VerticalAlignment="Top"/>
        <RadioButton Content="RadioButton2" HorizontalAlignment="Left" Margin="244,61,0,0" VerticalAlignment="Top" IsChecked="True"/>
        <RadioButton Content="RadioButton1" HorizontalAlignment="Left" Margin="244,87,0,0" VerticalAlignment="Top"/>

        <Label Content="CheckBoxes" HorizontalAlignment="Left" Margin="450,3,0,0" VerticalAlignment="Top" Width="112"/>
        <ComboBox Name="combobox1" HorizontalAlignment="Left" Margin="382,29,0,0" VerticalAlignment="Top" Width="120" IsDropDownOpen="True"/>
        <ComboBox HorizontalAlignment="Left" Margin="507,29,0,0" VerticalAlignment="Top" Width="120" IsHitTestVisible="True"/>
        <ComboBox HorizontalAlignment="Left" Margin="507,56,0,0" VerticalAlignment="Top" Width="120" />
        <ComboBox HorizontalAlignment="Left" Margin="507,81,0,0" VerticalAlignment="Top" Width="120" />

        <Label Content="Image" HorizontalAlignment="Left" Margin="632,3,0,0" VerticalAlignment="Top" Width="134"/>
        <Image Name="Image1" HorizontalAlignment="Left" Height="100" Margin="632,29,0,0" VerticalAlignment="Top" Width="134"/>

        <Label Content="DataGrid" HorizontalAlignment="Left" Margin="10,112,0,0" VerticalAlignment="Top" Width="224"/>
        <DataGrid Name="Datagrid" HorizontalAlignment="Left" Height="100" Margin="10,143,0,0" VerticalAlignment="Top" Width="229"/>

        <Label Content="ListBox" HorizontalAlignment="Left" Margin="244,112,0,0" VerticalAlignment="Top" Width="112"/>
        <ListBox Name='ListBox' HorizontalAlignment="Left" Height="100" Margin="244,144,0,0" VerticalAlignment="Top" Width="112"/>

        <Label Content="TabControl" HorizontalAlignment="Left" Margin="693,134,0,0" VerticalAlignment="Top" Width="89"/>
        <TabControl HorizontalAlignment="Left" Height="100" Margin="507,165,0,0" VerticalAlignment="Top" Width="275">
            <TabItem Header="TabItem">
                <Grid>
                    <PasswordBox HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" Width="149" Grid.ColumnSpan="2"/>
                </Grid>
            </TabItem>
            <TabItem Header="TabItem">
                <Grid></Grid>
            </TabItem>
        </TabControl>


        <TextBox HorizontalAlignment="Left" Height="23" Margin="361,183,0,0" TextWrapping="Wrap" Text="TextBox1" VerticalAlignment="Top" Width="141"/>
        <TextBox HorizontalAlignment="Left" Height="23" Margin="361,211,0,0" TextWrapping="Wrap" Text="TextBox2" VerticalAlignment="Top" Width="141"/>
        <Label Content="TextBox" HorizontalAlignment="Left" Margin="361,152,0,0" VerticalAlignment="Top" Width="141"/>
        <ProgressBar HorizontalAlignment="Left" Height="16" Margin="570,324,0,0" VerticalAlignment="Top" Width="212" Value="70"/>
        <StatusBar Name="statusBar1" Height="30" HorizontalAlignment="Stretch" VerticalAlignment="Bottom">
            <StatusBarItem Content="Item 1" Width="75"/>
            <StatusBarItem Content="Item 2" Width="112" />
            <StatusBarItem HorizontalAlignment="Right">
                <StackPanel Orientation="Horizontal">
                    <StatusBarItem  Content="Item 3" Width="92"/>
                    <StatusBarItem Content="Item 4" Width="114"/>
                    <ProgressBar Height="14" Width="210" IsIndeterminate="True" Margin="5,0"/>
                </StackPanel>
            </StatusBarItem>
        </StatusBar>
        <Label Content="Status Bar" HorizontalAlignment="Left" Margin="570,270,0,0" VerticalAlignment="Top" Width="212"/>
        <ProgressBar HorizontalAlignment="Left" Height="18" Margin="570,301,0,0" VerticalAlignment="Top" Width="212" IsIndeterminate="true"/>
        <DatePicker HorizontalAlignment="Left" Margin="450,296,0,0" VerticalAlignment="Top" Width="115"/>
        <Label Content="Date Picker" HorizontalAlignment="Left" Margin="447,270,0,0" VerticalAlignment="Top" Width="115"/>
        <Expander Header="Expander" HorizontalAlignment="Left" Height="107" Margin="10,248,0,0" VerticalAlignment="Top" Width="139" IsExpanded="True">
            <Button Content="Button" HorizontalAlignment="Left" Margin="28,0,0,0" Width="82" Height="34"/>
        </Expander>
        <Slider HorizontalAlignment="Left" Margin="447,332,0,0" VerticalAlignment="Top" Width="112"/>
        <GroupBox Header="GroupBox" HorizontalAlignment="Left" Height="112" Margin="154,249,0,0" VerticalAlignment="Top" Width="116"/>
        <ScrollBar HorizontalAlignment="Left" Margin="275,257,0,0" VerticalAlignment="Top" Height="104" Width="14"/>
        <ScrollBar HorizontalAlignment="Left" Margin="295,257,0,0" VerticalAlignment="Top" Width="135" Orientation="Horizontal" />
        <Label Content="Scroll Bar" HorizontalAlignment="Left" Margin="295,280,0,0" VerticalAlignment="Top" Width="112"/>
    </Grid>
</Controls:MetroWindow>
"@

#Read the form
$Reader = (New-Object System.Xml.XmlNodeReader $xaml) 
$Form = [Windows.Markup.XamlReader]::Load($reader) 

#AutoFind all controls
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")  | ForEach-Object { 
  New-Variable  -Name $_.Name -Value $Form.FindName($_.Name) -Force 
}

$ComboBox1.ItemsSource =  @('Item1','Item2','Item3')
$combobox1.SelectedItem = 'Item1'
$Image1.Source = 'C:\Temp\MetroDarkTheme\Image.png'
#$DataGrid.RowBackground = 'Black'
$Datagrid.ItemsSource = Get-Service | Select-Object Name, Status, StartType -First 5
$ListBox.ItemsSource =  @('Item1','Item2','Item3')
$combobox1.SelectedItem = 'Item1'

#Mandetory last line of every script to load form
[void]$Form.ShowDialog()
