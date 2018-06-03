#Load required libraries
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing 

[xml]$xaml = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp7"

        Title="MainWindow" Height="470" Width="800" Icon="C:\Temp\grayicon.ico">
        <Window.Resources>
            <ResourceDictionary>
                <ResourceDictionary.MergedDictionaries>
                    <ResourceDictionary Source="C:\Temp\MetroLightTheme\Metro.MSControls.Core.Implicit.xaml"/>
                    <!--
                    <ResourceDictionary Source="C:\Temp\MetroLightTheme\Styles.WPF.xaml"/>
                    <ResourceDictionary Source="C:\Temp\MetroLightTheme\Theme.Colors.xaml"/>
                    <ResourceDictionary Source="C:\Temp\MetroLightTheme\Styles.Shared.xaml"/>
                    -->
                </ResourceDictionary.MergedDictionaries>

                <Style TargetType="{x:Type Label}">
                    <Setter Property="Foreground" Value="DeepSkyBlue"/>
                    <Setter Property="FontSize" Value="16"/>
                    <Setter Property="VerticalContentAlignment" Value="Center"/>
                    <Setter Property="HorizontalContentAlignment" Value="Center"/>
                </Style>
            </ResourceDictionary>
        </Window.Resources>

    <Grid>
        <Label Content="Buttons" HorizontalAlignment="Left" Margin="10,3,0,0" VerticalAlignment="Top" Width="112"/>
        <Button Content="Button" HorizontalAlignment="Left" Margin="10,39,0,0" VerticalAlignment="Top" Width="112"/>
        <ToggleButton Content="ToggleButton" HorizontalAlignment="Left" Margin="10,74,0,0" VerticalAlignment="Top" Width="112"/>
        <RepeatButton Content="RepeatButton" HorizontalAlignment="Left" Margin="10,109,0,0" VerticalAlignment="Top" Width="112"/>

        <Label Content="CheckBoxes" HorizontalAlignment="Left" Margin="127,3,0,0" VerticalAlignment="Top" Width="112"/>
        <CheckBox Content="CheckBox1" HorizontalAlignment="Left" Margin="127,39,0,0" VerticalAlignment="Top" Height="6"/>
        <CheckBox Content="CheckBox2" HorizontalAlignment="Left" Margin="127,74,0,0" VerticalAlignment="Top" IsChecked="{x:Null}"/>
        <CheckBox Content="CheckBox3" HorizontalAlignment="Left" Margin="127,109,0,0" VerticalAlignment="Top" IsChecked="True"/>

        <Label Content="RadioButtons" HorizontalAlignment="Left" Margin="244,3,0,0" VerticalAlignment="Top" Width="112"/>
        <RadioButton Content="RadioButton1" HorizontalAlignment="Left" Margin="244,34,0,0" VerticalAlignment="Top"/>
        <RadioButton Content="RadioButton2" HorizontalAlignment="Left" Margin="244,69,0,0" VerticalAlignment="Top" IsChecked="True"/>
        <RadioButton Content="RadioButton1" HorizontalAlignment="Left" Margin="244,104,0,0" VerticalAlignment="Top"/>

        <Label Content="CheckBoxes" HorizontalAlignment="Left" Margin="450,3,0,0" VerticalAlignment="Top" Width="112"/>
        <ComboBox Name="ComboBox1" HorizontalAlignment="Left" Margin="382,39,0,0" VerticalAlignment="Top" Width="120" IsDropDownOpen="True"/>
        <ComboBox HorizontalAlignment="Left" Margin="507,39,0,0" VerticalAlignment="Top" Width="120" IsHitTestVisible="True"/>
        <ComboBox HorizontalAlignment="Left" Margin="507,74,0,0" VerticalAlignment="Top" Width="120" />
        <ComboBox HorizontalAlignment="Left" Margin="507,109,0,0" VerticalAlignment="Top" Width="120" />

        <Label Content="Image" HorizontalAlignment="Left" Margin="632,3,0,0" VerticalAlignment="Top" Width="150"/>
        <Image Name='Image1' HorizontalAlignment="Left" Height="100" Margin="632,39,0,0" VerticalAlignment="Top" Width="150"/>

        <Label Content="DataGrid" HorizontalAlignment="Left" Margin="10,144,0,0" VerticalAlignment="Top" Width="224"/>
        <DataGrid Name='DataGrid' HorizontalAlignment="Left" Height="100" Margin="10,175,0,0" VerticalAlignment="Top" Width="229"/>

        <Label Content="ListBox" HorizontalAlignment="Left" Margin="244,144,0,0" VerticalAlignment="Top" Width="112"/>
        <ListBox Name='ListBox' HorizontalAlignment="Left" Height="100" Margin="244,175,0,0" VerticalAlignment="Top" Width="112"/>

        <Label Content="TabControl" HorizontalAlignment="Left" Margin="693,144,0,0" VerticalAlignment="Top" Width="89"/>
        <TabControl HorizontalAlignment="Left" Height="100" Margin="507,175,0,0" VerticalAlignment="Top" Width="275" >
            <TabItem Header="TabItem">
                <Grid Background="#FFE5E5E5"/>
            </TabItem>
            <TabItem Header="TabItem">
                <Grid Background="#FFE5E5E5"/>
            </TabItem>
            <TabItem Header="TabItem" HorizontalAlignment="Left" Height="20" VerticalAlignment="Top" Width="55">
                <Grid Background="#FFE5E5E5"/>
            </TabItem>
        </TabControl>

        <TextBox HorizontalAlignment="Left" Height="23" Margin="361,210,0,0" TextWrapping="Wrap" Text="TextBox1" VerticalAlignment="Top" Width="141"/>
        <TextBox HorizontalAlignment="Left" Height="23" Margin="361,245,0,0" TextWrapping="Wrap" Text="TextBox2" VerticalAlignment="Top" Width="141"/>
        <Label Content="TextBox" HorizontalAlignment="Left" Margin="361,174,0,0" VerticalAlignment="Top" Width="141"/>
        <ProgressBar HorizontalAlignment="Left" Height="24" Margin="570,348,0,0" VerticalAlignment="Top" Width="212" IsIndeterminate="False"/>
        <StatusBar Name="statusBar1" Height="30" HorizontalAlignment="Stretch" VerticalAlignment="Bottom" Background="DeepSkyBlue">
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
        <Label Content="Status Bar" HorizontalAlignment="Left" Margin="570,280,0,0" VerticalAlignment="Top" Width="212"/>
        <ProgressBar HorizontalAlignment="Left" Height="27" Margin="570,316,0,0" VerticalAlignment="Top" Width="212" IsIndeterminate="False"/>
        <DatePicker HorizontalAlignment="Left" Margin="450,316,0,0" VerticalAlignment="Top" Width="115"/>
        <Label Content="Date Picker" HorizontalAlignment="Left" Margin="450,280,0,0" VerticalAlignment="Top" Width="115"/>
        <Expander Header="Expander" HorizontalAlignment="Left" Height="107" Margin="10,280,0,0" VerticalAlignment="Top" Width="139" IsExpanded="True">
            <Button Content="Button" HorizontalAlignment="Left" Margin="28,0,0,0" Width="82" Height="34"/>
        </Expander>
        <Slider HorizontalAlignment="Left" Margin="450,357,0,0" VerticalAlignment="Top" Width="112"/>
        <PasswordBox HorizontalAlignment="Left" Margin="517,210,0,0" VerticalAlignment="Top" Width="189" Password="Password"/>
        <GroupBox Header="GroupBox" HorizontalAlignment="Left" Height="112" Margin="154,275,0,0" VerticalAlignment="Top" Width="116"/>
        <ScrollBar HorizontalAlignment="Left" Margin="275,283,0,0" VerticalAlignment="Top" Height="104" Width="14"/>
        <ScrollBar HorizontalAlignment="Left" Margin="310,283,0,0" VerticalAlignment="Top" Width="135" Orientation="Horizontal" />
        <Label Content="Scroll Bar" HorizontalAlignment="Left" Margin="310,321,0,0" VerticalAlignment="Top" Width="112"/>
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

$ComboBox1.ItemsSource =  @('Item1','Item2','Item3')
$combobox1.SelectedItem = 'Item1'
$Image1.Source = 'C:\temp\Image.png'
#$DataGrid.RowBackground = 'Black'
$Datagrid.ItemsSource = Get-Service | Select-Object Name, Status, StartType -First 5
$ListBox.ItemsSource =  @('Item1','Item2','Item3')

#Mandetory last line of every script to load form
$Form.ShowDialog() | Out-Null