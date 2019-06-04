#https://blogs.technet.microsoft.com/stefan_stranger/2016/10/29/using-the-azure-arm-rest-api/
#https://docs.microsoft.com/en-us/rest/api/resources/resourcegroups/createorupdate
#https://docs.microsoft.com/en-in/rest/api/?view=Azure
#https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-common-deployment-errors

#requires -Version 3

# ---------------------------------------------------
# Script: C:\Scripts\GetAzureSubscriptionRESTAPI.ps1
# Version:
# Author: 
# Date: 10/28/2016 15:16:25
# Description: Get Azure Subscription Info using plain REST API calls.
# Comments:
# Changes:  
# Disclaimer: 
# This example is provided "AS IS" with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------


#region variables SPN ClientId and Secret
$ClientID       = '970b85d9-' #ApplicationID
$ClientSecret   = 'Qszc8h/'  #key from Application
$tennantid      = '8464cdb4-'
$SubscriptionId = 'b98aad88-'
#endregion
 

#region Get Access Token
$TokenEndpoint = {https://login.windows.net/{0}/oauth2/token} -f $tennantid 
$ARMResource = "https://management.core.windows.net/";

$Body = @{
        'resource'= $ARMResource
        'client_id' = $ClientID
        'grant_type' = 'client_credentials'
        'client_secret' = $ClientSecret
}

$params = @{
    ContentType = 'application/x-www-form-urlencoded'
    Headers = @{'accept'='application/json'}
    Body = $Body
    Method = 'Post'
    URI = $TokenEndpoint
}

$token = Invoke-RestMethod @params
#endregion

#region Get Azure Subscription
#$SubscriptionURI = "https://management.azure.com/subscriptions/$SubscriptionID" +'?api-version=2016-09-01'
$SubscriptionURI = "https://management.azure.com/subscriptions/$SubscriptionId/resourcegroups" + '?api-version=2017-05-10'


$params = @{
    ContentType = 'application/x-www-form-urlencoded'
    Headers = @{
    'authorization'="Bearer $($Token.access_token)"
    }
    Method = 'Get'
    URI = $SubscriptionURI

}

Invoke-RestMethod @params | Select-Object -ExpandProperty value

#endregion


######
#region put
#PUT https://management.azure.com/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}?api-version=2018-05-01
# https://docs.microsoft.com/en-us/rest/api/resources/resourcegroups/createorupdate

$NewRgName = 'ApiRG'

$SubscriptionURI = "https://management.azure.com/subscriptions/$SubscriptionId/resourcegroups/$NewRgName" + '?api-version=2018-05-01'

#json template
$Body = "{   
    'location' : 'eastus'
}"

$params = @{
    ContentType = 'application/json'
    Headers = @{
    'authorization'="Bearer $($Token.access_token)"
    }
    Method = 'Put'
    URI = $SubscriptionURI
    Body = $Body

    
}

Invoke-RestMethod @params #| Select-Object -ExpandProperty value

#endregion


##-----------------other example --------------------------------
##get token
$TENANTID="<your tenantid>"
$APPID="<>"
$PASSWORD="<>"
$result=Invoke-RestMethod -Uri https://login.microsoftonline.com/$TENANTID/oauth2/token?api-version=1.0 -Method Post -Body @{"grant_type" = "client_credentials"; "resource" = "https://management.core.windows.net/"; "client_id" = "$APPID"; "client_secret" = "$PASSWORD" }
$token=$result.access_token

##set subscriptionId and resource group name
$subscriptionId="<your subscriptionId >"
$resourcegroupname="<resource group name>"

$Headers=@{
  'authorization'="Bearer $token"
  'host'="management.azure.com"
}
$body='{
    "location": "northeurope",
     "tags": {
        "tagname1": "test-tag"
    }
 }'
Invoke-RestMethod  -Uri "https://management.azure.com/subscriptions/$subscriptionId/resourcegroups/${resourcegroupname}?api-version=2015-01-01"  -Headers $Headers -ContentType "application/json" -Method PUT -Body $body
