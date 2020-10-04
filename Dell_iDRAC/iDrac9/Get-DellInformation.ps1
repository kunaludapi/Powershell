#iDRAC9 IP and credentials
$iDRAC9 = '192.168.34.224'
$credentials =  Get-Credential -Message "Type iDRAC9 credentials" -UserName root

try
{
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 -bor [Sytstem.Net.SecurityProtocolType]::Tls11
    Write-Host 'Allowed SelfSigned SSL certificate for this iDRAC session'
}
catch
{
    Write-Host 'Already Allowed SelfSigned SSL certificate for this iDRAC session'
}

#curl example
#curl "https://<iDRAC IP>/redfish/v1/Chassis" -k -u root:calvin

#Example API URI to get iDRAC9 Information
$basicAPIUrl = 'https://$iDRAC9/redfish/v1'
$systemAPIUrl = 'https://$iDRAC9/redfish/v1/Systems/System.Embedded.1'

#Common Header Example
$Headers = @{'Accept'='application/json'}

#Results
$basicInfo = Invoke-RestMethod -Uri $basicAPIUrl -Credential $credentials -Method Get -ContentType 'application/json' -Headers $Headers #-UseBasicParsing
$basicInfo

$systemInfo = Invoke-RestMethod -Uri $basicAPIUrl -Credential $credentials -Method Get -ContentType 'application/json' -Headers $Headers #-UseBasicParsing
$systemInfo.MemorySummary