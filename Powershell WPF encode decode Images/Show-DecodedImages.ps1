 <#  
   .NOTES  
   --------------------------------------------------------------------------------  
    Code generated using by: Visual Studio  
    Created on:              4/17/2018 4:57 AM  
    Get Help on:             http://vcloud-lab.com  
    Written by:              Kunal Udapi  
    Build & Tested on:       Windows 10  
    Purpose:                 This script encode and decode images in powershell gui, so no Image picture file need to attach separately.
   --------------------------------------------------------------------------------  
   .DESCRIPTION  
     GUI script generated using Visual Studio 2017  
 #>  

$TitleIcon = @' 
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAADiklEQVR42r1WaUhUURQ+11mqochxK1t/FCpSpNliqWnojyZyJFBTLCJITbAMRUnCZswimVIqBMv6UbSJFuVCFo2kjZYtloKISf0oCsslDUvJGb2de503Pp8zSZBduJxz1++c75x37iPwh6bdne6LIpYQEk4p9UWpRsmW+rG347gWx2WV1wvbHd1BHFzsg4cNeFiDQxnqBHUqSNvh8bEF1RpUsyquFXRMCxC1JyMZRSF2FfxdG8KejiAXHQLg5bloUY7IOiroKOhiTw8uP3d1A1uS7rHqeUiZbgoA0pKMe4oFBqSHF3q40qL8LA6QesQAXV97HQEwPUXwhFgt90HRLKbFzcWZy95vA1zGaCMgIXob12/cfgDllUa7+0R0BbCYEKv1lSh2CFa4uzqDQZdG5s1V0YbnLTA6NkZCN62lCoWcr1sso1D/7DXInJxI8EY/OvhjCLJyz5Oevn6xN1VIlZag9b44aBVnCwMoPpNN5DLZJPcdZBEHTMnMlwKw7FrDAPSo6EDS0pLiYGvwOq7/GhmBGuNTaGnr5GO/VV6gidgMs5RKPn7c8ArOlZTay6xcBmBCtCBpoA4m7iLhIevpiNkMOacukLfvPkzywHvlcsjLPkCUCgWtNb2Eostl9gLeyAD6UFeLsyUk0B9ioyKIXC6jFTX1cKW0mqjmzKYxOMeyqLzCCD+HhmFffCSJ0oRyisoqjMTU9IZ+6e7jV1kB+hnAmEDr0kULyNmTGVQmc7JZoT99CVrbOsneuB105/YwPnePgd6qAv/V3kSXmWizGoFo2tECwO9kwhsGIKTrEk8PQABAy20k6g0lnHsEAATgc3fv18HV0moeC31Wkm0v88QKIEzRf0jRI6SoxS5FJlSCpeFP3R8LEVs28AzCIEPn+4+T1r1WLIMT2SmgVCrA+OQFC7K9LGrgaYpgx6RZdDg5noQFBXAdM4lgmlKkinsgSlO+v66xmaWpvSw6PvMfmrUWsVIRKa5DBv0hwFIBDU28VACWCsBSwdfNZotQKiA40A8GB3mpkNajKqxFWqEW8WKHwCrBQndXNa5R2tM3wC2K0YbThGgNt/jmnYcsqHzezWU+HS9238UUDaMagLWo4/+Ua6GxBwdFDjh4SvHB4QufJvJc2viDg5dPfXDEnqAoFNM1XZBFtKQjLY6fTBHIzD36Esr4bwv2cOxMV1uX+G8L9lrsZXixw9+W32yghwi8OzeSAAAAAElFTkSuQmCC
'@ 

$TwitterImg = @' 
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
'@ 

