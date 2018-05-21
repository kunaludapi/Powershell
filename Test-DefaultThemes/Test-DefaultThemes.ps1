#Load required libraries
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing 

$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$ThemeFile = Join-Path -Path $ScriptPath -ChildPath Themes\ExpressionLight.xaml

[xml]$xaml = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp1"
        Title="ExpressionLight Theme" Height="526" Width="433" ResizeMode="NoResize" Background="Black">
        
        <Window.Resources>
             <ResourceDictionary>
                <ResourceDictionary.MergedDictionaries>
                    <ResourceDictionary Source="$ThemeFile" /> 
                </ResourceDictionary.MergedDictionaries>
                <Style TargetType="{x:Type CheckBox}">
                    <Setter Property="Foreground" Value="White"/>
                </Style>
                <Style TargetType="{x:Type RadioButton}">
                    <Setter Property="Foreground" Value="White"/>
                </Style>
             </ResourceDictionary>
         </Window.Resources>
        
    <Grid>
        <Border BorderBrush="Black" BorderThickness="1" HorizontalAlignment="Left" Height="46" Margin="10,55,0,0" VerticalAlignment="Top" Width="132">
            <Label x:Name="label2" Content="Border control" Margin="26,9,24,18"/>
        </Border>
        <ToggleButton x:Name="Togglebutton" Content="Toggle" HorizontalAlignment="Left" Margin="10,106,0,0" VerticalAlignment="Top" Width="75"/>
        <Button x:Name="button1" Content="Button2" HorizontalAlignment="Left" Margin="10,131,0,0" VerticalAlignment="Top" Width="75"/>
        <CheckBox x:Name="checkBox" Content="CheckBox" HorizontalAlignment="Left" Margin="90,108,0,0" VerticalAlignment="Top"/>
        <CheckBox x:Name="checkBox1" Content="CheckBox" HorizontalAlignment="Left" Margin="90,133,0,0" VerticalAlignment="Top"/>
        <ComboBox x:Name="comboBox" HorizontalAlignment="Left" Margin="8,261,0,0" VerticalAlignment="Top" Width="196"/>
        <DataGrid x:Name="dataGrid" HorizontalAlignment="Left" Height="100" Margin="10,156,0,0" VerticalAlignment="Top" Width="196"/>
        <Label x:Name="label" Content="Label" HorizontalAlignment="Left" Margin="8,289,0,0" VerticalAlignment="Top" Width="53"/>
        <Label x:Name="label1" Content="Label" HorizontalAlignment="Left" Margin="8,307,0,0" VerticalAlignment="Top" Width="46"/>
        <RadioButton x:Name="radioButton" Content="RadioButton" HorizontalAlignment="Left" Margin="166,108,0,0" VerticalAlignment="Top"/>
        <RadioButton x:Name="radioButton1" Content="RadioButton" HorizontalAlignment="Left" Margin="166,132,0,0" VerticalAlignment="Top"/>
        <Rectangle HorizontalAlignment="Left" Height="46" Margin="149,55,0,0" Stroke="Black" VerticalAlignment="Top" Width="63"/>
        <TabControl x:Name="tabControl" HorizontalAlignment="Left" Height="100" Margin="197,308,0,0" VerticalAlignment="Top" Width="218">
            <TabItem Header="Tab1">
                <Grid Background="#FFE5E5E5" Height="68" RenderTransformOrigin="0.5,0.5" Width="211">
                    <Grid.RenderTransform>
                        <TransformGroup>
                            <ScaleTransform ScaleY="-1" ScaleX="-1"/>
                            <SkewTransform/>
                            <RotateTransform/>
                            <TranslateTransform/>
                        </TransformGroup>
                    </Grid.RenderTransform>
                    <Image x:Name="image" HorizontalAlignment="Left" Height="28" Margin="156,20,0,0" VerticalAlignment="Top" Width="35"/>
                    <ListView x:Name="listView" HorizontalAlignment="Left" Height="58" Margin="10,0,0,0" VerticalAlignment="Top" Width="126">
                        <ListView.View>
                            <GridView>
                            </GridView>
                        </ListView.View>
                    </ListView>
                </Grid>
            </TabItem>
            <TabItem Header="Tab2">
                <Grid Background="#FFE5E5E5"/>
            </TabItem>
            <TabItem Header="Tab3" HorizontalAlignment="Left" Height="27" VerticalAlignment="Top" Width="69">
                <Grid Background="#FFE5E5E5"/>
            </TabItem>
        </TabControl>
        <TextBlock x:Name="textBlock" HorizontalAlignment="Left" Margin="61,292,0,0" TextWrapping="Wrap" Text="TextBlock" VerticalAlignment="Top" Width="118"/>
        <TextBox x:Name="textBox" HorizontalAlignment="Left" Height="23" Margin="59,310,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="120"/>
        <Slider x:Name="slider" HorizontalAlignment="Left" Margin="48,344,0,0" VerticalAlignment="Top" Width="146"/>
        <ScrollBar x:Name="scrollBar" HorizontalAlignment="Left" Margin="10,334,0,0" VerticalAlignment="Top" Height="134" Width="13"/>
        <RichTextBox x:Name="richTextBox" HorizontalAlignment="Left" Height="55" Margin="197,413,0,0" VerticalAlignment="Top" Width="218">
            <FlowDocument>
                <Paragraph>
                    <Run FontFamily="Segoe UI" Text="This is "/>
                    <Run Foreground="#FFF00C0C" FontFamily="Segoe UI" Text="Line 1"/>
                </Paragraph>
                <Paragraph>
                    <Run FontFamily="Segoe UI" Text="This is "/>
                    <Run Foreground="#FF3E8B8B" FontFamily="Segoe UI" Text="Line 2"/>
                </Paragraph>
            </FlowDocument>
        </RichTextBox>
        <GroupBox x:Name="groupBox" Header="GroupBox" HorizontalAlignment="Left" Height="100" Margin="211,157,0,0" VerticalAlignment="Top" Width="204">
            <Grid HorizontalAlignment="Left" Height="61" Margin="0,10,-2,-1" VerticalAlignment="Top" Width="180">
                <CheckBox x:Name="checkBox2" Content="CheckBox" HorizontalAlignment="Left" Margin="10,15,0,0" VerticalAlignment="Top"/>
                <RadioButton x:Name="radioButton2" Content="RadioButton" HorizontalAlignment="Left" Margin="86,13,0,0" VerticalAlignment="Top"/>
                <RadioButton x:Name="radioButton3" Content="RadioButton" HorizontalAlignment="Left" Margin="86,34,0,0" VerticalAlignment="Top"/>
                <CheckBox x:Name="checkBox3" Content="CheckBox" HorizontalAlignment="Left" Margin="10,35,0,0" VerticalAlignment="Top"/>
            </Grid>
        </GroupBox>
        <StatusBar HorizontalAlignment="Left" Height="14" Margin="0,473,0,0" VerticalAlignment="Top" Width="425"/>
        <ScrollBar x:Name="scrollBar1" HorizontalAlignment="Left" Margin="46,379,0,0" VerticalAlignment="Top" Width="144" Orientation="Horizontal"/>
        <ListBox x:Name="listBox" HorizontalAlignment="Left" Height="66" Margin="325,10,0,0" VerticalAlignment="Top" Width="90"/>
        <ProgressBar x:Name="ProgressBar1" HorizontalAlignment="Left" Height="10" Margin="46,401,0,0" VerticalAlignment="Top" Width="128" IsIndeterminate="True"/>
        <DatePicker HorizontalAlignment="Left" Margin="309,264,0,0" VerticalAlignment="Top" Width="106"/>
        <Label x:Name="label3" Content="rectangle" HorizontalAlignment="Left" Margin="155,69,0,0" VerticalAlignment="Top" Height="18" Width="49"/>
        <Ellipse HorizontalAlignment="Left" Height="45" Margin="217,56,0,0" Stroke="Black" VerticalAlignment="Top" Width="103"/>
        <Label x:Name="label3_Copy" Content="Eclipse" HorizontalAlignment="Left" Margin="250,69,0,0" VerticalAlignment="Top" Height="18" Width="39" RenderTransformOrigin="0.915,0.537"/>
        <Expander x:Name="expander" Header="Expander" HorizontalAlignment="Left" Height="95" Margin="325,78,0,0" VerticalAlignment="Top" Width="90">
            <Grid Background="#FFE5E5E5"/>
        </Expander>
        <ProgressBar x:Name="ProgressBar" HorizontalAlignment="Left" Height="23" Margin="46,422,0,0" VerticalAlignment="Top" Width="148"/>
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

<#
$Info = "Item1", "Item2", "Item3"

for ($i = 0; $i -lt $Info.Count; $i++)  
{  
  $listBox.Items.Insert($i, $Info[$i])
}
#>
$Info = "Item1", "Item2", "Item3", "Item4"
$listBox.ItemsSource = $Info
$listBox.SelectedIndex = 0

$checkBox.IsChecked = $true
$checkBox2.IsChecked = $true
$radioButton.IsChecked = $true
$radioButton3.IsChecked = $true
$Togglebutton.IsChecked = $true

$comboBox.ItemsSource = $Info
$comboBox.SelectedIndex = 0

$dataGrid.ItemsSource = Get-Process | select name, Id, SI -First 5
$ProgressBar.value = 60

$listView.ItemsSource =Get-Service | select name, status -First 5

$ImageFile = Join-Path -Path $ScriptPath -ChildPath Themes\VSPower.png
$image.Source = $ImageFile

#Mandetory last line of every script to load form
[void]$Form.ShowDialog() 

