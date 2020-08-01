#ILO details and credentials
$hpeilo = '1921.68.34.25'
$username = 'Administrator'
$password = 'P@ssw0rd'

#ILO4 - Login
$credBody = @{UserName = $username; Password=$password} | ConvertTo-Json
$loginUri = "https://$hpeilo/rest/v1/Sessions"
$session = Invoke-WebRequest -Uri $loginUri -Method Post -Body $credBody -ContentType 'application/json' -UseBasicParsing
$session

#ILO4 - Get users list
$authHeader = @{'X-Auth-Token' = $session.Headers.'X-Auth-Token'}
$accountsAPI = "https://$hpeilo/rest/v1/AccountService/Accounts"
$accountList = Invoke-WebRequest -Uri $accountsAPI -Method Get -Headers $authHeader
($accountList.Content | ConvertFrom-Json).Items | Select-Object -Property UserName, Id
#ILO4 - Delete user with user ID
$iloUserId = '15'
$deleteAccountAPI ="https://$hpeilo/rest/v1/AccountService/Accounts/$iloUserId"
$authHeader = @{"X-Auth-Token"} = $sessions.Headers.'X-Auth-Token'}
$deleteAccount = Invoke-WebRequest -Uri $deleteAccountAPI -Method Delete -Headers $authHeader -UseBasicParsing

#ILO4 - Recheck and Get users list
$authHeader = @{'X-Auth-Token' = $session.Headers.'X-Auth-Token'}
$accountsAPI = "https://$hpeilo/rest/v1/AccountService/Accounts"
$accountList = Invoke-WebRequest -Uri $accountsAPI -Method Get -Headers $authHeader
($accountList.Content | ConvertFrom-Json).Items | Select-Object -Property UserName, Id

#ILO4 - LogOut
$authHeader = @{'X-Auth-Token' = $session.Headers.'X-Auth-Token'}
$accountList = Invoke-WebRequest -Uri $hpeSession.Headers.Location -Method Delete -Headers $authHeader -UseBasicParsing
