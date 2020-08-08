#IDrac 9 - Info and credentials
$hpeilo = '192.168.34.120'
$username = 'Administrator'
$password = 'P@ssw0rd'

#Securing UserName & Password
$securePassword =  ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $securePassword)

#Allow SelfSigned SSL certificate
Add-Type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
                return true;
            }
        )
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
[System.Net.ServicePointManager]::SecurityProtocol =  [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls11

#Base common iDRAC rest api
$iDracBaseUrl =  "https://$iDracIp/redfish/v1"

#iDRAC9 - Login Session
$sessionsUrl = "$iDracBaseUrl/Sessions"
$credBody = @{'UserName' = $username; 'Password'=$password} | ConvertTo-Json
$headers = @{'Accept' = 'application/json'}
#curl -X POST -k "https://<iDRAC IP>/redfish/v1/Sessions" -H "ContentType:application/json" -d '{"UserName":"root","Password":"calvin"}' -v
$session = Invoke-WebRequest -Uri $sessionUrl -Method Post -Body $credBody -ContentType 'application/json' -Headers $headers

#iDRAC9 - Authentication header token
$authHeaders = @{
    'X-Auth-Token' = $session.Headers.'X-Auth-Token'
    accpet = 'application/json'
}

#iDRAC9 - Get Managers API Id - 'iDRAC.Embedded.1'
$managersApi = "$iDracBaseUrl/Managers"
$managers = Invoke-WebRequest -Uri $managersApi -Method Get -Headers $authHeaders -ContentType 'application/json'
$rawManagerId = $managers.Content | ConvertFrom-Json | Select-Object -ExpandProperty Members

#iDRAC9 - Get List of users IDs
$managerId =  Split-Path -Path $rawManagerId.'@odata.id' -Leaf
$accountsListAPI = "$iDracBaseUrl/Managers/$managerId/Accounts"
$accountsList = Invoke-WebRequest -Uri $accountsListAPI -Method Get -Headers $authHeaders -ContentType 'application/json'
$accountIDData = $accountsList.Content | ConvertFrom-Json | Select-Object -ExpandProperty Members

#iDRAC9 - Account details
foreach ($id in $accountIDData)
{
    $accountId = Split-Path -Path $id.'@odata.id' -Leaf
    $accountAPI = "$iDracBaseUrl/Managers/$managerId/Accounts/$accountId"
    $accountInfo = Invoke-WebRequest -Uri $accountAPI -Method Get -Headers $authHeaders -ContentType 'application/json'
    $account = $accountInfo.Content | ConvertFrom-Json
    if (-not([string]::IsNullOrWhiteSpace($account.UserName)))
    {
        $account | Select-Object UserName, Id
    }
}

#iDRAC9 - Delete user (disable and empty user name
$deleteAccountId = 5
$deleteAccountsAPI = "$iDracBaseUrl/Managers/$managerId/Accounts/$deleteAccountId"
#disable
$disableAccountBody = @{Enabled = $false} | ConvertTo-Json
$disableAccount = Invoke-WebRequest -Uri $deleteAccountsAPI -Method Patch -Headers $authHeaders -ContentType 'application/json' -Body $disableAccountBody
#delete
$deleteAccountBody = @{UserName = ''} | ConvertTo-Json
$deleteAccount = Invoke-WebRequest -Uri $deleteAccountsAPI -Method -Patch -Headers $authHeaders -ContentType 'application/json' -Body $deleteAccountBody

#iDRAC9 - LogOut
$endSessionApi = "https://$iDracIp" + $session.Headers.Location
$endSession = Invoke-Webrequest -Uri $endSessionApi -Method Delete -Headers $authHeaders -ContentType 'application/json'