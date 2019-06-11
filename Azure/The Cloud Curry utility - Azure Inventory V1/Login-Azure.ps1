<#
	.NOTES
	===========================================================================
	 Created on: 2019/06/03
	 Created by: Kunal udapi
	 GitHub link: kunaludapi	
	 Twitter: @kunaludapi
	 Url1: https://thecloudcurry.com
	 Url2: http://vcloud-lab.com
	===========================================================================
	.DEglobalION
		A deglobalion of the file.
#>
#region Episode 2 code
	#Get-Runspace | Select-Object -Property Id, Name, Type, State, Availability | Export-Csv -NoTypeInformation -Path C:\Temp\DefaultRunspaceList.csv

	if ((Test-Path "$env:TEMP\AzureInv") -eq $true)
	{	
		$timeNow =  [DateTime]::Now.DateTime.Replace(':', '-')
		Rename-Item "$env:TEMP\AzureInv" -NewName "$env:TEMP\AzureInv $timeNow"
		[void](New-Item "$env:TEMP\AzureInv" -ItemType Directory -Force)
	}
	else {
		[void](New-Item "$env:TEMP\AzureInv" -ItemType Directory -Force)
	}
	$azureInventoryLocation = (Get-Item "$env:TEMP\AzureInv" -ErrorAction Stop).FullName

	$script:ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path #$psscriptroot
	$images = Join-Path -Path $ScriptPath -ChildPath \images
	$SyncHash = $null

	function Get-XamlObject {
		[CmdletBinding()]
		param(
			[Parameter(Position = 0,
				Mandatory = $true,
				ValuefromPipelineByPropertyName = $true,
				ValuefromPipeline = $true)]
			[Alias("FullName")]
			[System.String[]]$Path
		)

		BEGIN
		{
			Set-StrictMode -Version Latest
			$expandedParams = $null
			$PSBoundParameters.GetEnumerator() | ForEach-Object { $expandedParams += ' -' + $_.key + ' '; $expandedParams += $_.value }
			Write-Verbose "Starting: $($MyInvocation.MyCommand.Name)$expandedParams"
			$output = @{}
			Add-Type -AssemblyName presentationframework, presentationcore
		} #BEGIN

		PROCESS {
			try
			{
				foreach ($xamlFile in $Path)
				{
					#Change content of Xaml file to be a set of powershell GUI objects
					$inputXML = Get-Content -Path $xamlFile -ErrorAction Stop
					[xml]$xaml = $inputXML -replace 'mc:Ignorable="d"', '' -replace "x:N", 'N' -replace 'x:Class=".*?"', '' -replace 'd:DesignHeight="\d*?"', '' -replace 'd:DesignWidth="\d*?"', ''
					$tempform = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml -ErrorAction Stop))

					#Grab named objects from tree and put in a flat structure using Xpath
					$namedNodes = $xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")
					$namedNodes | ForEach-Object {
						$output.Add($_.Name, $tempform.FindName($_.Name))
					} #foreach-object
				} #foreach xamlpath
			} #try
			catch
			{
				throw $error[0]
			} #catch
		} #PROCESS

		END
		{
			Write-Output $output
			Write-Verbose "Finished: $($MyInvocation.Mycommand)"
		} #END
	}
	$script:SyncHash = [hashtable]::Synchronized(@{})
	
	#Global Variable
	$script:SyncHash.APIVersion = '?api-version=2018-06-01'
	$script:SyncHash.ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
	$script:SyncHash.azureInventoryLocation = $azureInventoryLocation
	$script:SyncHash.Images = $images

	#$pathToLoginAzure = Join-Path 'D:\Projects\Azure Inventory Project\Azure Inventory v8\Azure Inventory' '\Azure Inventory' #$PSglobalRoot '\xaml'
	$pathToLoginAzure = Join-Path $ScriptPath '\xaml\Login-Azure'
	$script:SyncHash.pathToLoginAzure = $pathToLoginAzure
	
	#$pathToAzureInventory = Join-Path 'D:\Projects\Azure Inventory Project\Azure Inventory v8\Azure Inventory\Azure Inventory' '\Show-Inventory' #$PSglobalRoot '\xaml'
	$pathToAzureInventory = Join-Path $ScriptPath '\xaml\Show-Inventory'
	$script:SyncHash.pathToAzureInventory = $pathToAzureInventory

	#Load function into Sessionstate object for injection into runspace
	$ssGetXamlObject = Get-Content Function:\Get-XamlObject -ErrorAction Stop
	$ssfeGetXamlObject = New-Object System.Management.Automation.Runspaces.SessionStateFunctionEntry -ArgumentList 'Get-XamlObject', $ssGetXamlObject

	#Add Function to session state
	$InitialSessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
	$InitialSessionState.Commands.Add($ssfeGetXamlObject)
	
	$runspace = [runspacefactory]::CreateRunspace($InitialSessionState) #Add Session State to runspace at creation
	$powerShell = [powershell]::Create()
	$powerShell.runspace = $runspace
	$runspace.ThreadOptions = "ReuseThread" #Helps to prevent memory leaks, show runspace config in console
	$runspace.ApartmentState = "STA" #Needs to be in STA mode for WPF to work
	$runspace.Open()
	$runspace.SessionStateProxy.SetVariable('SyncHash',$SyncHash)

	[void]$PowerShell.AddScript({
		$SyncHash.loginAzureForm = Get-ChildItem -Path $SyncHash.pathToLoginAzure -Filter *.xaml -file | Where-Object { $_.Name -ne 'App.xaml' } | Get-XamlObject
		$SyncHash.loginAzureForm.GetEnumerator() | ForEach-Object {$SyncHash.loginAzureForm.Add($_.name,$_.value)} #Add all WPF objects to synchash variable

		$syncHash.showInventoryForm = Get-ChildItem -Path $SyncHash.pathToAzureInventory -Filter *.xaml -file | Where-Object { $_.Name -ne 'App.xaml' } | Get-XamlObject
		$SyncHash.showInventoryForm.GetEnumerator() | ForEach-Object {$SyncHash.showInventoryForm.Add($_.name,$_.value)} #Add all WPF objects to synchash variable

		$SyncHash.loginAzureForm.loginAzureFrame.NavigationService.Navigate($SyncHash.loginAzureForm.loginAzurePage) | Out-Null
		$SyncHash.loginAzureForm.imageLoginAzure.Source = "$($syncHash.Images)\Login-Form-Background.png"
		$SyncHash.loginAzureForm.Icon = "$($syncHash.Images)\Icon.ico"

		$SyncHash.Error = $error

		#Section Timer
		#We'll create a timer, this is for UI responsivness as Dispatcher.invoke is slow as a depressed slug!
		$updateBlock = {
			if ($SyncHash.WatchProgress -eq $true)
			{	
				$SyncHash.loginAzureForm.buttonInventory.isEnabled = $true #change here
				if ($syncHash.WatchRG -eq $true) 
				{
					$syncHash.showInventoryForm.statusInventoryProgressBar.IsIndeterminate = $true
					#$syncHash.showInventoryForm.textBlockLoginPageStatus.Text = 'Working on RGs'
					$syncHash.showInventoryForm.dataGridRg.ItemsSource = $syncHash.ResourceGroupCsvInfo | Select-Object Name, Location, @{ N = 'Tags'; E = { ($_.tags | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name) -join (', ') } }, ID
					$syncHash.showInventoryForm.textBlockRGsCount.Text = $syncHash.ResourceGroupCount
					$syncHash.showInventoryForm.textBlockLoginPageStatus.Text = 'Working on VMs'
				}
				if ($syncHash.WatchVM -eq $true)
				{
					$syncHash.showInventoryForm.dataGridVm.ItemsSource = $syncHash.VirtualMachineCsvInfo
					$syncHash.showInventoryForm.textBlockVMsCount.Text = $syncHash.VirtualMachineCount
					$syncHash.showInventoryForm.textBlockLoginPageStatus.Text = 'Working on vNet'
				}
				if ($syncHash.WatchvNet -eq $true)
				{
					$syncHash.showInventoryForm.dataGridvNet.ItemsSource = $syncHash.vNetCsvInfo
					$syncHash.showInventoryForm.textBlockvNetCount.Text = $syncHash.vNetCount
					$syncHash.showInventoryForm.textBlockLoginPageStatus.Text = 'Working on SubNets'
				}
				if ($syncHash.WatchSubnet -eq $true)
				{
					$syncHash.showInventoryForm.dataGridSubnet.ItemsSource = $syncHash.SubnetCsvInfo
					$syncHash.showInventoryForm.textBlockSubnetCount.Text = $syncHash.SubnetCount
					#$syncHash.showInventoryForm.textBlockLoginPageStatus.Text = 'Working on SubNets'
				}				
			}
			else 
			{
				$timer.Interval = [TimeSpan]"0:0:2.0"
				$syncHash.showInventoryForm.statusInventoryProgressBar.IsIndeterminate = $false
				#(Import-Csv c:\Temp\AllRunspace.csv | Where-Object {$_.runspaceStateInfo -eq 'Closed' -or  (($_.Id -gt 4) -and ($_.RunspaceAvailability -eq 'Available'))}).dispose()
				(Get-Runspace | Where-Object {$_.runspaceStateInfo -eq 'Closed' -or  (($_.Id -gt 4) -and ($_.RunspaceAvailability -eq 'Available'))}).dispose()
				$timer.Stop()
				$syncHash.showInventoryForm.textBlockLoginPageStatus.Text = 'Inventory completed'
				$syncHash.showInventoryForm.statusInventoryProgressBar.Value = 100
			}
		}

		$timer = New-Object System.Windows.Threading.DispatcherTimer
		# Which will fire 100 times every second        
		$timer.Interval = [TimeSpan]"0:0:0.01"
		# And will invoke the $updateBlock method         
		$timer.Add_Tick($updateBlock)
		# Now start the timer running        
		#$timer.Start()
		
		if ($timer.IsEnabled)
		{
			Write-Output 'UI timer started'
		}

		#(Get-Runspace).Where({$_.Id -ne 1 -and $_.Id -ne 2 -and $_.Id -ne 4}).Dispose()

		$syncHash.loginAzureForm.buttonLogin.add_Click({
			$syncHash.loginAzureForm.mainFormloginAzure.Topmost = $false
			function Get-BearerToken
			{
				[CmdletBinding()]
				param
				(
					[String]$AdTenant = $SyncHash.loginAzureForm.textBoxAzureADTenant.Text
				)
				$adal = "$($SyncHash.ScriptPath)\dll\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
				$adalforms = "$($SyncHash.ScriptPath)\dll\Microsoft.IdentityModel.Clients.ActiveDirectory.WindowsForms.dll"
				[void][System.Reflection.Assembly]::LoadFrom($adal)
				[void][System.Reflection.Assembly]::LoadFrom($adalforms)
				$global:AuthContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList "https://login.windows.net/$adTenant"
				$global:AuthResult = $AuthContext.AcquireToken('https://management.azure.com/', '1950a258-227b-4e31-a9cf-717495945fc2', 'urn:ietf:wg:oauth:2.0:oob', 'always')
				$AuthResult.CreateAuthorizationHeader()
			}
			try
			{
				$syncHash.loginAzureForm.textBoxSubscriptionId.IsReadOnly = $true
				$syncHash.loginAzureForm.StatusProgressBar.Value = 25
				$syncHash.AuthHeader = Get-BearerToken -ErrorAction Stop
				$syncHash.loginAzureForm.statusLoginTextBox.Text = 'Login Successful'
				$syncHash.loginAzureForm.statusLoginTextBox.Foreground = 'DarkGreen'
				$syncHash.loginAzureForm.StatusProgressBar.Value = 50
				$syncHash.loginAzureForm.buttonInventory.isEnabled = $true
				$syncHash.loginAzureForm.StatusProgressBar.Value = 100
				$syncHash.loginAzureForm.textBoxExpires.Text = "Azure session expires in next hour at $($authResult.ExpiresOn.LocalDateTime), Generate Inventory"
				$syncHash.loginAzureForm.buttonLogin.IsEnabled = $false
			}
			catch
			{
				$syncHash.loginAzureForm.textBoxSubscriptionId.IsReadOnly = $false
				$syncHash.loginAzureForm.statusLoginTextBox.Text = 'Login Failed'
				$syncHash.loginAzureForm.statusLoginTextBox.Foreground = 'DarkRed'
				$syncHash.loginAzureForm.buttonInventory.isEnabled = $false
				$syncHash.loginAzureForm.StatusProgressBar.Value = 0
			}
		})

	$syncHash.loginAzureForm.buttonInventory.add_Click({
		$syncHash.SubscriptionId = $syncHash.loginAzureForm.textBoxSubscriptionId.Text
		$timer.Start()
		$syncHash.loginAzureForm.textBoxSubscriptionId.IsReadOnly = $false
		
		$syncHash.loginAzureForm.mainFormloginAzure.Close()
		$syncHash.showInventoryForm.showInventorytFrame.NavigationService.Navigate($syncHash.showInventoryForm.showInventoryPage)
		$SyncHash.showInventoryForm.Icon = "$($syncHash.Images)\Icon.ico"
		$syncHash.showInventoryForm.mainFormShowInventory.Activate()
		$syncHash.showInventoryForm.textBoxSessionExpiresOn.Text = 'Session expires on: ' + $authResult.ExpiresOn.LocalDateTime
		$syncHash.showInventoryForm.textBlockTheCloudCurryurl.Text = 'User: ' + $AuthResult.UserInfo.DisplayableId
		
		$runspace = [runspacefactory]::CreateRunspace()
		$powerShell = [powershell]::Create()
		$powerShell.runspace = $runspace
		$runspace.ThreadOptions = 'ReuseThread'
		$runspace.ApartmentState = 'STA'
		$runspace.Open()
		$runspace.SessionStateProxy.SetVariable("SyncHash",$syncHash)
		$runspace.SessionStateProxy.SetVariable("AuthHeader",$SyncHash.AuthHeader)

		[void]$powershell.AddScript({
			$syncHash.WatchProgress = $true #Tell if statement in timer to run code
			$subscriptionid = $syncHash.SubscriptionId
			$AuthHeader = $SyncHash.AuthHeader
			$APIVersion = $SyncHash.APIVersion
			#Region Resource Group
			$syncHash.WatchRG = $true
			function Get-ResourceGroupInfo
			{
				[CmdletBinding()]
				param
				(
					[String]$AzureSubscriptionId = $syncHash.SubscriptionId,
					[String]$AuthHeader = $SyncHash.AuthHeader,
					[String]$APIVersion = $SyncHash.APIVersion
				)
				$SubscriptionURI = "https://management.azure.com/subscriptions/$AzureSubscriptionId/resourcegroups" + "$APIVersion"
				$params = @{
					ContentType = 'application/x-www-form-urlencoded'
					Headers	    = @{
						'authorization' = $AuthHeader
					}
					Method	    = 'Get'
					URI		    = $SubscriptionURI
				}
				Invoke-RestMethod @params | Select-Object -ExpandProperty value
			}

			Get-ResourceGroupInfo -AzureSubscriptionId $syncHash.SubscriptionId -AuthHeader $syncHash.AuthHeader -APIVersion $SyncHash.APIVersion <# -ErrorAction Stop #> | Export-Csv -Path "$($SyncHash.azureInventoryLocation)\1-ResourceGroupInfo.csv" -NoTypeInformation
			$syncHash.ResourceGroupCsvInfo = Import-Csv -Path "$($SyncHash.azureInventoryLocation)\1-ResourceGroupInfo.csv"
			$syncHash.ResourceGroupCount = $syncHash.ResourceGroupCsvInfo.Count
			Start-Sleep -Milliseconds 100
			$syncHash.WatchRG = $false
			#EndRegion

			function Get-AzureAPIInfo
			{
				[cmdletbinding()]
				param (
					[string]$AzureSubscriptionId = $syncHash.SubscriptionId,
					#= 'dd5636cb',    
			
					[string]$APIVersion = $syncHash.APIVersion,
					#= '?api-version=2018-06-01',
			
					[string]$ResourceName,
					#= 'providers/Microsoft.Compute/virtualMachines',
			
					[string]$ExtraInfo,
					[String]$AuthHeader = $SyncHash.AuthHeader
				)
				$SubscriptionURI = "https://management.azure.com/subscriptions/$AzureSubscriptionId/$ResourceName" + "$APIVersion" + "$ExtraInfo"
				$params = @{
					ContentType = 'application/x-www-form-urlencoded'
					Headers	    = @{
						'authorization' = $AuthHeader
					}
					Method	    = 'Get'
					URI		    = $SubscriptionURI
				}
				Invoke-RestMethod @params | Select-Object -ExpandProperty value
			}
			
			#Region Virutal Machine
			$vmParam = @{
				AzureSubscriptionId = $SyncHash.SubscriptionId
				AuthHeader = $SyncHash.AuthHeader
				APIVersion = $SyncHash.APIVersion
				ResourceName = 'providers/Microsoft.Compute/virtualMachines'
			}
			$allVirtualMachines = Get-AzureAPIInfo @vmParam
			
			$syncHash.VirtualMachineCsvInfo = @()
			foreach ($virtualMachineInfo in $allVirtualMachines)
			{
				#Get ResourceGroupName
				$resourceGroupUrl = "https://management.azure.com/subscriptions/$Subscriptionid/resourceGroups/" + ($virtualMachineInfo.id.split('/')[4]) + "/providers/Microsoft.Compute/virtualMachines/" + ($virtualMachineInfo.id.split("/")[8]) + "$APIVersion&`$expand=instanceView"
				$getResourceGroupUrl = Invoke-RestMethod -Header @{ 'authorization' = $authHeader } -URI $resourceGroupUrl -UserAgent 'application/json' -Method Get
				
				#Get Network Interfaces
				$networkInterfaceUrl = "https://management.azure.com" + $virtualMachineInfo.properties.networkprofile.networkinterfaces.id + "/$APIVersion"
				$getNetworkInterfaceUrl = Invoke-RestMethod -Header @{ 'authorization' = $authHeader } -URI $networkInterfaceurl -UserAgent 'application/json' -Method Get
				
				#Get PublicIP Config
				$publicIPUrl = "https://management.azure.com" + $getNetworkInterfaceUrl.properties.ipConfigurations.properties.publicIPAddress.id + "/$APIVersion"
				$getPublicIPUrl = Invoke-RestMethod -Header @{ 'authorization' = $authHeader } -URI $publicIPUrl -UserAgent 'application/json' -Method Get
				
				#osDisk Info
				$osDiskUrl = "https://management.azure.com" + $virtualMachineInfo.properties.storageProfile.osDisk.managedDisk.id + "/$APIVersion"
				try 
				{
					$getOsDiskUrl = Invoke-RestMethod -Header @{ 'authorization' = $authHeader } -URI $osDiskUrl -UserAgent 'application/json' -Method Get -ErrorAction Stop
					$diskSizeGB = $getOsDiskUrl.properties.diskSizeGB
				}
				catch
				{
					$diskSizeGB = $virtualMachineInfo.properties.storageProfile.osDisk.diskSizeGB
				}
				
				if ($null -ne $virtualMachineInfo.tags)
				{
					$vmTags = ($virtualMachineInfo.tags | Get-Member -MemberType NoteProperty).Name -join ', '
				}
				
				$primaryNicInterface = $getNetworkInterfaceUrl | Where-Object { $_.properties.ipConfigurations.properties.primary -eq $True }
				
				$syncHash.VirtualMachineCsvInfo += [pscustomobject]@{
					Name = $virtualMachineInfo.name
					PowerStatus = $getResourceGroupUrl.properties.instanceView.statuses[1].displayStatus
					ResourceGroup = $virtualMachineInfo.id.split('/')[4]
					ComputerName = $virtualMachineInfo.properties.osProfile.computerName
					Location = $virtualMachineInfo.Location
					AvailibilityZones = $virtualMachineInfo.zones -join (', ')
					VMHardwareSize = $virtualMachineInfo.properties.hardwareProfile.vmSize
					VMCreationTime = ([datetime]$getOsDiskUrl.properties.timeCreated).DateTime
					OsPublisher = $virtualMachineInfo.properties.storageProfile.imageReference.publisher
					OsOffer = $virtualMachineInfo.properties.storageProfile.imageReference.offer
					OsDiskSku = $virtualMachineInfo.properties.storageProfile.imageReference.sku
					OsVersion = $virtualMachineInfo.properties.storageProfile.imageReference.version
					TotalDisks = $getResourceGroupUrl.properties.instanceView.disks.Count
					AllDiskNames = $getResourceGroupUrl.properties.instanceView.disks.name -Join ', '
					OsType = $virtualMachineInfo.properties.storageProfile.osDisk.osType
					OsDiskName = $virtualMachineInfo.properties.storageProfile.osDisk.name
					OsDiskCreated = $virtualMachineInfo.properties.storageProfile.osDisk.createOption
					OsDiskCatching = $virtualMachineInfo.properties.storageProfile.osDisk.caching
					OsDiskSizeGB = $diskSizeGB
					OsDiskIOPSReadWrite = $getOsDiskUrl.properties.diskIOPSReadWrite
					OsMBpsReadWrite = $getOsDiskUrl.properties.diskMBpsReadWrite
					OsDiskState = $getOsDiskUrl.properties.diskState
					OsDiskRedundancy = $getOsDiskUrl.sku.name
					OsDiskTier = $getOsDiskUrl.sku.tier
					OsVhd = $virtualMachineInfo.properties.storageProfile.osDisk.vhd.uri
					AdminUserName = $virtualMachineInfo.properties.osProfile.adminUsername
					AutomaticUpdates = $virtualMachineInfo.properties.osProfile.windowsConfiguration.enableAutomaticUpdates
					ProvisionVMAgent = $virtualMachineInfo.properties.osProfile.windowsConfiguration.provisionVMAgent
					AllowExtensionOperations = $virtualMachineInfo.properties.osProfile.allowExtensionOperations
					TotalNics = $virtualMachineInfo.properties.networkProfile.networkInterfaces.id.count
					AllNicInterfaceNames = $getNetworkInterfaceUrl.name -Join ', '
					PrimaryNicInterface = $primaryNicInterface.name
					PrimaryNicInterfaceEtag = $primaryNicInterface.etag
					PrimaryNicIpConfig = $primaryNicInterface.properties.ipConfigurations.name
					PrimaryPrivateIpAddress = $primaryNicInterface.properties.ipConfigurations.properties.privateIPAddress
					PrimaryPrivateIPAllocationMethod = $primaryNicInterface.properties.ipConfigurations.properties.privateIPAllocationMethod
					PrimaryPrivateIPv = $primaryNicInterface.properties.ipConfigurations.properties.privateIPAddressVersion
					PrimaryNicMacAddress = $primaryNicInterface.properties.macAddress
					PrimaryNicNSG = $primaryNicInterface.properties.networkSecurityGroup.id.Split('/')[-1]
					PublicIpName = $getPublicIPUrl.name
					PublicIpConfName = $getPublicIPUrl.properties.ipConfiguration.id.Split('/')[-1]
					PublicIp = $getPublicIPUrl.properties.ipAddress
					PublicIpVersion = $getPublicIPUrl.properties.publicIPAddressVersion
					PublicIpAllocationMethod = $getPublicIPUrl.properties.publicIPAllocationMethod
					PublciIpIdleTimeOutInMin = $getPublicIPUrl.properties.idleTimeoutInMinutes
					PublicIpResourceGuid = $getPublicIPUrl.properties.resourceGuid
					PublicIpSkuName = $getPublicIPUrl.sku.name
					PublicIpSkuTier = $getPublicIPUrl.sku.tier
					EnableAcceleratedNetworking = $primaryNicInterface.properties.enableAcceleratedNetworking
					EnableIPForwarding = $primaryNicInterface.properties.enableIPForwarding
					NicDNSServers = $primaryNicInterface.properties.dnsSettings.dnsServers -join ', '
					NicAppliedDnsServers = $primaryNicInterface.properties.dnsSettings.appliedDnsServers -join ', '
					Tags = $vmTags
					BootDiagEnabled = $getResourceGroupUrl.properties.diagnosticsProfile.bootDiagnostics.enabled
					BootDiagStorageUri = $getResourceGroupUrl.properties.diagnosticsProfile.bootDiagnostics.storageUri
					BootDiagConsoleScreenshot = $getResourceGroupUrl.properties.instanceView.bootDiagnostics.consoleScreenshotBlobUri
					BootDiagSerialConsoleLogBlobUri = $getResourceGroupUrl.properties.instanceView.bootDiagnostics.serialConsoleLogBlobUri
					vmId = $virtualMachineInfo.properties.vmId
					Id   = $virtualMachineInfo.id
					type = $VirtualMachineInfo.type
				} 
			}
			$syncHash.WatchVM = $true
			$syncHash.VirtualMachineCsvInfo | Export-Csv -Path "$($SyncHash.azureInventoryLocation)\2-VirtualMachinesInfo.csv" -NoTypeInformation
			#$syncHash.VirtualMachineCsvInfo = Import-Csv -Path "$($SyncHash.azureInventoryLocation)\2-VirtualMachinesInfo.csv"
			$syncHash.VirtualMachineCount = $syncHash.VirtualMachineCsvInfo.Count
			Start-Sleep -Milliseconds 100
			$syncHash.WatchVM = $false
			#EndRegion

			#Region Virtual Network
			$vNetParam = @{
				AzureSubscriptionId = $SyncHash.SubscriptionId
				AuthHeader = $SyncHash.AuthHeader
				APIVersion = $SyncHash.APIVersion
				ResourceName = 'providers/Microsoft.Network/virtualNetworks'
			}
			$allvNet = Get-AzureAPIInfo @vNetParam
			
			$collectedSubnetInfo = @()
			$syncHash.vNetCsvInfo = @()
			foreach ($vNetInfo in $allvNet)
			{
				$collectedSubnetInfo += $vNetInfo.properties.subnets
				if ($null -eq $vNetInfo) 
				{
					($vNetInfo.tags | Get-Member -MemberType Properties).Name -join ', '
				}
				
				$syncHash.vNetCsvInfo += [pscustomobject]@{
					Name = $vNetInfo.name
					ResourceGroup = $vNetInfo.id.split('/')[4]
					Location = $vNetInfo.Location
					AddressPrefixes = $vNetInfo.properties.addressSpace.addressPrefixes -join ', '
					Subnets = $vNetInfo.properties.subnets.name -Join ', '
					DDosProtection = $vNetInfo.properties.enableDdosProtection
					VmProtection = $vNetInfo.properties.enableVmProtection
					vNetPeerings = $vNetInfo.properties.virtualNetworkPeerings.Name -join ', '
					Guid  = $vNetInfo.properties.resourceGuid
					Etag = $vNetInfo.etag
					Id = $vNetInfo.Id 
				} 
			}

			$syncHash.WatchvNet = $true
			$syncHash.vNetCsvInfo | Export-Csv -Path "$($SyncHash.azureInventoryLocation)\3-vNetInfo.csv" -NoTypeInformation
			#$syncHash.vNetCsvInfo = Import-Csv -Path "$($SyncHash.azureInventoryLocation)\3-vNetInfo.csv"
			$syncHash.vNetCount = $syncHash.vNetCsvInfo.Count
			Start-Sleep -Milliseconds 100
			$syncHash.WatchvNet = $false
			#EndRegion

			#Region Subnet
			$syncHash.SubnetCsvInfo = @()
			foreach ($subnetInfo in $collectedSubnetInfo) #$allSubnet)
			{
				$syncHash.SubnetCsvInfo += [pscustomobject]@{
					Name = $subnetInfo.name
					ResourceGroup = $subnetInfo.id.split('/')[4]
					ConnectedDevices = $subnetInfo.properties.ipConfigurations.id.foreach({$_.Split('/')[8]}) -Join ', '
					AddressPrefixes = $subnetInfo.properties.addressPrefix -join ', '
					IPConfigurations = ($subnetInfo.properties.ipConfigurations.id.foreach({$_.Split('/')[-1]}) | Sort-Object | Get-Unique) -join ', '
					etag = $subnetInfo.etag
					Id = $subnetInfo.id
				}
			}
			$syncHash.WatchSubnet = $true
			$syncHash.SubnetCsvInfo | Export-Csv -Path "$($SyncHash.azureInventoryLocation)\4-SubnetInfo.csv" -NoTypeInformation
			$syncHash.SubnetCount = $syncHash.SubnetCsvInfo.Count
			Start-Sleep -Milliseconds 100
			$syncHash.WatchSubnet = $false
			#EndRegion

			$syncHash.WatchProgress = $false
			#Get-Runspace | Select-Object Id, Name, RunspaceStateInfo, RunspaceAvailability | Export-Csv -Path c:\Temp\AllRunspace.csv -NoTypeInformation
		})
       
		$asyncObject = $PowerShell.BeginInvoke()
        $syncHash.showInventoryForm.mainFormShowInventory.ShowDialog()
		#(Get-Runspace).Where({$_.Id -ne 1 -and $_.Id -ne 2 -and $_.Id -ne 4}).Dispose()
        #(Get-Runspace).Where({$_.Id -ne 1}).Dispose()
	})

	#Region Menubar Functions
	function Save-CsvFile([string] $initialDirectory ) 
	{
	   [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
	   $openFileDialog = New-Object System.Windows.Forms.SaveFileDialog
	   $openFileDialog.initialDirectory = $initialDirectory
	   $openFileDialog.filter = "All files (*.csv)| *.csv"
	   $openFileDialog.ShowDialog() |  Out-Null
	   $openFileDialog.filename
	}

	function Save-XlsxFile([string] $initialDirectory ) 
	{
	   [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
	   $openFileDialog = New-Object System.Windows.Forms.SaveFileDialog
	   $openFileDialog.initialDirectory = $initialDirectory
	   $openFileDialog.filter = "All files (*.xlsx)| *.xlsx"
	   $openFileDialog.ShowDialog() |  Out-Null
	   $openFileDialog.filename
	}

	#EndRegion

	#Region Menubar Items

	$genUpdate = {
		if ($syncHash.GenXlsx -eq $true) 
		{
			$syncHash.showInventoryForm.statusInventoryProgressBar.IsIndeterminate = $true
			$syncHash.showInventoryForm.textBlockLoginPageStatus.Text = 'Generating Xlsx'
		}
		else 
		{
			$syncHash.showInventoryForm.statusInventoryProgressBar.IsIndeterminate = $false
			$syncHash.showInventoryForm.textBlockLoginPageStatus.Text = 'Xlsx created'
			$syncHash.showInventoryForm.statusInventoryProgressBar.Value = 100
			$xlsxTimer.Stop()
		}
	}

	$xlsxTimer = New-Object System.Windows.Threading.DispatcherTimer
	# Which will fire 100 times every second        
	$xlsxTimer.Interval = [TimeSpan]"0:0:0.01"
	# And will invoke the $updateBlock method         
	$xlsxTimer.Add_Tick($genUpdate)
	# Now start the timer running        
	#$timer.Start()

	$syncHash.showInventoryForm.exportToExcel.add_Click({
		$xlsxFile = Save-XlsxFile
		$xlsxTimer.Start()
		$runspace = [runspacefactory]::CreateRunspace()
		$powerShell = [powershell]::Create()
		$powerShell.runspace = $runspace
		$runspace.ThreadOptions = 'ReuseThread'
		$runspace.ApartmentState = 'STA'
		$runspace.Open()
		$runspace.SessionStateProxy.SetVariable("syncHash",$syncHash)
		$runspace.SessionStateProxy.SetVariable("xlsxFile",$xlsxFile)

		[void]$powershell.AddScript({
			$syncHash.GenXlsx = $true
			if ($xlsxFile -ne '')
			{
				Function Release-Ref ($ref)
				{
					([System.Runtime.InteropServices.Marshal]::ReleaseComObject(
					[System.__ComObject]$ref) -gt 0)
					[System.GC]::Collect()
					[System.GC]::WaitForPendingFinalizers()
				}
				$csvFiles = Get-ChildItem -Path $env:TEMP\AzureInv -Filter *.csv | Sort-Object -Property Name -Descending
				#$count = ($csvFiles.count -1)
				$excel = New-Object -ComObject Excel.Application
				$excel.DisplayAlerts = $false

				$workbook = $excel.Workbooks.Add()
				$totalWorkSheets = $workbook.worksheets.count
				if ($totalWorkSheets -gt 1) {
					2..$workbook.worksheets.count | ForEach-Object {$workbook.worksheets.Item(2).delete()}
					#$workbook.worksheets.Item(2).delete()
				}

				$i = 1
				ForEach ($csv in $csvFiles) {
					$workbook.worksheets.Add() | Out-Null
					$worksheet = $workbook.worksheets.Item(1)
					$worksheet.name = ($csv.BaseName -replace '\d-').Replace('Info','')

					$tempcsv = $excel.Workbooks.Open($csv.fullname)
					$tempsheet = $tempcsv.Worksheets.Item(1)
					$tempSheet.UsedRange.Copy() | Out-Null

					$worksheet.Paste()
					$tempcsv.close()

					$range = $worksheet.UsedRange
					$range.EntireColumn.Autofit() | out-null
					$i++
				} #ForEach

				$excel.Visible = $false

				$lastWorkSheet = $workbook.worksheets.count
				$workbook.worksheets.Item($lastWorkSheet).delete()
				$workbook.saveas($xlsxFile)
				$excel.quit()

				$a = Release-Ref($range)
			}
			& $xlsxFile
			$syncHash.GenXlsx = $false
		})
       
		$asyncObject = $PowerShell.BeginInvoke()
	})

	$syncHash.showInventoryForm.exportToCSV.add_Click({
		$csvFile = Save-CsvFile
		if ($csvFile -ne '')
		{
			switch ($syncHash.showInventoryForm.inventoryTabs.SelectedIndex)
			{
				0 {Copy-Item "$($SyncHash.azureInventoryLocation)\1-ResourceGroupInfo.csv" $csvFile -Force}
				1 {Copy-Item "$($SyncHash.azureInventoryLocation)\2-VirtualMachinesInfo.csv" $csvFile -Force}
				2 {Copy-Item "$($SyncHash.azureInventoryLocation)\3-vNetInfo.csv" $csvFile -Force}
				3 {Copy-Item "$($SyncHash.azureInventoryLocation)\4-SubnetInfo.csv" $csvFile -Force}
				4 {}
			}
			& $csvFile
		}
	})
	
	$syncHash.showInventoryForm.showRgs.Add_Click({
		$syncHash.showInventoryForm.inventoryTabs.SelectedIndex = 0
	})

	$syncHash.showInventoryForm.showVMs.Add_Click({
		$syncHash.showInventoryForm.inventoryTabs.SelectedIndex = 1
	})

	$syncHash.showInventoryForm.showvNets.Add_Click({
		$syncHash.showInventoryForm.inventoryTabs.SelectedIndex = 2
	})

	$syncHash.showInventoryForm.showvSubnets.Add_Click({
		$syncHash.showInventoryForm.inventoryTabs.SelectedIndex = 3
	})
	#EndRegion
	$syncHash.showInventoryForm.mainFormshowInventory.Add_Closing({
		Get-Process -Id (Get-Content "$env:TEMP\AzureInventoryPID.txt") | Stop-Process
	})

	$syncHash.loginAzureForm.mainFormloginAzure.Add_Closing({
		Get-Process -Id (Get-Content "$env:TEMP\AzureInventoryPID.txt") | Stop-Process
	})
	
	$syncHash.loginAzureForm.mainFormloginAzure.Topmost = $true
	$syncHash.loginAzureForm.mainFormloginAzure.ShowDialog() | Out-Null
})

$asyncObject = $powerShell.BeginInvoke()
#[void]$powershell.EndInvoke($asyncObject)
#$powershell.Runspace.Close()
#$powershell.Runspace.Dispose()
#(Get-Runspace).Where({$_.Id -ne 1 -and $_.Id -ne 2 -and $_.Id -ne 4}).Dispose()