$FacebookImg = @' 
iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAm1JREFUeNrs289r1EAUB/Dvpuvuxma3FbukxSqsqIdSwSqCloLgQURBEEWKIIJ48Q9YkB6Khx4qWrx40pu92kIvHvTmQVAsonjx1HOslepuNpPfTioVL25SN9tJmvdgwh6GmcyHmc2bCcmdvvZ0HsAoLwzZihIvn/P8Ms7LQWQzKhK/aMhuaAFALsMAOQkZDwIgAAIgAAIgAAIggMxGPjU5K0/Yld1FXgpt6603GAxm7wyAPX0yLpw5jIkTB3CkNgC5GH6703NLePVW42BSegEKu3pw6+pxTF4c3fi9pfBdsOZXyIr6e9qkDWB4sIL79XOoDff/dxueY4Lpqygp1dDNbqL+BINBP5m51NHgN8O1DZj6WnqeAn3lIubunkd/uRRbm46lw2p9TwdA/fYEBqtK7O3aZgMW+5FsgLGRIZw9Veta+7axDsdsJhfg5uVjXe/DbK3xJdFKHoA6oODk0X3b0pepf4PrsGQ9BsfH9kd5XP+Jpt7+9YXtuO2SBJ4jrEIuq5B6CskAGDlUjVTPsh3cmXqG9x9XOuvQ92A0NMiVIUhSXvwSCBKfKLHwYrnzwf+FwDiC77niAcI2N5ux/Gkl1n59z+HLQRMP0CtHA3BdL/a+Pdem8wACIICMR9fzgMXHk7Fsch7dux6p3vTDRSy9/EAzgAAIgAAIgAAIgAAIQHgmeKO+gJz07zOv+QdXoO7tDW1navY5Xr/7ElqPbeHF6LYA6Eb7G/I9P1I7BrPQaDJaAgRAAARAAARAAARAAARAAARAAARAADsCwBcO4IsdvtjuAwA1wxNADY7E3vDyE8I+nxcmsPH5/C8BBgAVF6U51f0mLAAAAABJRU5ErkJggg==
'@ 

$LinkedinImg = @' 
iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAABHhJREFUeNrsm0tsG1UUhv952OPEr9Z24jxcCklbkapZ0AdUlXiolVBR9xUKi/LadVmJosIuEhsECxBdgIQELFAXCIHUIjUIggpppYaHqlauIE2cOiaNY0/jZPy2Z7h33FZy47FTJ8TjmTnS2NZ4Zuz7+fznnHvumOkZHfsKwB6y5WAuc5DtOk8eDpFtAOY0D0seFmBeW6AAGBMDYFiY3CwAFgALgAXAAmBm4zfqQjv8TgScdkRTWcRSOfMAeO4JH947+iQG/Z0P9l2dS+H0hTDCccnYEjg86MfXI09VDZ7agZAX353Yj52+DuMC4FkG7x8bAsvUrqTdAo/RI49DKeaNCWBvvxd9Hkd9eezqhzeXhFLIGQ9Aj1toPNMgztFNjislY7qF0DSAOyuNXVtRyHwzlSEvZN1CaBrAn7FUQwi//RODmL43aJ1CaBpAUVbw1vkwZPoz1zApV8Tb5359yCX0B2FdaXBsKoFXvryMmcVU1f4/InEc+/Bb3JwXa+hCXxDWXQiNRzM49NHPGLTn4Xc7MJeUMJtcbhAcKhB4fz8Yu8MApbDgwlSew02ieWhIQhOCrw+M0NGeEqhKeWQQvD/0aF02CkEkcshn29MDTuwL4czhHatz3z0vGDl7AVduzT94a/qDNzSv9c3kFD6ZmMGR4QHsDroRdAlquzZTKGNazGCSzC8mIqIafHUDwM6x8Ajal+C46jLZ02HXPPb40zvx2rO7636emM7j7KW/8enkHRQ3qJmtm36AU7A1PMbnFPDu0WGcf3UvehwwFoBHseGQH9+//gwCTMa8HaFtPjc+e/kAFPFfoFwyHwBqBwd7MbJ/O0qLt0kmyZgPALVTL+0DB0WtKcrLibXXIXoHUJJlZAuNXbt/qwsvDIXU17J0F6XEHJRScZMrwQ203yML+PjiX7h4PYJCScZAtxefv/ki9oQCmuc8TwD8eON2pQwp5lRJcFuCYDtc7QPgVnwJp89dwnh4rmr/dDyFk1/8hF/eOa557lCvf1WFWb47T+KCB5y3u9KZ0bsErk4vrBr8fbsRS2J+Ka1dH7hqd6fkzDLxhtm6fcm2CYI0JmhWnHXmHzQelBJRyOmUMbPA2iZdCsqpuCoLPATSVEtjclaqSKKQNScA1RlI1UhTpSyJ+kyDm2Xl5STkXMbcq8NUCtb9ARYAC4AFwAJgAWg+kZgcgKJYEmh3W1cpHBEl/HBtRvN9UapeAa537LXoYt3PGg9HEXDXXkOcTaw0PQamZ3TsMnk+2PQMK72k1tW0C9OGdmXdEmCdW2Dr3r6m/ptxYwDHg9vaW1nv52wmBHBfT0IneOINnNtftxFp7CxABs66feC7iCwcTvOmQYa3gfP1qdJgOP32Xf73b0aDI/WE8koCsrRk0kKIyILzdBFZPNbym6JaWgkyNgF8YJu6bMWwnHlLYbbTo2YL+qwHAK2Z0RAPoJ5APYJ6RotMoQCCrfwFaExQZeHtasUfWYM0C0yQjd7a2bp7V2ntQEpq1uEi84pFdQVnE0z9+/x/AgwAahOQsYIbU3wAAAAASUVORK5CYII=
'@

