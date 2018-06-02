#Load Libraries
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing 
 
$Runspace = [runspacefactory]::CreateRunspace()
$Runspace.ApartmentState = "STA"
$Runspace.ThreadOptions = "ReuseThread"
$Runspace.Open()
 
$code = {
#Build the GUI
[xml]$xaml = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp6"
        Title="ProgressBar Demo" Height="220" Width="500" Topmost="True">
    <Grid>
        <ProgressBar Name="ProgressBar1" HorizontalAlignment="Left" Height="41" VerticalAlignment="Top" Width="264" Margin="10,10,0,0" Background="{x:Null}">
            <ProgressBar.OpacityMask>
                <ImageBrush ImageSource="C:\Temp\Images\Processing.png"/>
            </ProgressBar.OpacityMask>
        </ProgressBar>
        <TextBlock Name="TextBlock1" HorizontalAlignment="Left" Margin="281,10,0,0" TextWrapping="Wrap" VerticalAlignment="Top"/>
        <Button Name="Button1" Content="Complete" HorizontalAlignment="Left" Margin="279,31,0,0" VerticalAlignment="Top" Width="75"/>
        
        <ProgressBar Name="ProgressBar2" HorizontalAlignment="Left" Height="41" VerticalAlignment="Top" Width="264" Margin="10,56,0,0">
            <ProgressBar.OpacityMask>
                <ImageBrush ImageSource="C:\Temp\Images\Completed.png"/>
            </ProgressBar.OpacityMask>
        </ProgressBar>
        <TextBlock Name="TextBlock2" HorizontalAlignment="Left" Margin="279,56,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="128"/>
        <Button Name="Button2" Content="Complete" HorizontalAlignment="Left" Margin="279,72,0,0" VerticalAlignment="Top" Width="75"/>

        <ProgressBar Name="ProgressBar3" HorizontalAlignment="Left" Height="41" VerticalAlignment="Top" Width="203" Margin="10,102,0,0" >
            <ProgressBar.OpacityMask>
                <ImageBrush ImageSource="C:\Temp\Images\Loading.png"/>
            </ProgressBar.OpacityMask>
        </ProgressBar>
        <TextBlock Name="TextBlock3" HorizontalAlignment="Left" Margin="218,102,0,0" TextWrapping="Wrap" Text="Loading" VerticalAlignment="Top" Width="189"/>
        <Button Name="Button3" Content="Load" HorizontalAlignment="Left" Margin="218,123,0,0" VerticalAlignment="Top" Width="75"/>

    </Grid>
</Window>
"@
 
    $syncHash = [hashtable]::Synchronized(@{})
    $reader=(New-Object System.Xml.XmlNodeReader $xaml)
    $syncHash.Window=[Windows.Markup.XamlReader]::Load( $reader )
 
    function Update-Progress {
        param($syncHash,$ProgressNumber,$TargetBox)
        $syncHash.Host = $host
        $Runspace = [runspacefactory]::CreateRunspace()
        $Runspace.ApartmentState = "STA"
        $Runspace.ThreadOptions = "ReuseThread"
        $Runspace.Open()
        $Runspace.SessionStateProxy.SetVariable("syncHash",$syncHash) 

        $Runspace.SessionStateProxy.SetVariable("ProgressNumber",$ProgressNumber)
        #$Runspace.SessionStateProxy.SetVariable("TargetBox",$TargetBox)
 
        $code = {
            $syncHash.Window.Dispatcher.invoke(
                [action]{ 
                    $syncHash.Button1.isEnabled = $false
                    $syncHash.Button2.isEnabled = $false
                    $syncHash.Button3.isEnabled = $false
                }
            )
            if ($ProgressNumber -eq 1) {
                for ($i=0; $i -lt 101; $i++) {
                    $syncHash.Window.Dispatcher.invoke(
                        [action]{ 
                            $syncHash.ProgressBar1.Value = $i
                            $syncHash.TextBlock1.Text = "Working On Comp$i"
                        }
                    )
                    Start-Sleep -Milliseconds 100
                }
            }
            elseif ($ProgressNumber -eq 2) {
                for ($i=0; $i -lt 101; $i++) {
                    $syncHash.Window.Dispatcher.invoke(
                        [action]{ 
                            $syncHash.ProgressBar2.Value = $i
                            $syncHash.TextBlock2.Text = "Process created $i"
                        }
                    )
                    Start-Sleep -Milliseconds 100
                }
            }
            elseif ($ProgressNumber -eq 3) {
                for ($i=0; $i -lt 101; $i++) {
                    $syncHash.Window.Dispatcher.invoke(
                        [action]{ 
                            $syncHash.ProgressBar3.IsIndeterminate = $True
                            $syncHash.TextBlock3.Text = "Loading... File$i"
                        }
                    )
                    Start-Sleep -Milliseconds 100
                }
            }

            $syncHash.Window.Dispatcher.invoke(
                [action]{ 
                    $syncHash.Button1.isEnabled = $true
                    $syncHash.Button2.isEnabled = $true
                    $syncHash.Button3.isEnabled = $true
                    $syncHash.ProgressBar3.IsIndeterminate = $false
                }
            )        
        }
        $PSinstance = [powershell]::Create().AddScript($Code)
        $PSinstance.Runspace = $Runspace
        $job = $PSinstance.BeginInvoke()
    }

$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path 
"test" | clip
    # XAML objects
    <#
    $syncHash.ProgressBar1 = $syncHash.Window.FindName("ProgressBar1")
    $syncHash.TextBlock1 = $syncHash.Window.FindName("TextBlock1")
    $syncHash.Button1 = $syncHash.Window.FindName("Button1")
    $syncHash.ProgressBar2 = $syncHash.Window.FindName("ProgressBar2")
    $syncHash.TextBlock2 = $syncHash.Window.FindName("TextBlock2")
    $syncHash.Button2 = $syncHash.Window.FindName("Button2")
    $syncHash.ProgressBar3 = $syncHash.Window.FindName("ProgressBar3")
    $syncHash.TextBlock3 = $syncHash.Window.FindName("TextBlock3")
    $syncHash.Button3 = $syncHash.Window.FindName("Button3")
    #>

    #AutoFind all controls
    $xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")  | ForEach-Object { 
        #New-Variable  -Name $_.Name -Value $Form.FindName($_.Name) -Force
        $syncHash.Add($_.Name, $syncHash.Window.Findname($_.Name))
    }

    # Click Actions
    $syncHash.Button1.Add_Click({
        Update-Progress -syncHash $syncHash -ProgressNumber 1
    })

    $syncHash.Button2.Add_Click({
        Update-Progress -syncHash $syncHash -ProgressNumber 2
    })

    $syncHash.Button3.Add_Click({
        Update-Progress -syncHash $syncHash -ProgressNumber 3
    })
 
    $syncHash.Window.ShowDialog()
    $Runspace.Close()
    $Runspace.Dispose()
}
 
$PSinstance1 = [powershell]::Create().AddScript($Code)
$PSinstance1.Runspace = $Runspace
$job = $PSinstance1.BeginInvoke()