<#
#requires -version 3
.SYNOPSIS
    Downlaod all files and folder from IIS directory website.
.DESCRIPTION
    The Start-DirDownload cmdlet downloads complete directory and files from web. 
.PARAMETER Downloadurl
    Prompts you for download url
.PARAMETER DownloadToFolder
    Prompts where you want to download files and folder from IIS web, DownloadPath is alias
.INPUTS
    No Input
.OUTPUTS
    Output is on console directly.
.NOTES
  Version:        2.0
  Author:         Kunal Udapi
  Creation Date:  12 February 2017
  Purpose/Change: Download automated way to download files from net (http://kunaludapi.blogspot.in)
  Useful URLs:    http://vcloud-lab.com
.EXAMPLE 1
    PS C:\>Start-DirDownload -Downloadurl http://freetrainings001.com/trainingPortal/AzureAdvanced -DownloadToFolder C:\Temp

    This command start download files from given url and downloads to given folderpath.
#>

[CmdletBinding(SupportsShouldProcess=$True,
    ConfirmImpact='Medium',
    HelpURI='http://vcloud-lab.com')]
Param
(
    [parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
    [String]$Downloadurl = 'http://freetrainings001.com/Office%20Learning%20Portal/Powershell%20Advanced%20Training/',
    [parameter(Position=1, Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
    [alias('DownloadPath')]
    [String]$DownloadToFolder = 'C:\Temp\test'
)
process {
    try {
        if (!(Test-Path -Path $DownloadToFolder)) {
            New-Item -Path $DownloadToFolder -Type Directory -Force -ErrorAction Stop | Out-Null
        }
        $CMDBrowser = Invoke-WebRequest $downloadurl -ErrorAction Stop
        $AllLinks = $CMDBrowser.links | Where-Object {$_.innerHTML -ne "[To Parent Directory]" -and $_.innerHTML -ne 'web.config'} #| Select -Skip 23
        foreach ($link in $AllLinks) {
            $FolderName = $link.innerText
            $DownloadPath = Join-Path $DownloadToFolder $FolderName
            if (!(Test-Path $DownloadPath)) {
                New-Item -Path $DownloadPath -ItemType Directory | Out-Null
            }
            $RawWebsite = $Downloadurl -split '/'
            $WebSite = $RawWebsite[0,2] -join '//'
            Write-Host $FolderName -BackgroundColor DarkGreen
            $FolderUrl = "{0}{1}" -f $WebSite, $link.href #$Downloadurl Replacedby $WebSite
            $FolderLinks = Invoke-WebRequest $FolderUrl 
            if ($FolderLinks.StatusCode -eq 200) {
                $FilesLinks = $FolderLinks.Links | Where-Object {$_.innerHTML -ne '[To Parent Directory]' -and $_.innerHTML -ne 'web.config'} #| Select-Object -Skip 5
                foreach ($File in $FilesLinks) {
                    $FileUrl = "{0}{1}" -f $WebSite, $File.href
                    $FilePath = "{0}\{1}" -f $DownloadPath, $File.innerText
                    try {
                        if (!(Test-Path -Path $FilePath)) {
                            Invoke-WebRequest -Uri $FileUrl -OutFile $FilePath
                            Write-Host "`t|---$($File.innerText)"
                        }
                        else {
                            Write-Host "`t|---$($File.innerText) --Already exist" -ForegroundColor DarkYellow
                        }
                    }
                    catch {
                        Write-Host "`t|---$FilePath --skipped" -BackgroundColor DarkRed
                    }
                }
            }
        }
    }
    catch {
        Write-Host $error[0]
    }
}
