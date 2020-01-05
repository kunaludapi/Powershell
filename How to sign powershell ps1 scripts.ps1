Set-ExecutionPolicy AllSigned -Force                                      #Configure script execution policy to all script must be signed

$scriptPath = '\\192.168.34.16\RemoteScripts\NewScript.ps1'               #This is share path, Where all scripts will be hosted
$certStoreLocation = 'Cert:\CurrentUser\My'                               #This is local certification store
$certificateName = '\\192.168.34.16\RemoteScripts\PSCodeCertifiate.cer'   #This is certificate to give to users

#Create a code-signing, self-signed certificate
$selfSignedCertInfo = @{
	Subject = 'vCloud-lab.com Code Signing'
	Type = 'CodeSigning'
	CertStoreLocation = $certStoreLocation 
}
$cert = New-SelfSignedCertificate @selfSignedCertInfo

#View the newly created certificate
Get-ChildItem -Path $certStoreLocation -CodeSigningCert | Where-Object {$_.SubjectName.Name  -Match $_.$selfSignedCertInfo.Subject}

#Create a simple script
$scriptCode = @"
#Demo Script for Testing
Write-Host "ComputerName: $env:COMPUTERNAME" -BackgroundColor Green
ipconfig
"@
$scriptCode | Out-File -FilePath $scriptPath

#View the files
Get-ChildItem -Path $scriptPath

#Sign the Script
$codeSignInfo = @{
	Certificate = $Cert
	FilePath = $scriptPath
}
Set-AuthenticodeSignature @codeSignInfo

#View the files
Get-ChildItem -Path $scriptPath

#Test the signature
Get-AuthenticodeSignature -FilePath $scriptPath | Format-List *

#Export certificate to file on sharepath
Export-Certificate -Cert $cert -FilePath $certificateName

#Import it to users trusted root certificate autorities
Import-Certificate -FilePath $certificateName -CertStoreLocation 'Cert:\CurrentUser\Root' -Confirm:$false

#Import certificate to Trusted publisher store location
Import-Certificate -FilePath $certificateName -CertStoreLocation 'Cert:\CurrentUser\TrustedPublisher' -Confirm:$false

#Re-sign with a trusted certificate
Set-AuthenticodeSignature @codeSignInfo

#Check the script's signature
Get-AuthenticodeSignature -FilePath $scriptPath | Format-List