#ILO details and credentials
$hpeilo = '1921.68.34.125'
$username = 'Administrator'
$password = 'P@ssw0rd'

#Approve self signed SSL certificate
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool ChckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
                return true;
            }
        )
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

#ILO5 common API url
$uri = "https://$ilo/redfish/v1"

#ILO4 - Login
$credBody = @{UserName = $username; Password=$password} | ConvertTo-Json
$loginUri = "$uri/Sessions/"
$hpeSession = Invoke-WebRequest -Uri $loginUri -Method Post -Body $credBody -ContentType 'application/json' -SessionVariable webSession

#ILO5 - Get list of user IDs
$accountsURI = "$uri/AccountService/Accounts/"
$authHeaders = @{'X-Auth-Token' = $hpeSession.Headers.'X-Auth-Token'}
$accounts = Invoke-WebRequest -Uri $accountsURI -Method Get -Headers $authHeaders -WebSession $webSession
$accountIDData = $accounts.Content | ConvertFrom-Json | Select-Object -ExpandProperty Members
$accountIDData

#ILO5 - Get username Info using Ids
$accountsData = @()
foreach ($accountId in $accountIDData)
{
    $id = Split-Path $accountId.'@odata.id' -Leaf
    $accountIDURI= "$uri/AccountService/Accounts/$id"
    $authHeaders = @{'X-Auth-Token' = $hpeSession.Headers.'X-Auth-Token'}
    $accountInfo = Invoke-WebRequest -Uri $accountIDURI -Method Get -Headers $authHeaders -WebSession $webSession
    $accountsData += $accountInfo.Content | ConvertFrom-Json
    $accountInfo.Content | ConvertFrom-Json | Select-Object -Property UserName, Id
}

<#
#ILO5 - Delete user using user ID
$deleteUserID = '3'
$deleteAccountsUri ="$uri/AccountService/Accounts/$deleteUserID/"
$authHeader = @{"X-Auth-Token" = $hpeSession.Headers.'X-Auth-Token'}
$deleteAccount = Invoke-WebRequest -Uri $deleteAccountsUri -Method Delete -Headers $authHeader -WebSession $webSession
#>

#ILO5 - LogOut
$authHeader = @{'X-Auth-Token' = $session.Headers.'X-Auth-Token'}
$accountList = Invoke-WebRequest -Uri $hpeSession.Headers.Location -Method Delete -Headers $authHeader -WebSession $webSession
