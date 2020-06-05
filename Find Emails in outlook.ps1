$outlookFolder = 'Schedular'

Add-type -assembly “Microsoft.Office.Interop.Outlook” | out-null
$outlook = new-object -comobject outlook.application
$namespace = $outlook.GetNameSpace(“MAPI”)
$olFolders = “Microsoft.Office.Interop.Outlook.olDefaultFolders” -as [type]
$folder =  $namespace.GetDefaultFolder($olFolders::olFolderInbox).Folders.Item($outlookFolder)


$folder.Items | Select-object Subject, ReceivedTime, SenderName -Last 48

$test = $folder.Items | Select-Object ReceivedTime -first 1

<#
Get-Date -Uformat "$($test.ReceivedTime.DateTime) %A,%M, %Y"
[datetime]::ParseExact($test.ReceivedTime.DateTime, 'dd-MM-yyyy', $null)
[datetime]::Parse($test.ReceivedTime.DateTime, 'dd-MM-yyyy', $null)
#>

Get-Date -format dd-MM-yyyy $test.ReceivedTime.DateTime

<#
$inbox = $namespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderInbox)
$olFolders = “Microsoft.Office.Interop.Outlook.olDefaultFolders” -as [type]

$namespace.Folders | foreach {
"$($_.Name)"
$_.Folders} | foreach {"$($_.Name)"}
}

$folder = $namespace.Folder.Item('Test')

 $folder = $namespace.Folders('Test')

 Get-help -name $namespace.Folders
#>
