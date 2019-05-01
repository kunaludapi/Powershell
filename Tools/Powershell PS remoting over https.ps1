# Get your computer hostname, it will require for next process for creating certificate.
$hostName = $env:COMPUTERNAME

# Generate a self-signed SSL certificate using powershell cmdlet with current hostname and domainname. It must be matching to your current computername
# Certificate is stored in Local Machine \ Personal store location.
$serverCert = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName "$hostName" 
$serverCert #view thumbprint of SSL certificate

# Export SSL self-signed certificate to shared location with .CER extension
Export-Certificate -Cert $ServerCert -FilePath \\fileshare\Cert\PsRemoting-Cert.cer
#Verify file on fileshare
Get-ChildItem -File \\fileshare\Cert\PsRemoting-Cert.cer

# Enable Powershell remoting starts WS-Management listener for HTTP, Disables firewall for PS-Remoting
# -SkipNetworkProfileCheck allows connection from any network profile (Public/WorkGroup) 
# If you have disabled complete Firewall in Windows OS -SkipNetworkProfileCheck parameter not required
Enable-PSRemoting -Force

# View current listeners on PSRemoting, there should be only one listner 'Transport=HTTP'
Get-ChildItem wsman:\localhost\Listener

# I am removing http (Port 5985) listener and will add https (Port 5986) Listener
Get-ChildItem wsman:\localhost\Listener\ | Where-Object -Property Keys -eq 'Transport=HTTP' | Remove-Item -Recurse

# Review the available listeners, List should be empty
Get-ChildItem wsman:\localhost\Listener

# I am going to add new HTTPS listener with earlier created self signed Certificate
New-Item -Path WSMan:\localhost\Listener\ -Transport HTTPS -Address * -CertificateThumbPrint $ServerCert.Thumbprint -Force

#verify the new entry in listner
Get-ChildItem WSMan:\localhost\Listener\

#Configure firewall with new https
New-NetFirewallRule -DisplayName 'WinRM - Powershell remoting HTTPS-In' -Name 'WinRM - Powershell remoting HTTPS-IN' -Profile Any -LocalPort 5986 -Protocol TCP

#Restart PowerShell Remoting (WinRM) service to take effect of changes
Restart-Service WinRM

#If you don't want to import Certificate and connect to PSSession use option with -SkipCACheck
$sessionOptions = New-PsSessionOption -SkipCACheck

#use session option
Enter-PSSession -computerName psserver01 -SessionOption $sessionOptions

#On other remote computer import SSL self-signed certificate created earlier if it a CA (Certificate Authority) signed this step is not required on remote computer.
Import-Certificate -FilePath \\fileshare\Cert\PsRemoting-Cert.cer -CertStoreLocation Cert:\LocalMachine\Root\

#Test PS Remoting using parameter -UseSSL
Enter-PSSession -ComputerName psserver01 -UseSSL
