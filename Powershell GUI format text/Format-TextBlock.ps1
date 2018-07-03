
 <#  
   .NOTES  
   --------------------------------------------------------------------------------  
    Code generated using by: Visual Studio  
    Created on:              26 June 2018 4:57 AM  
    Get Help on:             http://vcloud-lab.com  
    Written by:              Kunal Udapi  
    Build & Tested on:       Windows 10  
    Purpose:                 This script is an example of styling Font on textbox.
   --------------------------------------------------------------------------------  
   .DESCRIPTION  
     GUI script generated using Visual Studio 2017  
 #>  

#Load required libraries 
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing  
[xml]$xaml = @" 
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp9"
        
        Title="MainWindow" Height="315" Width="440">
    <Grid>
        <TextBox Name='StrComputerName' HorizontalAlignment="Left" Height="23" Margin="180,11,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="151"/>
        <WrapPanel HorizontalAlignment="Left" Height="32" Margin="10,39,0,0" VerticalAlignment="Top" Width="401">
            <TextBlock TextWrapping="Wrap" Text="ComputerName: " FontWeight="Bold" />
            <TextBlock FontStyle='Italic' Text="{Binding Path=Text, ElementName=StrComputerName}"/>
        </WrapPanel>

        <TextBlock HorizontalAlignment="Left" Margin="10,71,0,0" VerticalAlignment="Top" Width="401" Height="28" >
            <!-- Label control with <Bold>bold</Bold>, <Italic>italic</Italic> and <Underline>underlined</Underline> text -->
            Sample text <Span FontWeight="Bold">bold</Span>, <Span FontStyle="Italic">italic</Span> and <Span TextDecorations="Underline">underlined</Span> words.
        </TextBlock>

        <TextBlock HorizontalAlignment="Left" Margin="10,99,0,0" VerticalAlignment="Top" Width="401" Height="33" xml:space="preserve">
            Text <Span Foreground="Blue">with blue </Span> <Span Foreground="Orange">and</Span> <Span Background="Magenta">Magenta highlight</Span> <Span Foreground="Cyan">and Cyan color</Span>
        </TextBlock>

        <TextBlock HorizontalAlignment="Left" Height="53" Margin="10,132,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="401">
            <TextBlock.Inlines>
                <Run FontWeight="Bold" FontSize="14" Text="Bold TextBox Example. " />
                <Run FontStyle="Italic" Foreground="Red" Text="Red Text " />
                <LineBreak/> <!-- Next Line -->
                <Run TextDecorations="StrikeThrough" Text="StrikeThrough " />
            </TextBlock.Inlines>
        </TextBlock>

        <RichTextBox HorizontalAlignment="Left" Height="74" Margin="10,195,0,0" VerticalAlignment="Top" Width="401">
        <FlowDocument>
            <Paragraph>
                <Run FontFamily="Segoe UI" Text="This is "/>
                <Run Foreground="#FFF00C0C" FontFamily="Segoe UI" Text="Line 1 "/>
                <Run TextDecorations="Underline" FontStyle="Italic" FontFamily="Segoe UI" Text="Underline and Italic"/>
            </Paragraph>
            <Paragraph>
                <Run FontFamily="Segoe UI" Text="This is "/>
                <Run Foreground="#FF3E8B8B" FontFamily="Segoe UI" Text="Line 2 "/>
                <Run Background="LightSkyBlue" FontFamily="Segoe UI" Text="Different Background"/>
            </Paragraph>
        </FlowDocument>
        </RichTextBox>
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

#Mandetory last line of every script to load form 
[void]$Form.ShowDialog() 
