<#  
    .Synopsis  
    Copy or clone source user's member of group to another user, Copy group membership from one user to another in Active Directory.
    .Description  
    Run this script on domain controller, or install RSAT tool on your client machine. This will copy existing given users group to other give group. It validates and verify whether Source and Destination users exists or you have access.
    .Example  
    .\Copy-AdGroupMemberShip.ps1 -SourceUserGroup Administrator -DestinationUsers user1, user2, user3
        
    It takes provided Source user, note down which groups it is member of. Add same groups in the member of tabs of users list provided in parameter DestinationUsers.
    .Example
    .\Copy-AdGroupMemberShip.ps1 -SourceUser Administrator -DestinationUsers (Get-Content C:\Userlist.txt)

    Users list can be provided into text file.
    .Example
    user1, user2, user3 | .\Copy-AdGroupMemberShip.ps1 -SourceUser Administrator

    .Notes
    NAME: Copy-AdGroupMemberShip
    AUTHOR: Kunal Udapi
    CREATIONDATE: 3 February 2019
    LASTEDIT: 4 February 2019
    KEYWORDS: Copy or clone source user's member of group to another user.
    .Link  
    #Check Online version: http://kunaludapi.blogspot.com
    #Check Online version: http://vcloud-lab.com
    #Requires -Version 3.0  
    #>  
#requires -Version 3   
[CmdletBinding()]
param
(  
    [Parameter(Mandatory=$true,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$true)]
    [alias('DestUser')]
    [String[]]$DestinationUsers,
    [String]$SourceUserGroup = 'Administrator') #param
Begin 
{  
    Import-Module ActiveDirectory
} #Begin

Process 
{
    try 
    {
        $sourceUserMemberOf = Get-AdUser $SourceUserGroup -Properties MemberOf -ErrorAction Stop
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
            [void](Get-ADUser $user -ErrorAction Stop)
            Write-Host -BackgroundColor DarkGreen -ForegroundColor White "...Tested user '$user' exist in AD"
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