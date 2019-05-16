# Load ADAL Assemblies
 
#$adal = "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ResourceManager\AzureResourceManager\AzureRM.Profile\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
#$adalforms = "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ResourceManager\AzureResourceManager\AzureRM.Profile\Microsoft.IdentityModel.Clients.ActiveDirectory.WindowsForms.dll"
 
$adal = 'C:\Program Files\WindowsPowerShell\Modules\AzureRM.profile\5.8.2\Microsoft.IdentityModel.Clients.ActiveDirectory.dll'
$adalforms = 'C:\Program Files\WindowsPowerShell\Modules\AzureRM.profile\5.8.2\Microsoft.IdentityModel.Clients.ActiveDirectory.WindowsForms.dll'

[System.Reflection.Assembly]::LoadFrom($adal)
[System.Reflection.Assembly]::LoadFrom($adalforms)
 
# Set Azure AD Tenant name
#$adTenant = "tenant.onmicrosoft.com"
$adTenant = 'XXXXXXXXX.onmicrosoft.com' ###### Tenant

# Set well-known client ID for AzurePowerShell
$clientId = "1950a258-227b-4e31-a9cf-717495945fc2"
 
# Set redirect URI for Azure PowerShell
$redirectUri = "urn:ietf:wg:oauth:2.0:oob"
 
# Set Resource App URI as ARM
$resourceAppIdURI = "https://management.azure.com/"
 
# Set Authority to Azure AD Tenant
$authority = "https://login.windows.net/$adTenant"
 
# Create Authentication Context tied to Azure AD Tenant
$authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority
 
# Acquire token
$authResult = $authContext.AcquireToken($resourceAppIdURI, $clientId, $redirectUri, "always")
 
# Output bearer token
$authHeader = $authResult.CreateAuthorizationHeader()
$authHeader | Out-File jwt.txt


#############################################################
$subscriptionId = 'dd5636cb-'
$SubscriptionURI = "https://management.azure.com/subscriptions/$SubscriptionId/resourcegroups" + '?api-version=2017-05-10'
$params = @{
    ContentType = 'application/x-www-form-urlencoded'
    Headers = @{
    'authorization'= $authHeader 
    }
    Method = 'Get'
    URI = $SubscriptionURI
}

Invoke-RestMethod @params | Select-Object -ExpandProperty value