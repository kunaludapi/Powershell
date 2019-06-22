<#
	.NOTES
	===========================================================================
	 Created on: 2019/06/21
	 Created by: Kunal udapi
	 GitHub link: kunaludapi	
	 Twitter: @kunaludapi
	 Url1: https://thecloudcurry.com
	 Url2: http://vcloud-lab.com
	===========================================================================
#>

#Load required libraries
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing

[xml]$xaml = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp7"
        
        Title="Image Splitter Demo - Climate Change" Height="470" Width="800" Icon="$PSScriptRoot\Images\Icon.ico" >
    <Window.Resources>
        <ResourceDictionary>
            <ResourceDictionary.MergedDictionaries>
                <ResourceDictionary Source="$PSScriptRoot\themes\Metro.MSControls.Core.Implicit.xaml"/>
                <ResourceDictionary Source="$PSScriptRoot\themes\Styles.WPF.xaml"/>
                <ResourceDictionary Source="$PSScriptRoot\themes\Theme.Colors.xaml"/>
                <ResourceDictionary Source="$PSScriptRoot\themes\Styles.Shared.xaml"/>
            </ResourceDictionary.MergedDictionaries>
        </ResourceDictionary>
    </Window.Resources>

    <Grid> 
        <Grid Margin="10,70,209,57">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*" />
                <ColumnDefinition Width="Auto" />
                <ColumnDefinition Width="*" />
            </Grid.ColumnDefinitions>
            <Image x:Name="After" HorizontalAlignment="Left"
            Grid.ColumnSpan="3" />
            <Image x:Name="Before" HorizontalAlignment="Left"
            Width="{Binding ActualWidth, ElementName=After}"
            Height="{Binding ActualHeight, ElementName=After}" />
            <GridSplitter Grid.Column="1" Width="5" HorizontalAlignment="Center"/>
        </Grid>

            <TextBox x:Name="textBoxBefore" HorizontalAlignment="Left" Height="23" Margin="10,10,0,0" TextWrapping="Wrap" Text="Image1" VerticalAlignment="Top" Width="271"/>
            <TextBox x:Name="textBoxAfter" Height="23" Margin="286,10,223,0" TextWrapping="Wrap" Text="Image2" VerticalAlignment="Top"/>
            <Image x:Name="imageLegands" Height="43" Margin="25,46,252,0" VerticalAlignment="Top" Source="$PSScriptRoot\Images\Legands.png"/>
            <StatusBar Name="statusBar1" Height="30" HorizontalAlignment="Stretch" VerticalAlignment="Bottom" Background="SkyBlue">
                <StatusBarItem Content="http://vcloud-lab.com" Width="150"/>
                <StatusBarItem Content="https://thecloudcurry.com" Width="150" />
                <StatusBarItem HorizontalAlignment="Right">
                </StatusBarItem>
            </StatusBar>
            <Button x:Name="buttonBrowse1" HorizontalAlignment="Left" Margin="241,10,0,0" VerticalAlignment="Top" Width="40" Height="23">
                <Image HorizontalAlignment="Left" VerticalAlignment="Top" Source="$PSScriptRoot\Images\Browse.png" Height="23" Width="23" Cursor="Hand"/>
            </Button>
            <Button x:Name="buttonBrowse2" Margin="0,10,224,0" VerticalAlignment="Top" HorizontalAlignment="Right" Width="40" Height="23">
                <Image HorizontalAlignment="Left" VerticalAlignment="Top" Source="$PSScriptRoot\Images\Browse.png" Width="23" Height="23" Cursor="Hand" />
            </Button>
            <TextBlock x:Name="textBlock" Margin="10,0,209,35" TextWrapping="Wrap" Text="Rapid Emissions Reductions (RCP 2.6)                                          Continued Emissions Reductions (RCP 8.5)" VerticalAlignment="Bottom" Height="22"/>
                    <TextBlock HorizontalAlignment="Right" Margin="0,46,10,57"  TextWrapping="Wrap" Text="Greenhouse gas concentrations in the atmosphere will continue to increase unless the billions of tons of our annual emissions decrease substantially. Increased concentrations are expected to:&#10;
&#10;* Increase Earth's average temperature&#10;
* Influence the patterns and amounts of precipitation&#10;
* Reduce ice and snow cover, as well as permafrost&#10;
* Raise sea level&#10;
* Increase the acidity of the oceans&#10;
* Increase the frequency, intensity, and/or duration of extreme events&#10;
* Shift ecosystem characteristics&#10;
* Increase threats to human health" Width="193"/>
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

function Get-PictureFile([string] $InitialDirectory ) 
{
	[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
	$openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
	$openFileDialog.initialDirectory = $initialDirectory
	$openFileDialog.filter = "All files (*.png, *.jpg)| *.png; *.jpg"
	$openFileDialog.ShowDialog() |  Out-Null
	$openFileDialog.filename
}


$buttonBrowse1.Add_Click({
    $image1File = Get-PictureFile -InitialDirectory [Environment]::GetFolderPath('MyPicture')
    $textBoxBefore.Text = $image1File
    $Before.Source = $image1File
})

$buttonBrowse2.Add_Click({
    $image2File = Get-PictureFile -InitialDirectory [Environment]::GetFolderPath('MyPicture')
    $textBoxAfter.Text = $image2File
    $After.Source = $image2File
})

#Mandetory last line of every script to load form
$Form.ShowDialog() | Out-Null