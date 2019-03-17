<#  
    .Synopsis  
    Clone Sync source user's member of group to another user and move users the Source user Ou, Remove and Clone group membership from one user to another in Active Directory.
    .Description  
    Run this script on domain controller, or install RSAT tool on your client machine. This will copy existing given users group to other give group. It validates and verify whether Source and Destination users exists or you have access.
    .Example  
    .\Sync-AdGroupMemberShipV2.ps1 -SourceUser Administrator -DestinationUsers user1, user2, user3 -Back8upPath C:\Temp
        
    It takes provided Source user, note down which groups it is member of. Add same groups in the member of tabs of users list provided in parameter DestinationUsers.
    .Example
    .\Sync-AdGroupMemberShipV2.ps1 -SourceUser Administrator -DestinationUsers (Get-Content C:\Userlist.txt) -BackupPath C:\Temp

    Users list can be provided into text file.
    .Example
    user1, user2, user3 | .\Sync-AdGroupMemberShip.ps1 -SourceUser Administrator -Back8upPath C:\Temp

    .Notes
    NAME: Sync-AdGroupMemberShipV2
    AUTHOR: Kunal Udapi
    CREATIONDATE: 16 February 2019
    LASTEDIT: 17 February 2019
    KEYWORDS: Clone source user's member of group to another user, Move users to source users OU.
    .Link  
    #Check Online version: http://kunaludapi.blogspot.com
    #Check Online version: http://vcloud-lab.com
    #Requires -Version 3.0  
    #>  
#requires -Version 3   
[CmdletBinding()]
param
(  
    [Parameter(Mandatory=$true,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$true)] #change
    [alias('DestUser')]
    [String[]]$DestinationUsers, #change
    [String]$SourceUser = 'Administrator', #change
    [String]$BackupPath = 'C:\') #param #change

Begin 
{  
    Import-Module ActiveDirectory
} #BeginQ

Process 
{
    try 
    {
        $sourceUserMemberOf = Get-AdUser $SourceUser -Properties MemberOf, CanonicalName -ErrorAction Stop
    }
    catch 
    {
        Write-Host -BackgroundColor DarkRed -ForegroundColor White $Error[0].Exception.Message
        Break
    }
    
    #$destinationUser = @('TestUser','vKunal','Test','TestUser1','Test2')
    $DestinationUser = [System.Collections.ArrayList]$DestinationUsers
    
    $confirmedUserList = @()
    foreach ($user in $destinationUser) 
    {
        try 
        {
            Write-Host -BackgroundColor DarkGray "Checking user '$user' status in AD..." -NoNewline
            $destinationUserInfo = Get-ADUser $user -Properties MemberOf, CanonicalName -ErrorAction Stop 
            Write-Host -BackgroundColor DarkGreen -ForegroundColor White "...Tested user '$user' exist in AD"
            $fileName = $user + '.grps'
            $filePath = Join-Path $BackupPath -ChildPath $fileName
            $destinationUserInfo.DistinguishedName | Out-File -FilePath $filePath
            $destinationUserInfo.MemberOf | Out-File -FilePath $filePath -Append
            try 
            {
                 $sourceOUName = (($sourceUserMemberOf.DistinguishedName -split ',',3)[1] -split '=')[1]
                 Write-Host -BackgroundColor Gray "`tMoving user '$user' to OU '$sourceOUName'..." -NoNewline
                 Get-ADObject -Filter {Name -eq $user} | Move-ADObject -TargetPath ($sourceUserMemberOf.DistinguishedName -split ",",2)[1]
                 Write-Host -BackgroundColor Yellow -ForegroundColor Black "...Moved user '$user' to OU '$sourceOUName'"
            }
            catch
            {
                Write-Host -BackgroundColor DarkRed -ForegroundColor White $destinationUserInfo.SamAccountName - $($Error[0].Exception.Message)
            }

            foreach ($memberOf in $destinationUserInfo.MemberOf)
            {
                try 
                {
                    $sourceGroupName = ($memberOf -split '=')[1].Split(',')[0]
                    Write-Host -BackgroundColor Gray "`tRemoving user '$user' from Group '$sourceGroupName'..." -NoNewline
                    Get-ADGroup $memberOf | Remove-ADGroupMember -Members $destinationUserInfo.SamAccountName -Confirm:$false -ErrorAction Stop
                    Write-Host -BackgroundColor Yellow -ForegroundColor Black "...Removed user '$user' from Group '$sourceGroupName'"
                }
                catch
                {
                    Write-Host -BackgroundColor DarkRed -ForegroundColor White $memberOf - $($Error[0].Exception.Message)
                }
            }
            $confirmedUserList += $user
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
        {
            Write-Host -BackgroundColor DarkRed -ForegroundColor White "...User '$user' doesn't exist in AD"
            
        } #catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
        catch 
        {
            Write-Host -BackgroundColor DarkRed -ForegroundColor White "...Check your access"
        } #catch
    } #foreach ($user in $destinationUser)
    
    Write-host "`n"
    
    foreach ($group in $sourceUserMemberOf.MemberOf) 
    {
        try 
        {
            $groupInfo = Get-AdGroup $group 
            $groupName = $groupInfo.Name
            $groupInfo | Add-ADGroupMember -Members $confirmedUserList -ErrorAction Stop
            Write-Host -BackgroundColor DarkGreen "Added destination users to group '$groupName'"
        } #try

        catch
        {
            #$Error[0].Exception.GetType().fullname
            if ($null -eq $confirmedUserList[0]) {
                Write-Host -BackgroundColor DarkMagenta "Provided destination user list is invalid, Please Try again."
                break
            }
            Write-Host -BackgroundColor DarkMagenta $groupName - $($Error[0].Exception.Message)
        } #catch
    } #foreach ($group in $sourceUserMemberOf.MemberOf) 
} #Process
end {}
