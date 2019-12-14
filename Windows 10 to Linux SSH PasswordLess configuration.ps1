[CmdletBinding(
    SupportsShouldProcess=$True,
    ConfirmImpact='Medium',
    HelpURI='http://vcloud-lab.com',
    DefaultParameterSetName='Manual'
)]

param 
(
    [string]$Computer = '192.168.34.13',
    [string]$User = 'root'
)
"`n"
$oldLocation = Get-Location
Set-Location -Path $env:USERPROFILE
Write-Host 'INFO: Checking <yourprofile>/.ssh/id_rsa exists' -ForegroundColor Cyan
if (-not(Test-Path -Path "./.ssh/id_rsa"))
{
	if (-not(Test-Path -Path "./.ssh"))
	{
		[void](New-Item -Path "./" -Name .ssh -ItemType Directory -Force)
        Write-Host 'INFO: Created <yourprofile>/.ssh directory' -ForegroundColor Cyan
	}
	ssh-keygen.exe -t rsa -b 4096 -N '""' -f "./.ssh/id_rsa"
    Write-Host 'INFO: Generated  <yourprofile>/.ssh/id_rsa file' -ForegroundColor Cyan
} 
else 
{
    Write-Host 'INFO: <yourprofile>/.ssh/id_rsa already exist, skipping...' -ForegroundColor Cyan
}

$id_rsa_Location = "$env:USERPROFILE/.ssh/id_rsa" 
$remoteSSHServerLogin = "$User@$Computer"


Write-Host "INFO: Copying <yourprofile>/.ssh/id_rsa.pub to $Computer, Type password`n" -ForegroundColor Cyan
scp.exe -o 'StrictHostKeyChecking no' "$id_rsa_Location.pub" "${remoteSSHServerLogin}:~/tmp.pub"
Write-Host "INFO: Updating authorized_keys on $Computer, Type password`n" -ForegroundColor Cyan
ssh.exe "$remoteSSHServerLogin" "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat ~/tmp.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && rm -f ~/tmp.pub"

Set-Location -Path $oldLocation
Write-Host "`nINFO: Try SSH to $Computer Now it will not prompt for password" -ForegroundColor Green