$GooglePlusImg = @' 
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
'@

$YoutubeImg = @' 
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
'@

$FollowMeImg = @'
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
'@

#Load required libraries 
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing

function DecodeBase64Image {
    param (
        [Parameter(Mandatory=$true)]
        [String]$ImageBase64
    )
    # Parameter help description
    $ObjBitmapImage = New-Object System.Windows.Media.Imaging.BitmapImage #Provides a specialized BitmapSource that is optimized for loading images using Extensible Application Markup Language (XAML).
    $ObjBitmapImage.BeginInit() #Signals the start of the BitmapImage initialization.
    $ObjBitmapImage.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($ImageBase64) #Creates a stream whose backing store is memory.
    $ObjBitmapImage.EndInit() #Signals the end of the BitmapImage initialization.
    $ObjBitmapImage.Freeze() #Makes the current object unmodifiable and sets its IsFrozen property to true.
    $ObjBitmapImage
}

[xml]$xaml = @" 
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp8"

        Title="Image Demo" Height="200" Width="398" SizeToContent="Width" ResizeMode='NoResize' WindowStartupLocation="CenterScreen">
    <Grid>
        <Image Name='Twitter' HorizontalAlignment="Left" Height="61" VerticalAlignment="Top" Width="65" Margin="10,10,0,0" ToolTip='Twitter'/>
        <Image Name='Facebook' HorizontalAlignment="Left" Height="61" Margin="80,10,0,0" VerticalAlignment="Top" Width="71" ToolTip='Facebook'/>
        <Image Name='GooglePlus' HorizontalAlignment="Left" Height="61" Margin="156,10,0,0" VerticalAlignment="Top" Width="71" ToolTip='Google+'/>
        <Image Name='Youtube' HorizontalAlignment="Left" Height="61" Margin="232,10,0,0" VerticalAlignment="Top" Width="71" ToolTip='Youtube'/>
        <Image Name='Linkedin' HorizontalAlignment="Left" Height="61" Margin="308,10,-1,0" VerticalAlignment="Top" Width="71" ToolTip='Linkedin'/>
        <!-- <TextBlock Name='Label' HorizontalAlignment="Left" Margin="10,90,0,0" VerticalAlignment="Top" Foreground='Blue' FontSize="18"/> -->
        <StatusBar Height="30" HorizontalAlignment="Stretch" VerticalAlignment="Bottom">
            <StatusBarItem HorizontalAlignment="Right">
                <StackPanel Orientation="Horizontal">
                    <Image Name='FollowMe'/>
                    <TextBlock Name='Label' HorizontalAlignment="Left" VerticalAlignment="Top" Foreground='Blue' FontSize="18"/>
                </StackPanel>
            </StatusBarItem>
        </StatusBar>
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

#$ImageBase64 = [convert]::ToBase64String((get-content C:\Temp\Icons\follow.png -encoding byte)) | Out-Clipboard

$Form.Icon = DecodeBase64Image -ImageBase64 $TitleIcon
$Twitter.Source = DecodeBase64Image -ImageBase64 $TwitterImg
$Facebook.Source = DecodeBase64Image -ImageBase64 $FacebookImg
$GooglePlus.Source = DecodeBase64Image -ImageBase64 $GooglePlusImg
$Youtube.Source = DecodeBase64Image -ImageBase64 $YoutubeImg
$Linkedin.Source = DecodeBase64Image -ImageBase64 $LinkedinImg
$FollowMe.Source = DecodeBase64Image -ImageBase64 $FollowMeImg

$Twitter.Add_MouseEnter({$Label.Text = 'Follow me on Twitter'; $Script:url = 'https://twitter.com/kunaludapi'})
$Facebook.Add_MouseEnter({$Label.Text = 'Follow me on Facebook'; $Script:url = 'https://www.facebook.com/kunaludapi.outlook'})
$GooglePlus.Add_MouseEnter({$Label.Text = 'Follow me on Google+'; $Script:url = 'https://plus.google.com/+kunaludapi'})
$Youtube.Add_MouseEnter({$Label.Text =  'Follow me on Youtube'; $Script:url = 'https://www.youtube.com/kunaludapi'})
$Linkedin.Add_MouseEnter({$Label.Text = 'Follow me on Linkedin'; $Script:url = 'https://www.linkedin.com/in/kunaludapi/'})

$Label.Add_PreviewMouseDown({[system.Diagnostics.Process]::start($url)})

#Mandetory last line of every script to load form 
[void]$Form.ShowDialog() 

