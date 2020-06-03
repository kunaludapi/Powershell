#region PS Object Explorer Profile

Function Get-PSObjectExplorerProfile()
{
#View Menu
    #mnuWMIObjects_Click
    #mnuNetAssemblies_Click
    #mnuNetClasses_Click
    #mnuPSAliases_Click
    #mnuPSCommands_Click
    #mnuPSDrives_Click
    #mnuPSModules_Click
    #mnuPSVariables_Click
    #mnuWINFeature_Click
    #mnuWINProcess_Click
    #mnuWINService_Click
    #mnuTestCases_Click

#Options Menu
    mnuObjects_Click
    mnuStructs_Click
    mnuCollections_Click
    #mnuNulls_Click
    #mnuEmptyStrings_Click

#Some Objects

    #Add-Node (Get-VMHost) "Virtual Machine Host"
    #Add-Node (Get-VM) "Virtual Machines"
    #Add-Node (Get-VMSwitch) "Virtual Switches"

    #Add-Node (Get-ADForest) "ADForest"
    #Add-Node (Get-ADDomain) "ADDomain"
    #Add-Node (Get-ADUser -Filter *) "ADUsers"
    #Add-Node (Get-ADComputer -Filter *) "ADComputers"
    #Add-Node (Get-ADObject -Filter *) "ADObjects"

    #Add-Node New-Object Microsoft.SqlServer.Management.Smo.Server("(local)") "SQL Server"

}

#endregion

#region Assembly Types
Add-Type -AssemblyName System
Add-Type -AssemblyName System.IO
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
#endregion
#region Script Variables
#region PowerShell Object Browser Variables

#Hashtable to for POE TreeView Nodes
$Script:POETreeNodes=@{}
# Used to uniquely identify treeview nodes
[Int]$Script:POENextKey=0

#endregion
#region Script Variables WMI Win32 Classes

# Used to order WIN32 classes by name
$Script:WMIClasses = $Null

# Used to store most recently used 
$Script:WMIRootNode=$Null
$Script:WMICategoryNode=$Null
$Script:WMISubCategoryNode=$Null
#endregion
#region Script Variables Net Framework
# Used to store Net Assemblies root node
#$Script:NetAssembliesNode=$Null

# Used to store Net Assemblies
#$Script:NetAssemblies=$Null

# Used to store Net Assemblies attributes
#$Script:NetAssembliesToProcess=$Null
#$Script:NetAssemblyMaxClasses=$Null
#$Script:NetAssemblyClasses=$Null

# Used to store Net Classes root node
#$Script:NetClassesNode=$Null

# Used to store Net Classes
#$Script:NetClasses = $Null

# Used to store Net Classes attributes
#$Script:NetClassesProcessed = $Null
#$Script:NetClassIndex=$Null
#endregion
#region Script Variables PS Variables

# Used to test for PS Automatic Variables
$Script:IsPSAutoVariable = [Ordered]@{
                             "$"=$True;"?"=$True;"^"=$True;"_"=$True;
                             "args"=$True;"ConsoleFileName"=$True;"Error"=$True;
                             "Event"=$True;"EventArgs"=$True;"EventSubscriber"=$True;
                             "ExecutionContext"=$True;"False"=$True;"ForEach"=$True;
                             "Home"=$True;"Host"=$True;"Input"=$True;
                             "LASTEXITCODE"=$True;"Matches"=$True;"MyInvocation"=$True;
                             "NestedPromptLevel"=$True;"Null"=$True;"PID"=$True;
                             "Profile"=$True;"PSBoundParameters"=$True;"PSCmdlet"=$True;
                             "PSCommandPath"=$True;"PSCulture"=$True;"PSDebugContext"=$True;
                             "PSHome"=$True;"PSISE"=$True;"PSItem"=$True;"$PSScriptRoot"=$True;
                             "PSSenderInfo"=$True;"PSScriptRoot"=$True;"PSUICulture"=$True;
                             "PSUnsupportedConsoleApplications"=$True;
                             "PSVersionTable"=$True;"PWD"=$True;"ReportErrorShowExceptionClass"=$True;
                             "ReportErrorShowInnerException"=$True;"ReportErrorShowSource"=$True;
                             "ReportErrorShowStackTrace"=$True;"Sender"=$True;"ShellID"=$True;
                             "StackTrace"=$True;"This"=$True;"True"=$True;
                            }
# Used to test for PS Preference Variables
$Script:IsPSConfigVariable = [Ordered]@{
                               "ConfirmPreference"=$True;"DebugPreference"=$True;
                               "ErrorActionPreference"=$True;"ErrorView"=$True;
                               "FormatEnumerationLimit"=$True;
                               "LogCommandHealthEvent"=$True;"LogCommandLifecycleEvent"=$True;
                               "LogEngineHealthEvent"=$True;"LogEngineLifecycleEvent"=$True;
                               "LogProviderHealthEvent"=$True;"LogProviderLifecycleEvent"=$True;
                               "MaximumAliasCount"=$True;"MaximumDriveCount"=$True;
                               "MaximumErrorCount"=$True;"MaximumFunctionCount"=$True;
                               "MaximumHistoryCount"=$True;"MaximumVariableCount"=$True;
                               "OFS"=$True;"OutputEncoding"=$True;
                               "ProgressPreference"=$True;"PSDefaultParameterValues"=$True;
                               "PSEmailServer"=$True;"PSModuleAutoLoadingPreference"=$True;
                               "PSSessionApplicationName"=$True;"PSSessionConfigurationName"=$True;
                               "PSSessionOption"=$True;"VerbosePreference"=$True;
                               "WarningPreference"=$True;"WhatIfPreference"=$True;
                              }

# Used to test for PS Form Variables
$Script:IsPSFormVariable = @{
                               "Form"=$True;"MainMenu"=$True;
                               "mnuFile"=$True;"mnuExit"=$True;
                               "mnuView"=$True;
                               "mnuWMIObjects"=$True;"mnuSeparatorV1"=$True;
                               "mnuNetAssemblies"=$True;"mnuNetClasses"=$True;"mnuSeparatorV2"=$True;
                               "mnuPSAliases"=$True;"mnuPSCommands"=$True;"mnuPSDrives"=$True;
                               "mnuPSModules"=$True;"mnuPSVariables"=$True;"mnuSeparatorV3"=$True;
                               "mnuWINFeature"=$True;"mnuSeparatorV4"=$True;
                               "mnuWINProcess"=$True;"mnuWINService"=$True;"mnuSeparatorV5"=$True;
                               "mnuTestCases"=$True;
                               "mnuOptions"=$True;
                               "mnuObjects"=$True;"mnuStructs"=$True;"mnuSeparator4"=$True;
                               "mnuCollections"=$True;"mnuSeparator5"=$True;
                               "mnuNulls"=$True;"mnuEmptyStrings"=$True;"mnuSeparator6"=$True;
                               "mnuHelp"=$True;"mnuAbout"=$True;
                               "mnuStatus"=$True;
                               "SplitContainerInstance"=$True;"TabControl"=$True;
                               "TreeViewInstance"=$True;"StatusBarInstance"=$True;
                               "TabPageInstance"=$True;"ListViewInstance"=$True;
                               "TabPageClass"=$True;"ListViewClass"=$True;
                               "TabPageInterface"=$True;"SplitContainerInterface"=$True;
                               "TreeViewInterface"=$True;"ListViewInterface"=$True;"StatusBarInterface"=$True;
                               "TabPagePSObject"=$True;"TextBoxPSObject"=$True;
                               "TabPageValues"=$True;"TextBoxValues"=$True;
                               "TabPagePowerShell"=$True;"SplitContainerPowerShell"=$True;
                               "TextBoxPowerShell"=$True;"ButtonExecute"=$True;
                               "TextBoxOutput"=$True;"ButtonClear"=$True;
                               "TabPageWMIClasses"=$True;
                               "LabelComputers"=$True;"TextBoxComputers"=$True;
                               "LabelFilter"=$True;"TextBoxFilter"=$True;
                               "TimerNetClasses"=$True;
                            }

# Used to test for PS Script Variables
$Script:IsPSScriptVariable = @{
                               "WMIClasses"=$True;"WMIRootNode"=$True;
                               "WMICategoryNode"=$True;"WMISubCategoryNode"=$True;
                               "IsPSAutoVariable"=$True;"IsPSConfigVariable"=$True;
                               "IsPSFormVariable"=$True;"IsPSScriptVariable"=$True;
                               "IsValidMemberType"=$True;"IsValidPropertyType"=$True;
                               "IsBooleanValueType"=$True;"IsIntegerValueType"=$True;
                               "IsFloatingPointType"=$True;"IsCharactersType"=$True;
                               "IsDateTimeType"=$True;
                               "IsInstanceValueType"=$True;"IsPropertyValueType"=$True;
                               "POENextKey"=$True;"POETreeNodes"=$True;
                               "POEValues"=$True;
                              }

#region Script Variables Valid Method and Return Types
#Valid Types
$Script:IsValidMemberType  = @{"Property"=$True;"NoteProperty"=$True;
                             }
$Script:IsValidPropertyType= @{"{get;set;}"=$True;"{get;}"=$True;
                             }
$Script:IsBooleanValueType= @{
                               "bool"=$True;"boolean"=$True;"system.boolean"=$True;
                              }
$Script:IsIntegerValueType= @{
                               "byte"=$True;"system.byte"=$True;  
                               "sbyte"=$True;"system.sbyte"=$True;  
                               "uint16"=$True;"system.uint16"=$True;
                               "int16"=$True;"system.int16"=$True;
                               "uint32"=$True;"system.uint32"=$True;
                               "int32"=$True;"system.int32"=$True;
                               "int"=$True;"system.int"=$True;
                               "uint64"=$True;"system.uint64"=$True;
                               "int64"=$True;"system.int64"=$True;
                               "long"=$True;"system.long"=$True;
                               "intptr"=$True;"system.intptr"=$True;
                              }
$Script:IsFloatingPointType= @{
                               "single"=$True;"system.single"=$True;
                               "double"=$True;"system.double"=$True;
                               "decimal"=$True;"system.decimal"=$True;
                               "float"=$True;"system.float"=$True;
                              }
$Script:IsCharactersType=    @{
                               "char"=$True;"system.char"=$True;
                               "string"=$True;"system.string"=$True;
                               "guid"=$True;"system.guid"=$True;
                              }
$Script:IsDateTimeType=      @{
                               "datetime"=$True;"system.datetime"=$True;
                               "timespan"=$True;"system.timespan"=$True
                              }
$Script:IsInstanceValueType     = $Script:IsBooleanValueType +
                                  $Script:IsIntegerValueType +
                                  $Script:IsFloatingPointType+
                                  $Script:IsCharactersType
$Script:IsPropertyValueType     = $Script:IsBooleanValueType +
                                  $Script:IsIntegerValueType +
                                  $Script:IsFloatingPointType+
                                  $Script:IsCharactersType   +
                                  $Script:IsDateTimeType

$Script:POEValues               =""
#endregion

#endregion
#region Helper Functions

# Increments key to uniquely identify treeview nodes
Function Get-NextKey
{
  [CmdletBinding()] 
  [OutputType([String])]
  param ( 
    [String]$Name
  ) 
    Try
    {
        $Script:POENextKey++
        [String]$Script:POENextKey
    }
    Catch [System.Exception]
    {
        Write-Verbose "Get-NextKey Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Determines if Member Name is Valid
Function Get-IsValidMemberName
{
    [CmdletBinding()] 
    [OutputType([System.Boolean])]
    param ( 
        [Parameter(Mandatory=$true)]
        [String]$MemberName,
        [Parameter(Mandatory=$true)]
        [String]$TypeName
    )
    If ($MemberName -EQ "")
    {
        Return $False
    }
    ElseIf ($MemberName.Substring(0,1) -EQ "_")
    {
        Return $False
    }
    ElseIf ($MemberName.Contains("-"))
    {
        Return $False
    }
    ElseIf ($MemberName -EQ "SystemMessages")
    {
        Return $False
    }
    ElseIf ($MemberName -EQ "OleDBProviderSettings")
    {
        Return $False
    }
    Else
    {
        Return $True
    }
}

# Return boolean if object is Active Driectory Enitity
Function Get-IsActiveDirectoryEntity
{
  [CmdletBinding()] 
  [OutputType([Boolean])]
  param ( 
    [parameter(Mandatory=$True)] 
    [Object]$Object
  )
    Try
    {
        Return ($Object -Is [Microsoft.ActiveDirectory.Management.ADEntity])
    }
    Catch
    {
        Return $False
    }
}

# Return boolean if object is collection (has GetNumerator)
Function Get-IsCollection
{
  [CmdletBinding()] 
  [OutputType([Boolean])]
  param ( 
    [parameter(Mandatory=$True)] 
    [Object]$Object
  )
    $IsCollection = $False
    If($Object -NE $Null)
    {
        If (Get-IsActiveDirectoryEntity $Object)
        {
        }
        Else
        {
            $Members = Get-Member -InputObject $Object
            ForEach ($Member In $Members)
            {
                If ($Member.Name -EQ "GetEnumerator")            
                {
                    $IsCollection = $True
                    break
                }
            }
        }
    }
    $IsCollection
}
# Return boolean if object is collection (has Keys)
Function Get-IsHashTable
{
  [CmdletBinding()] 
  [OutputType([Boolean])]
  param ( 
    [parameter(Mandatory=$True)] 
    [Object]$Object
  )
    $IsHashTable = $False
    If($Object -NE $Null)
    {
        $Members = Get-Member -InputObject $Object
        ForEach ($Member In $Members)
        {
            If ($Member.Name -EQ "Keys")            
            {
                $IsHashtable = $True
                break
            }
        }
    }
    $IsHashTable
}

# Return boolean if object is collection (has GetNumerator)
Function Get-InstanceType
{
  [CmdletBinding()] 
  [OutputType([String])]
  param ( 
    [parameter(Mandatory=$True)] 
    [Object]$Object
  )
    Trap {Continue}
    $ObjectType=($Object.GetType()).FullName
    Write-Debug "Get-InstanceType ObjectType=$ObjectType"
    If ($Object -Is [System.ValueType])
    {
        If ($Object -Is [System.Boolean])
        {
            Write-Debug "Get-InstanceType Boolean"
            Return "Boolean"
        }
        ElseIf ($Script:IsInstanceValueType[$ObjectType])
        {
            Write-Debug "Get-InstanceType ValueType"
            Return "ValueType"
        }
        ElseIf ($Object -Is [System.Enum])
        {
            Write-Debug "Get-InstanceType Enum"
            Return "Enum"
        }
        Else
        {
            Write-Debug "Get-InstanceType Struct"
            Return "Struct"
        }
    }
    IF ($Object -Is [System.String])
    {
        Write-Debug "Get-InstanceType String"
        Return "String"
    }

    IF ($Object -Is [System.Management.Automation.PSCustomObject])
    {
        Write-Debug "Get-InstanceType PSObject"
        Return "PSObject"
    }
    If (Get-IsCollection $Object)
    {
        If ($Object -Is [System.Array])
        {
            Write-Debug "Get-InstanceType Array"
            Return "Array"
        }
        ElseIf (Get-IsHashTable $Object)
        {
            Write-Debug "Get-InstanceType HashTable"
            Return "HashTable"
        }
        Else
        {
            Write-Debug "Get-InstanceType Collection"
            Return "Collection"
        }
    }
    Else
    {
        Write-Debug "Get-InstanceType Object"
        Return "Object"
    }
}

# Return boolean if object is collection (has GetNumerator)
Function Get-PropertyReturnType
{
  [CmdletBinding()] 
  [OutputType([String])]
  param ( 
    [parameter(Mandatory=$True)] 
    [Object]$Object
  )
    $ObjectType=($Object.GetType()).FullName
    Write-Verbose "Get-PropertyReturnType ObjectType=$ObjectType"
    If ($Object -Is [System.ValueType])
    {
        If ($Object -Is [System.Boolean])
        {
            Write-Debug "Get-PropertyReturnType Boolean"
            Return "Boolean"
        }
        ElseIf ($Script:IsPropertyValueType[$ObjectType])
        {
            Write-Debug "Get-PropertyReturnType ValueType"
            Return "ValueType"
        }
        ElseIf ($Object -Is [System.Enum])
        {
            Write-Debug "Get-PropertyReturnType Enum"
            Return "Enum"
        }
        Else
        {
            Write-Debug "Get-PropertyReturnType Struct"
            Return "Struct"
        }
    }
    IF ($Object -Is [System.String])
    {
        Write-Debug "Get-PropertyReturnType String"
        Return "String"
    }
    If (Get-IsCollection $Object)
    {
        If ($Object -Is [System.Array])
        {
            Write-Debug "Get-PropertyReturnType Array"
            Return "Array"
        }
        ElseIf (Get-IsHashTable $Object)
        {
            Write-Debug "Get-PropertyReturnType HashTable"
            Return "HashTable"
        }
        Else
        {
            Write-Debug "Get-PropertyReturnType Collection"
            Return "Collection"
        }
    }
    Else
    {
        Write-Debug "Get-PropertyReturnType Object"
        Return "Object"
    }
}

# Gets instance name by trying various properties
Function Get-InstanceFriendlyName
{
  [CmdletBinding()] 
  [OutputType([string])]
  param ( 
    [parameter(Mandatory=$True)] 
    [Object]$Object
  )
    Write-Debug "Get-InstanceFriendlyName Type=$($Object.GetType().FullName)"
    If ($Object -Is [System.Enum])
    {
        return "[$(($Object.GetType()).FullName)]::$Object"
    }
    If ($Object -Is [System.ValueType] -OR
        $Object -Is [System.String]
        )
    {
        return "[$(($Object.GetType()).FullName)]$Object"
    }
    If ($Object -Is [System.Type])
    {
        return "[$($Object.FullName)]"
    }
    If (Get-IsCollection $Object)
    {
        If ($Object -Is [System.Array])
        {
            return "$(($Object.GetType()).FullName)"
        }
        Else
        {
            return "$(($Object.GetType()).FullName)"
        }
    }
    Trap { Continue }
    $Return=""
    $Return=$Object.Name
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.DisplayName
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.DeviceName
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.DeviceID
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.Text
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.Tag
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.Caption
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.Action
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.SameElement
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.Element
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.PartComponent
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.ASPScriptDefaultNamespace
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.Antecedent
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.Dependent
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.FullName
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.FullPath
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.CodeFragment
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.Key
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.ModuleName
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.Verb
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.ShareName
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.InstanceName
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.GetType()
    IF ($Return -NE "") { Return $Return}
}

# Gets object name by trying various properties
Function Get-PropertyFriendlyName
{
  [CmdletBinding()] 
  [OutputType([string])]
  param ( 
    [parameter(Mandatory=$True)] 
    [Object]$Object
  )
    Write-Debug "Get-PropertyFriendlyName Type=$($Object.GetType().FullName)"
    If ($Object -Is [System.Enum])
    {
        return "[$(($Object.GetType()).FullName)]::$Object"
    }
    If ($Object -Is [System.ValueType] -OR
        $Object -Is [System.String]
        )
    {
        return "[$(($Object.GetType()).Name)]$Object"
    }
    If ($Object -Is [System.Type])
    {
        return "[$($Object.FullName)]"
    }
    If (Get-IsCollection $Object)
    {
        If ($Object -Is [System.Array])
        {
            return "$(($Object.GetType()).Name).Count=$($Object.Count)"
        }
        Else
        {
            return "$(($Object.GetType()).Name).Count=$($Object.Count)"
        }
    }
    Trap { Continue }
    $Return=""
    $Return=$Object.Name
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.DisplayName
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.DeviceName
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.DeviceID
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.Text
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.Tag
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.Caption
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.Action
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.SameElement
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.Element
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.PartComponent
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.ASPScriptDefaultNamespace
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.Antecedent
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.Dependent
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.FullName
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.FullPath
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.CodeFragment
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.Key
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.ModuleName
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.Verb
    IF ($Return.Length -GT 0) { Return $Return}
    $Return=$Object.GetType()
    IF ($Return -NE "") { Return $Return}
}

#endregion

#Adds a treeview node for an object
Function Add-Node
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True,
                Position=0)] 
    [Object]$Object,
    [parameter(Mandatory=$False,
                Position=1)] 
    [String]$Name=(Get-InstanceFriendlyName $Object)
  ) 
    Try
    {
        Write-Debug "Add-Node $($Object.GetType()) $Name"
        Add-TreeNode $TreeViewInstance $Object $Name
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-Node Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Adds a treeview node for an object to an existing node
Function Add-TreeNode
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True,
                Position=0)] 
    [Object]$ParentNode,
    [parameter(Mandatory=$True,
                Position=1)] 
    [Object]$Object,
    [parameter(Mandatory=$False,
                Position=2)] 
    [String]$Name=(Get-InstanceFriendlyName $Object)
  ) 
    Try
    {
        Write-Debug "Add-TreeNode $($Object.GetType()) $Name"
        $Node=$ParentNode.Nodes.Add((Get-NextKey)+" "+$Name,$Name)
        $Node.Tag = $Object
        $Node
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-TreeNode Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Adds a treeview node for a collection to an existing node
Function Add-TreeNodes
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True,
                Position=0)] 
    [Object]$ParentNode,
    [parameter(Mandatory=$True,
                Position=1)] 
    [Object]$Objects,
    [parameter(Mandatory=$True,
                Position=2)] 
    [String]$Name
  ) 
    Try
    {
        Write-Debug "Add-TreeNodes"
        $Node=$ParentNode.Nodes.Add((Get-NextKey)+" "+$Name,$Name)
        $Node.Tag = $Objects
        ForEach($Object In $Objects)
        {
            $ChildNode =Add-TreeNode $Node $Object
        }
        $Node
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-TreeNodes Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Remove a treeview node
Function Remove-Node
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True,
                Position=0)] 
    [Object]$Node
  ) 
    Try
    {
        Write-Verbose "Remove-Node"
        IF ($Node -NE $Null)
        {
            Remove-TreeNode $Node
        }
    }
    Catch [System.Exception]
    {
        Write-Verbose "Remove-Node Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Remove a treeview node
Function Remove-TreeNode
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True,
                Position=0)] 
    [Object]$Node
  ) 
    Try
    {
        Write-Verbose "Remove-TreeNode"
        IF ($Node -NE $Null)
        {
            $Node.Nodes.Clear()
            $Node.Remove()
            Write-Verbose "Removed-TreeNode"
        }
    }
    Catch [System.Exception]
    {
        Write-Verbose "Remove-TreeNode Catch"
        Write-Verbose $_.Exception.Message
    }
}


#region WMIObjects

# Determines whether object is an WMI object
Function Get-IsWMIObject
{
  [CmdletBinding()] 
  [OutputType([string])]
  param ( 
    [parameter(Mandatory=$True)]
    [Object]$Object
  )
    Write-Debug "Get-IsWMIObject"
    Try
    {
        If($Object.IsWMIObject -EQ $True)
        {
            Return $True
        }
        Else
        {
            Return $False
        }
    }
    Catch
    {
        Return $False
    }   
}
# Determines whether a node is an WMI object type or an object
Function Get-WMIObjectType
{
  [CmdletBinding()] 
  [OutputType([string])]
  param ( 
    [parameter(Mandatory=$True)]
    [Object]$Object
  )
  Trap { Continue }
  If ($Object.IsWMIClass)
  {
    Return "WMIClass"
  }
  ElseIf ($Object.IsWMISubCategory)
  {
    Return "WMISubCategory"
  }
  ElseIf ($Object.IsWMICategory)
  {
    Return "WMICategory"
  }
  ElseIf ($Object.IsWMIRoot)
  {
    Return "WMIRoot"
  }
  Else
  {
    Return "Unknown Object"
  }
}
#Adds a treeview node for a WMI object type mode
Function Add-WMITreeNode
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True,
                Position=0)] 
    [Object]$TreeView,
    [parameter(Mandatory=$True,
                Position=1)] 
    [String]$Category,
    [parameter(Mandatory=$True,
                Position=2)] 
    [String]$SubCategory,
    [parameter(Mandatory=$True,
                Position=3)] 
    [String]$Class,
    [parameter(Mandatory=$True,
                Position=4)] 
    [String]$Description
  ) 
    [int]$PC = $Script:WMIClasses.Count / 4.80
    TRY
    {
        If ($Category -EQ "WMIRoot")  #WMIRoot
        {
            Write-Verbose "Add-WMITreeNode WMIRoot"
            Write-Progress -Activity "Adding WMI Root" -PercentComplete $PC -Status "Working ..."
            $PSObject = New-Object PSObject -Property ([Ordered]@{
                        Category="Win32 Classes"
                        Description="WMI Win32 Classes"
                        IsWMIObject=$True
                        IsWMIRoot=$True
                        })
            $Script:WMIRootNode = $TreeView.Nodes.Insert(0,((Get-NextKey)+" " +$PSObject.Category),$PSObject.Category)
            $Script:WMIRootNode.Tag = $PSObject
            $Script:WMIRootNode.EnsureVisible()
        }
        ElseIf ($SubCategory -EQ " ")  #WMICateogry
        {
            Write-Verbose "Add-WMITreeNode Category=$Category"
            Write-Progress -Activity "Adding Category $Category" -PercentComplete $PC -Status "Working ..."
            $PSOBject = New-Object PSObject -Property ([Ordered]@{
                        Category=$Category
                        Description=$Description
                        IsWMIObject=$True
                        IsWMICategory=$True
                        })
            $Script:WMICategoryNode = $Script:WMIRootNode.Nodes.Add(((Get-NextKey)+" " +$Category),$Category)
            $Script:WMICategoryNode.Tag = $PSObject
        }
        ElseIf ($Class -EQ " ")    #WMISubCategory
        {
            Write-Verbose "Add-WMITreeNode SubCategory=$SubCategory"
            Write-Progress -Activity "Adding SubCategory $SubCategory" -PercentComplete $PC -Status "Working ..."
            $PSOBject = New-Object PSObject -Property ([Ordered]@{
                        Category=$Category
                        SubCategory=$SubCategory
                        Description=$Description
                        IsWMIObject=$True
                        IsWMICategory=$False
                        IsWMISubCategory=$True
                        })
            $Script:WMISubCategoryNode = $Script:WMICategoryNode.Nodes.Add(((Get-NextKey)+" "+$SubCategory),$SubCategory)
            $Script:WMISubCategoryNode.Tag = $PSObject
        }
        Else                      #WMIClass
        {
            Write-Verbose "Add-WMITreeNode Class=$Class"
            Write-Progress -Activity "Adding Class $Class" -PercentComplete $PC -Status "Working ..."
            $PSOBject = New-Object PSObject -Property ([Ordered]@{
                        Category=$Category
                        SubCategory=$SubCategory
                        Class=$Class
                        Description=$Description
                        IsWMIObject=$True
                        IsWMICategory=$False
                        IsWMISubCategory=$False
                        IsWMIClass=$True
                        })
            $ClassNode = $Script:WMISubCategoryNode.Nodes.Add(((Get-NextKey)+" "+$Class),$Class)
            $ClassNode.Tag = $PSObject
            $Script:WMIClasses.Add($Class,$PSObject)
        }
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-WMITreeNode Catch"
        Write-Verbose $_.Exception.Message
    }
}
#Adds treeview nodes for WMI classes sort by Name
Function Add-WMITreeNodesOrderedByName
{
  [CmdletBinding()] 
  param ()
    [Double]$PCINC = (1/$Script:WMIClasses.Count) * 100
    [Double]$PC = 100
    TRY
    {
        Write-Verbose "Add-WMITreeNodesOrderedByName Adding Category"
        $SubCategory="WMI Classes By Name"
        $PSOBject = New-Object PSObject -Property ([Ordered]@{
                    Category=$SubCategory
                    SubCategory=$SubCategory
                    Description="WMI Classes sorted by Name."
                    IsWMIObject=$True
                    IsWMICategory=$False
                    IsWMISubCategory=$True
                    })
        Write-Progress -Activity "Adding sorted subcategory $SubCategory" -PercentComplete $PC -Status "Working ..."
        $SubCategoryNode = $Script:WMIRootNode.Nodes.Add(((Get-NextKey)+" "+$SubCategory),$SubCategory)
        $SubCategoryNode.Tag = $PSObject
        $SubCategoryNode

        Write-Verbose "Sorting WMIClasses"
        $Win32Classes = $Script:WMIClasses.GetEnumerator() | Sort -Property Key

        For ($I=0;$I -LT $WIN32classes.Count;$I++)
        {
           $PC=$PC-$PCINC 
           $Class=$Win32Classes[$I].Key
           Write-Progress -Activity "Adding sorted class $Class" -PercentComplete $PC -Status "Working ..."
           $ClassNode = $SubCategoryNode.Nodes.Add(((Get-NextKey)+" "+$Class),$Class)
           $ClassNode.Tag = $Win32Classes[$I].Value
        }
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-WMITreeNodesOrderedByName Catch"
        Write-Verbose $_.Exception.Message
    }
}
#Adds treeview nodes for WMI objects
Function Add-WMITreeNodes
{   
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True,
                Position=0)] 
    [Object]$TreeView
  ) 
    Try
    {
        Write-Verbose "Add-WMITreeNodes TreeView.Name=$($TreeView.Name)"
        Write-Progress -Activity "Adding WMIClasses" -PercentComplete 0 -Status "Working ..."
        $Script:WMIClasses = @{}
        Add-WMITreeNode $TreeView "WMIRoot" " " " " " "
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" " " " " "Hardware-related objects."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Cooling Device Classes" " " "The Cooling Devices subcategory groups classes that represent instrumentable fans, temperature probes, and refrigeration devices."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Cooling Device Classes" "Win32_Fan" "Represents the properties of a fan device in the computer system."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Cooling Device Classes" "Win32_HeatPipe" "Represents the properties of a heat pipe cooling device."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Cooling Device Classes" "Win32_Refrigeration" "Represents the properties of a refrigeration device."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Cooling Device Classes" "Win32_TemperatureProbe" "Represents the properties of a temperature sensor (electronic thermometer)."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Input Device Classes" " " "The Input Devices subcategory groups classes that represent keyboards and pointing devices."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Input Device Classes" "Win32_Keyboard" "Represents a keyboard installed on a computer system running Windows."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Input Device Classes" "Win32_PointingDevice" "Represents an input device used to point to and select regions on the display of a computer system running Windows."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Mass Storage Classes" " " "Classes in the Mass Storage subcategory represent storage devices such as hard disk drives, CD-ROM drives, and tape drives."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Mass Storage Classes" "Win32_AutochkSetting" "Represents the settings for the autocheck operation of a disk."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Mass Storage Classes" "Win32_CDROMDrive" "Represents a CD-ROM drive on a computer system running Windows."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Mass Storage Classes" "Win32_DiskDrive" "Represents a physical disk drive as seen by a computer running the Windows operating system."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Mass Storage Classes" "Win32_FloppyDrive" "Manages the capabilities of a floppy disk drive."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Mass Storage Classes" "Win32_PhysicalMedia" "Represents any type of documentation or storage medium."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Mass Storage Classes" "Win32_TapeDrive" "Represents a tape drive on a computer system running Windows."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" " " "The Motherboard, Controllers, and Ports subcategory groups classes that represent system devices. Examples include system memory, cache memory, and controllers."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_1394Controller" "Represents the capabilities and management of a 1394 controller."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_1394ControllerDevice" "Relates the high-speed serial bus (IEEE 1394 Firewire) Controller and the CIM_LogicalDevice instance connected to it."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_AllocatedResource" "Relates a logical device to a system resource."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_AssociatedProcessorMemory" "Relates a processor and its cache memory."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_BaseBoard" "Represents a baseboard (also known as a motherboard or system board)."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_BIOS" "Represents the attributes of the computer system's basic input or output services (BIOS) that are installed on the computer."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_Bus" "Represents a physical bus as seen by a Windows operating system."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_CacheMemory" "Represents cache memory (internal and external) on a computer system."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_ControllerHasHub" "Represents the hubs downstream from the universal serial bus (USB) controller."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_DeviceBus" "Relates a system bus and a logical device using the bus."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_DeviceMemoryAddress" "Represents a device memory address on a Windows system."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_DeviceSettings" "Relates a logical device and a setting that can be applied to it."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_DMAChannel" "Represents a direct memory access (DMA) channel on a computer system running Windows."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_FloppyController" "Represents the capabilities and management capacity of a floppy disk drive controller."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_IDEController" "Represents the capabilities of an Integrated Drive Electronics (IDE) controller device."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_IDEControllerDevice" "Association class that relates an IDE controller and the logical device."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_InfraredDevice" "Represents the capabilities and management of an infrared device."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_IRQResource" "Represents an interrupt request line (IRQ) number on a Windows computer system."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_MemoryArray" "Represents the properties of the computer system memory array and mapped addresses."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_MemoryArrayLocation" "Relates a logical memory array and the physical memory array upon which it exists."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_MemoryDevice" "Represents the properties of a computer system's memory device along with its associated mapped addresses."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_MemoryDeviceArray" "Relates a memory device and the memory array in which it resides."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_MemoryDeviceLocation" "Association class that relates a memory device and the physical memory on which it exists."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_MotherboardDevice" "Represents a device that contains the central components of the computer system running Windows."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_OnBoardDevice" "Represents common adapter devices built into the motherboard (system board)."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_ParallelPort" "Represents the properties of a parallel port on a computer system running Windows."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_PCMCIAController" "Manages the capabilities of a Personal Computer Memory Card Interface Adapter (PCMCIA) controller device."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_PhysicalMemory" "Represents a physical memory device located on a computer as available to the operating system."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_PhysicalMemoryArray" "Represents details about the computer system's physical memory."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_PhysicalMemoryLocation" "Relates an array of physical memory and its physical memory."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_PNPAllocatedResource" "Represents an association between logical devices and system resources."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_PNPDevice" "Relates a device (known to Configuration Manager as a PNPEntity), and the function it performs."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_PNPEntity" "Represents the properties of a Plug and Play device."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_PortConnector" "Represents physical connection ports, such as DB-25 pin male, Centronics, and PS/2."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_PortResource" "Represents an I/O port on a computer system running Windows."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_Processor" "Represents a device capable of interpreting a sequence of machine instructions on a computer system running Windows."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_SCSIController" "Represents a small computer system interface (SCSI) controller on a computer system running Windows."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_SCSIControllerDevice" "Relates a SCSI controller and the logical device (disk drive) connected to it."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_SerialPort" "Represents a serial port on a computer system running Windows."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_SerialPortConfiguration" "Represents the settings for data transmission on a Windows serial port."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_SerialPortSetting" "Relates a serial port and its configuration settings."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_SMBIOSMemory" "Represents the capabilities and management of memory-related logical devices."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_SoundDevice" "Represents the properties of a sound device on a computer system running Windows."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_SystemBIOS" "Relates a computer system (including data such as startup properties, time zones, boot configurations, or administrative passwords) and a system BIOS (services, languages, and system management properties)."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_SystemDriverPNPEntity" "Relates a Plug and Play device on the Windows computer system and the driver that supports the Plug and Play device."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_SystemEnclosure" "Represents the properties associated with a physical system enclosure."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_SystemMemoryResource" "Represents a system memory resource on a Windows system."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_SystemSlot" "Represents physical connection points including ports, motherboard slots and peripherals, and proprietary connections points."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_USBController" "Manages the capabilities of a universal serial bus (USB) controller."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_USBControllerDevice" "Relates a USB controller and the CIM_LogicalDevice instances connected to it."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Motherboard, Controller, and Port Classes" "Win32_USBHub" "Represents the management characteristics of a USB hub."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Networking Device Classes" " " "The Networking Devices subcategory groups classes that represent the network interface controller, its configurations, and its settings."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Networking Device Classes" "Win32_NetworkAdapter" "Represents a network adapter on a computer system running Windows."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Networking Device Classes" "Win32_NetworkAdapterConfiguration" "Represents the attributes and behaviors of a network adapter. The class is not guaranteed to be supported after the ratification of the Distributed Management Task Force (DMTF) CIM network specification."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Networking Device Classes" "Win32_NetworkAdapterSetting" "Relates a network adapter and its configuration settings."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Power Classes" " " "The Power subcategory groups classes that represent power supplies, batteries, and events related to these devices."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Power Classes" "Win32_AssociatedBattery" "Relates a logical device and the battery it is using."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Power Classes" "Win32_Battery" "Represents a battery connected to the computer system."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Power Classes" "Win32_CurrentProbe" "Represents the properties of a current monitoring sensor (ammeter)."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Power Classes" "Win32_PortableBattery" "Represents the properties of a portable battery, such as one used for a notebook computer."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Power Classes" "Win32_PowerManagementEvent" "Represents power management events resulting from power state changes."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Power Classes" "Win32_UninterruptiblePowerSupply" "Represents the capabilities and management capacity of an uninterruptible power supply (UPS)."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Power Classes" "Win32_VoltageProbe" "Represents the properties of a voltage sensor (electronic voltmeter)."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Printing Classes" " " "The Printing subcategory groups classes that represent printers, printer configurations, and print jobs."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Printing Classes" "Win32_DriverForDevice" "Relates a printer to a printer driver."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Printing Classes" "Win32_Printer" "Represents a device connected to a computer system running Windows that is capable of reproducing a visual image on a medium."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Printing Classes" "Win32_PrinterConfiguration" "Defines the configuration for a printer device."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Printing Classes" "Win32_PrinterController" "Relates a printer and the local device to which the printer is connected."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Printing Classes" "Win32_PrinterDriver" "Represents the drivers for a Win32_Printer instance."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Printing Classes" "Win32_PrinterDriverDll" "Relates a local printer and its driver file (not the driver itself)."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Printing Classes" "Win32_PrinterSetting" "Relates a printer and its configuration settings."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Printing Classes" "Win32_PrintJob" "Represents a print job generated by a Windows-based application."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Printing Classes" "Win32_TCPIPPrinterPort" "Represents a TCP/IP service access point."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Telephony Classes" " " "The Telephony subcategory groups classes that represent ""plain old telephone"" modem devices and their associated serial connections."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Telephony Classes" "Win32_POTSModem" "Represents the services and characteristics of a Plain Old Telephone Service (POTS) modem on a computer system running Windows."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Telephony Classes" "Win32_POTSModemToSerialPort" "Relates a modem and the serial port the modem uses."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Video and Monitor Classes" " " "The Video and Monitors subcategory groups classes that represent monitors, video cards, and their associated settings."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Video and Monitor Classes" "Win32_DesktopMonitor" "Represents the type of monitor or display device attached to the computer system."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Video and Monitor Classes" "Win32_DisplayConfiguration" "Represents configuration information for the display device on a computer system running Windows. This class is obsolete. In place of this class, use the properties in the Win32_VideoController, Win32_DesktopMonitor, and CIM_VideoControllerResolution classes."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Video and Monitor Classes" "Win32_DisplayControllerConfiguration" "Represents the video adapter configuration information of a computer system running Windows. This class is obsolete. In place of this class, use the properties in the Win32_VideoController, Win32_DesktopMonitor, and CIM_VideoControllerResolution classes."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Video and Monitor Classes" "Win32_VideoController" "Represents the capabilities and management capacity of the video controller on a computer system running Windows."
        Add-WMITreeNode $TreeView "Computer System Hardware Classes" "Video and Monitor Classes" "Win32_VideoSettings" "Relates a video controller and video settings that can be applied to it."
        Add-WMITreeNode $TreeView "Operating System Classes" " " " " "Operating system related objects."
        Add-WMITreeNode $TreeView "Operating System Classes" "Desktop" " " "The Desktop subcategory groups classes that represent objects that define a specific desktop configuration."
        Add-WMITreeNode $TreeView "Operating System Classes" "Desktop" "Win32_Desktop" "Represents the common characteristics of a user's desktop."
        Add-WMITreeNode $TreeView "Operating System Classes" "Desktop" "Win32_Environment" "Represents an environment or system environment setting on a computer system running Windows."
        Add-WMITreeNode $TreeView "Operating System Classes" "Desktop" "Win32_TimeZone" "Represents the time zone information for a computer system running Windows."
        Add-WMITreeNode $TreeView "Operating System Classes" "Desktop" "Win32_UserDesktop" "Relates a user account and the desktop settings that are specific to it."
        Add-WMITreeNode $TreeView "Operating System Classes" "Drivers" " " "The Drivers subcategory groups classes that represent virtual device drivers and system drivers for base services."
        Add-WMITreeNode $TreeView "Operating System Classes" "Drivers" "Win32_DriverVXD" "Represents a virtual device driver on a Windows computer system."
        Add-WMITreeNode $TreeView "Operating System Classes" "Drivers" "Win32_SystemDriver" "Represents the system driver for a base service."
        Add-WMITreeNode $TreeView "Operating System Classes" "File System" " " "The File System subcategory groups classes that represent the way a hard disk is logically arranged. This includes the type of file system used, the directory structure, and way the disk is partitioned."
        Add-WMITreeNode $TreeView "Operating System Classes" "File System" "Win32_CIMLogicalDeviceCIMDataFile" "Relates logical devices and data files, indicating the driver files used by the device."
        Add-WMITreeNode $TreeView "Operating System Classes" "File System" "Win32_Directory" "Represents a directory entry on a computer system running Windows."
        Add-WMITreeNode $TreeView "Operating System Classes" "File System" "Win32_DirectorySpecification" "Represents the directory layout for the product."
        Add-WMITreeNode $TreeView "Operating System Classes" "File System" "Win32_DiskDriveToDiskPartition" "Relates a disk drive and a partition existing on it."
        Add-WMITreeNode $TreeView "Operating System Classes" "File System" "Win32_DiskPartition" "Represents the capabilities and management capacity of a partitioned area of a physical disk on a computer system running Windows."
        Add-WMITreeNode $TreeView "Operating System Classes" "File System" "Win32_DiskQuota" "Tracks disk space usage for NTFS file system volumes."
        Add-WMITreeNode $TreeView "Operating System Classes" "File System" "Win32_LogicalDiskRootDirectory" "Relates a logical disk and its directory structure."
        Add-WMITreeNode $TreeView "Operating System Classes" "File System" "Win32_LogicalDiskToPartition" "Relates a logical disk drive and the disk partition it resides on."
        Add-WMITreeNode $TreeView "Operating System Classes" "File System" "Win32_OperatingSystemAutochkSetting" "Represents the association between a CIM_ManagedSystemElement instance and the settings defined for it."
        Add-WMITreeNode $TreeView "Operating System Classes" "File System" "Win32_QuotaSetting" "Contains setting information for disk quotas on a volume."
        Add-WMITreeNode $TreeView "Operating System Classes" "File System" "Win32_ShortcutFile" "Represents files that are shortcuts to other files, directories, and commands."
        Add-WMITreeNode $TreeView "Operating System Classes" "File System" "Win32_SubDirectory" "Relates a directory (folder) and one of its subdirectories (subfolders)."
        Add-WMITreeNode $TreeView "Operating System Classes" "File System" "Win32_SystemPartitions" "Relates a computer system and a disk partition on that system."
        Add-WMITreeNode $TreeView "Operating System Classes" "File System" "Win32_Volume" "Represents an area of storage on a hard disk."
        Add-WMITreeNode $TreeView "Operating System Classes" "File System" "Win32_VolumeQuota" "Relates a volume to the per volume quota settings."
        Add-WMITreeNode $TreeView "Operating System Classes" "File System" "Win32_VolumeQuotaSetting" "Relates disk quota settings with a specific disk volume."
        Add-WMITreeNode $TreeView "Operating System Classes" "File System" "Win32_VolumeUserQuota" "Relates per user quotas to quota-enabled volumes."
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_TypeLibraryAction" "Operating System Classes"
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_TypeLibraryAction" "Operating system related objects."
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" " " "Software-related objects."
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_ClassicCOMApplicationClasses" "Association class"
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_ClassicCOMApplicationClasses" "Relates a DCOM application and a COM component grouped under it."
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_ClassicCOMClass" "Represents the properties of a COM component."
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_ClassicCOMClassSettings" "Relates a COM class and the settings used to configure instances of the COM class."
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_ClientApplicationSetting" "Relates an executable and a DCOM application that contains the DCOM configuration options for the executable file."
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_COMApplication" "Represents a COM application."
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_COMApplicationClasses" "Relates a COM component and the COM application where it resides."
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_COMApplicationSettings" "Relates a DCOM application and its configuration settings."
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_COMClass" "Represents the properties of a COM component."
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_ComClassAutoEmulator" "Relates a COM class and another COM class that it automatically emulates."
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_ComClassEmulator" "Relates two versions of a COM class."
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_ComponentCategory" "Represents a component category."
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_COMSetting" "Represents the settings associated with a COM component or COM application."
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_DCOMApplication" "Represents the properties of a DCOM application."
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_DCOMApplicationAccessAllowedSetting" "Relates the Win32_DCOMApplication instance and the user security identifications (SID) that can access it."
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_DCOMApplicationLaunchAllowedSetting" "Relates the Win32_DCOMApplication instance and the user SIDs that can launch it."
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_DCOMApplicationSetting" "Represents the settings of a DCOM application."
        Add-WMITreeNode $TreeView "Operating System Classes" "Installed Applications Classes" "Win32_ImplementedCategory" "Relates a component category and the COM class using its interfaces."
        Add-WMITreeNode $TreeView "Operating System Classes" "Job Objects" " " "The Job Objects subcategory groups classes that represent classes that provide the means of instrumenting named job objects. An unnamed job object cannot be instrumented."
        Add-WMITreeNode $TreeView "Operating System Classes" "Job Objects" "Win32_CollectionStatistics" "Relates a managed system element collection and the class representing statistical information about the collection."
        Add-WMITreeNode $TreeView "Operating System Classes" "Job Objects" "Win32_LUID" "Represents a locally unique identifier (LUID)"
        Add-WMITreeNode $TreeView "Operating System Classes" "Job Objects" "Win32_LUIDandAttributes" "Represents a LUID and its attributes."
        Add-WMITreeNode $TreeView "Operating System Classes" "Job Objects" "Win32_NamedJobObject" "Represents a kernel object that is used to group processes for the sake of controlling the life and resources of the processes within the job object."
        Add-WMITreeNode $TreeView "Operating System Classes" "Job Objects" "Win32_NamedJobObjectActgInfo" "Represents the I/O accounting information for a job object."
        Add-WMITreeNode $TreeView "Operating System Classes" "Job Objects" "Win32_NamedJobObjectLimit" "Represents an association between a job object and the job object limit settings."
        Add-WMITreeNode $TreeView "Operating System Classes" "Job Objects" "Win32_NamedJobObjectLimitSetting" "Represents the limit settings for a job object."
        Add-WMITreeNode $TreeView "Operating System Classes" "Job Objects" "Win32_NamedJobObjectProcess" "Relates a job object and the process contained in the job object."
        Add-WMITreeNode $TreeView "Operating System Classes" "Job Objects" "Win32_NamedJobObjectSecLimit" "Relates a job object and the job object security limit settings."
        Add-WMITreeNode $TreeView "Operating System Classes" "Job Objects" "Win32_NamedJobObjectSecLimitSetting" "Represents the security limit settings for a job object."
        Add-WMITreeNode $TreeView "Operating System Classes" "Job Objects" "Win32_NamedJobObjectStatistics" "Represents an association between a job object and the job object I/O accounting information class."
        Add-WMITreeNode $TreeView "Operating System Classes" "Job Objects" "Win32_SIDandAttributes" "Represents a security identifier (SID) and its attributes."
        Add-WMITreeNode $TreeView "Operating System Classes" "Job Objects" "Win32_TokenGroups" "Represents information about the group SIDs in an access token."
        Add-WMITreeNode $TreeView "Operating System Classes" "Job Objects" "Win32_TokenPrivileges" "Represents information about a set of privileges for an access token."
        Add-WMITreeNode $TreeView "Operating System Classes" "Memory and Page Files" " " "The Memory and Page files subcategory groups classes that represent page file configuration settings."
        Add-WMITreeNode $TreeView "Operating System Classes" "Memory and Page Files" "Win32_LogicalMemoryConfiguration" "This class is obsolete and has been replaced by the Win32_OperatingSystem class."
        Add-WMITreeNode $TreeView "Operating System Classes" "Memory and Page Files" "Win32_PageFile" "Represents the file used for handling virtual memory file swapping on a Windows system."
        Add-WMITreeNode $TreeView "Operating System Classes" "Memory and Page Files" "Win32_PageFileElementSetting" "Relates the initial settings of a page file and the state of those settings during normal use."
        Add-WMITreeNode $TreeView "Operating System Classes" "Memory and Page Files" "Win32_PageFileSetting" "Represents the settings of a page file."
        Add-WMITreeNode $TreeView "Operating System Classes" "Memory and Page Files" "Win32_PageFileUsage" "Represents the file used for handling virtual memory file swapping on a computer system running Windows."
        Add-WMITreeNode $TreeView "Operating System Classes" "Memory and Page Files" "Win32_SystemLogicalMemoryConfiguration" "This class is obsolete because the properties existing in the Win32_LogicalMemoryConfiguration class are now a part of the Win32_OperatingSystem class."
        Add-WMITreeNode $TreeView "Operating System Classes" "Multimedia Audio or Visual" " " "The class in the Multimedia Audio or Visual subcategory represents properties of the audio or video codec installed on the computer system."
        Add-WMITreeNode $TreeView "Operating System Classes" "Multimedia Audio or Visual" "Win32_CodecFile" "Represents the audio or video codec installed on the computer system."
        Add-WMITreeNode $TreeView "Operating System Classes" "Networking" " " "The Networking subcategory groups classes that represent network connections, network clients, and network connection settings such as the protocol used."
        Add-WMITreeNode $TreeView "Operating System Classes" "Networking" "Win32_ActiveRoute" "Relates the current IP4 route to the persisted IP route table."
        Add-WMITreeNode $TreeView "Operating System Classes" "Networking" "Win32_IP4PersistedRouteTable" "Represents persisted IP routes."
        Add-WMITreeNode $TreeView "Operating System Classes" "Networking" "Win32_IP4RouteTable" "Represents information that governs the routing of network data packets."
        Add-WMITreeNode $TreeView "Operating System Classes" "Networking" "Win32_IP4RouteTableEvent" "Represents IP route change events."
        Add-WMITreeNode $TreeView "Operating System Classes" "Networking" "Win32_NetworkClient" "Represents a network client on a computer system running Windows."
        Add-WMITreeNode $TreeView "Operating System Classes" "Networking" "Win32_NetworkConnection" "Represents an active network connection in a Windows environment."
        Add-WMITreeNode $TreeView "Operating System Classes" "Networking" "Win32_NetworkProtocol" "Represents a protocol and its network characteristics on a computer system running Windows."
        Add-WMITreeNode $TreeView "Operating System Classes" "Networking" "Win32_NTDomain" "Represents a Windows NT domain."
        Add-WMITreeNode $TreeView "Operating System Classes" "Networking" "Win32_PingStatus" "Represents the values returned by the standard ping command."
        Add-WMITreeNode $TreeView "Operating System Classes" "Networking" "Win32_ProtocolBinding" "Relates a system-level driver, network protocol, and network adapter."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Events" " " "The Operating System Events subcategory groups classes that represent events in the operating system related to processes, threads, and system shutdown."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Events" "Win32_ComputerShutdownEvent" "Represents computer shutdown events."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Events" "Win32_ComputerSystemEvent" "Represents events related to a computer system."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Events" "Win32_DeviceChangeEvent" "Represents device change events resulting from the addition, removal, or modification of devices on the computer system."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Events" "Win32_ModuleLoadTrace" "Indicates that a process has loaded a new module."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Events" "Win32_ModuleTrace" "Base event for module events."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Events" "Win32_ProcessStartTrace" "Indicates that a new process has started."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Events" "Win32_ProcessStopTrace" "Indicates that a process has terminated."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Events" "Win32_ProcessTrace" "Base event for process events."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Events" "Win32_SystemConfigurationChangeEvent" "Indicates that the device list on the system has been refreshed (a device has been added or removed, or the configuration changed)."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Events" "Win32_SystemTrace" "Base class for all system trace events, including module, process, and thread traces."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Events" "Win32_ThreadStartTrace" "Indicates a new thread has started."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Events" "Win32_ThreadStopTrace" "Indicates that a thread has stopped."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Events" "Win32_ThreadTrace" "Base event class for thread events."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Events" "Win32_VolumeChangeEvent" "Represents a network-mapped drive event resulting from the addition of a network drive letter or mounted drive on the computer system."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" " " "The Operating System Settings subcategory groups classes that represent the Operating System and its settings."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_BootConfiguration" "Represents the boot configuration of a computer system running Windows."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_ComputerSystem" "Represents a computer system operating in a Windows environment."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_ComputerSystemProcessor" "Relates a computer system and a processor running on that system."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_ComputerSystemProduct" "Represents a product."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_DependentService" "Relates two interdependent base services."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_LoadOrderGroup" "Represents a group of system services that define execution dependencies."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_LoadOrderGroupServiceDependencies" "Represents an association between a base service and a load order group that the service depends on to start running."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_LoadOrderGroupServiceMembers" "Relates a load order group and a base service."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_OperatingSystem" "Represents an operating system installed on a computer system running Windows."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_OperatingSystemQFE" "Relates an operating system and product updates applied as represented in Win32_QuickFixEngineering."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_OSRecoveryConfiguration" "Represents the types of information that will be gathered from memory when the operating system fails."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_QuickFixEngineering" "Represents system-wide Quick Fix Engineering (QFE) or updates that have been applied to the current operating system."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_StartupCommand" "Represents a command that runs automatically when a user logs onto the computer system."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_SystemBootConfiguration" "Relates a computer system and its boot configuration."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_SystemDesktop" "Relates a computer system and its desktop configuration."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_SystemDevices" "Relates a computer system and a logical device installed on that system."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_SystemLoadOrderGroups" "Relates a computer system and a load order group."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_SystemNetworkConnections" "Relates a network connection and the computer system on which it resides."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_SystemOperatingSystem" "Relates a computer system and its operating system."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_SystemProcesses" "Relates a computer system and a process running on that system."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_SystemProgramGroups" "Relates a computer system and a logical program group."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_SystemResources" "Relates a system resource and the computer system it resides on."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_SystemServices" "Relates a computer system and a service program that exists on the system."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_SystemSetting" "Relates a computer system and a general setting on that system."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_SystemSystemDriver" "Relates a computer system and a system driver running on that computer system."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_SystemTimeZone" "Relates a computer system and a time zone."
        Add-WMITreeNode $TreeView "Operating System Classes" "Operating System Settings" "Win32_SystemUsers" "Relates a computer system and a user account on that system."
        Add-WMITreeNode $TreeView "Operating System Classes" "Processes" " " "The Processes subcategory groups classes that represent system processes and threads."
        Add-WMITreeNode $TreeView "Operating System Classes" "Processes" "Win32_Process" "Represents a sequence of events on a computer system running Windows."
        Add-WMITreeNode $TreeView "Operating System Classes" "Processes" "Win32_ProcessStartup" "Represents the startup configuration of a computer system running Windows."
        Add-WMITreeNode $TreeView "Operating System Classes" "Processes" "Win32_Thread" "Represents a thread of execution."
        Add-WMITreeNode $TreeView "Operating System Classes" "Registry" " " "The class in the Registry subcategory represents the contents of the Windows registry."
        Add-WMITreeNode $TreeView "Operating System Classes" "Registry" "Win32_Registry" "Represents the system registry on a computer system running Windows."
        Add-WMITreeNode $TreeView "Operating System Classes" "Scheduler Jobs" " " "The Scheduler Jobs subcategory groups classes that represent scheduled job settings."
        Add-WMITreeNode $TreeView "Operating System Classes" "Scheduler Jobs" "Win32_CurrentTime" "Represents an instance in time as component seconds, minutes, day of the week, and so on."
        Add-WMITreeNode $TreeView "Operating System Classes" "Scheduler Jobs" "Win32_ScheduledJob" "Represents a job scheduled using the Windows schedule service."
        Add-WMITreeNode $TreeView "Operating System Classes" "Scheduler Jobs" "Win32_LocalTime" "Represents a point in time returned as Win32_LocalTime objects that result from a query. The Hour property is returned as the local time in a 24-hour clock."
        Add-WMITreeNode $TreeView "Operating System Classes" "Scheduler Jobs" "Win32_UTCTime" "Represents a point in time that is returned as Win32_UTCTime objects that result from a query. The Hour property is returned as the coordinated universal time (UTC) time in a 24?hour clock."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" " " "The Security subcategory groups classes that represent system security settings."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_AccountSID" "Relates a security account instance with a security descriptor instance."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_ACE" "Represents an access control entry (ACE)."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_LogicalFileAccess" "Relates the security settings of a file or directory and one member of its discretionary access control list (DACL)."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_LogicalFileAuditing" "Relates the security settings of a file or directory one member of its system access control list (SACL)."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_LogicalFileGroup" "Relates the security settings of a file or directory and its group."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_LogicalFileOwner" "Relates the security settings of a file or directory and its owner."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_LogicalFileSecuritySetting" "Represents security settings for a logical file."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_LogicalShareAccess" "Relates the security settings of a share and one member of its DACL."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_LogicalShareAuditing" "Relates the security settings of a share and one member of its SACL."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_LogicalShareSecuritySetting" "Represents security settings for a logical file."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_PrivilegesStatus" "Represents information about the privileges required to complete an operation."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_SecurityDescriptor" "Represents a structural representation of a SECURITY_DESCRIPTOR."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_SecuritySetting" "Represents security settings for a managed element."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_SecuritySettingAccess" "Represents the rights granted and denied to a trustee for a given object."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_SecuritySettingAuditing" "Represents the auditing for a given trustee on a given object."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_SecuritySettingGroup" "Relates the security of an object and its group."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_SecuritySettingOfLogicalFile" "Represents security settings of a file or directory object."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_SecuritySettingOfLogicalShare" "Represents security settings of a shared object."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_SecuritySettingOfObject" "Relates an object to its security settings."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_SecuritySettingOwner" "Relates the security settings of an object and its owner."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_SID" "Represents an arbitrary SID."
        Add-WMITreeNode $TreeView "Operating System Classes" "Security" "Win32_Trustee" "Represents a trustee."
        Add-WMITreeNode $TreeView "Operating System Classes" "Services" " " "The Services subcategory groups classes that represent services and base services."
        Add-WMITreeNode $TreeView "Operating System Classes" "Services" "Win32_BaseService" "Represents executable objects that are installed in a registry database maintained by the Service Control Manager."
        Add-WMITreeNode $TreeView "Operating System Classes" "Services" "Win32_Service" "Represents a service on a computer system running Windows."
        Add-WMITreeNode $TreeView "Operating System Classes" "Shares" " " "The Shares subcategory groups classes that represent details of shared resources, such as printers and folders."
        Add-WMITreeNode $TreeView "Operating System Classes" "Shares" "Win32_DFSNode" "Represents a root or junction node of a domain-based or stand-alone distributed file system (DFS)."
        Add-WMITreeNode $TreeView "Operating System Classes" "Shares" "Win32_DFSNodeTarget" "Represents the relationship of a DFS node to one of its targets."
        Add-WMITreeNode $TreeView "Operating System Classes" "Shares" "Win32_DFSTarget" "Represents the target of a DFS node."
        Add-WMITreeNode $TreeView "Operating System Classes" "Shares" "Win32_ServerConnection" "Represents the connections made from a remote computer to a shared resource on the local computer."
        Add-WMITreeNode $TreeView "Operating System Classes" "Shares" "Win32_ServerSession" "Represents the sessions that are established with the local computer by users on a remote computer."
        Add-WMITreeNode $TreeView "Operating System Classes" "Shares" "Win32_ConnectionShare" "Relates a shared resource on the computer and the connection made to the shared resource."
        Add-WMITreeNode $TreeView "Operating System Classes" "Shares" "Win32_PrinterShare" "Relates a local printer and the share that represents it as it is viewed over a network."
        Add-WMITreeNode $TreeView "Operating System Classes" "Shares" "Win32_SessionConnection" "Represents an association between a session established with the local server by a user on a remote machine, and the connections that depend on the session."
        Add-WMITreeNode $TreeView "Operating System Classes" "Shares" "Win32_SessionProcess" "Represents an association between a logon session and the processes associated with that session."
        Add-WMITreeNode $TreeView "Operating System Classes" "Shares" "Win32_ShareToDirectory" "Relates a shared resource on the computer system and the directory to which it is mapped."
        Add-WMITreeNode $TreeView "Operating System Classes" "Shares" "Win32_Share" "Represents a shared resource on a computer system running Windows."
        Add-WMITreeNode $TreeView "Operating System Classes" "Start Menu" " " "The Start Menu subcategory groups classes that represent program groups."
        Add-WMITreeNode $TreeView "Operating System Classes" "Start Menu" "Win32_LogicalProgramGroup" "Represents a program group in a computer system running Windows."
        Add-WMITreeNode $TreeView "Operating System Classes" "Start Menu" "Win32_LogicalProgramGroupDirectory" "Relates logical program groups (groupings in the Start menu), and the file directories in which they are stored."
        Add-WMITreeNode $TreeView "Operating System Classes" "Start Menu" "Win32_LogicalProgramGroupItem" "Represents an element contained by a Win32_ProgramGroup instance, that is not itself another Win32_ProgramGroup instance."
        Add-WMITreeNode $TreeView "Operating System Classes" "Start Menu" "Win32_LogicalProgramGroupItemDataFile" "Relates the program group items of the Start menu, and the files in which they are stored."
        Add-WMITreeNode $TreeView "Operating System Classes" "Start Menu" "Win32_ProgramGroup" "Deprecated."
        Add-WMITreeNode $TreeView "Operating System Classes" "Start Menu" "Win32_ProgramGroup" "Represents a program group in a Windows computer system. This class has been deprecated in favor of the Win32_LogicalProgramGroup class."
        Add-WMITreeNode $TreeView "Operating System Classes" "Start Menu" "Win32_ProgramGroupContents" "Relates a program group order and an individual program group or item contained in it."
        Add-WMITreeNode $TreeView "Operating System Classes" "Start Menu" "Win32_ProgramGroupOrItem" "Represents a logical grouping of programs on the user's Start|Programs menu."
        Add-WMITreeNode $TreeView "Operating System Classes" "Storage" " " "The Users subcategory groups classes that represent storage information."
        Add-WMITreeNode $TreeView "Operating System Classes" "Storage" "Win32_ShadowBy" "Represents the association between a shadow copy and the provider that creates the shadow copy."
        Add-WMITreeNode $TreeView "Operating System Classes" "Storage" "Win32_ShadowContext" "Specifies how a shadow copy is to be created, queried, or deleted."
        Add-WMITreeNode $TreeView "Operating System Classes" "Storage" "Win32_ShadowCopy" "Represents a duplicate copy of the original volume at a previous time."
        Add-WMITreeNode $TreeView "Operating System Classes" "Storage" "Win32_ShadowDiffVolumeSupport" "Represents an association between a shadow copy provider and a storage volume."
        Add-WMITreeNode $TreeView "Operating System Classes" "Storage" "Win32_ShadowFor" "Represents an association between a shadow copy and the volume for which the shadow copy is created."
        Add-WMITreeNode $TreeView "Operating System Classes" "Storage" "Win32_ShadowOn" "Represents an association between a shadow copy and where the differential data is written."
        Add-WMITreeNode $TreeView "Operating System Classes" "Storage" "Win32_ShadowProvider" "Represents a component that creates and represents volume shadow copies."
        Add-WMITreeNode $TreeView "Operating System Classes" "Storage" "Win32_ShadowStorage" "Represents an association between a shadow copy and where the differential data is written."
        Add-WMITreeNode $TreeView "Operating System Classes" "Storage" "Win32_ShadowVolumeSupport" "Represents an association between a shadow copy provider with a supported volume."
        Add-WMITreeNode $TreeView "Operating System Classes" "Storage" "Win32_Volume" "Represents an area of storage on a hard disk."
        Add-WMITreeNode $TreeView "Operating System Classes" "Storage" "Win32_VolumeUserQuota" "Represents a volume to the per volume quota settings."
        Add-WMITreeNode $TreeView "Operating System Classes" "Users" " " "The Users subcategory groups classes that represent user account information, such as group membership details."
        Add-WMITreeNode $TreeView "Operating System Classes" "Users" "Win32_Account" "Represents information about user accounts and group accounts known to the computer system running Windows."
        Add-WMITreeNode $TreeView "Operating System Classes" "Users" "Win32_Group" "Represents data about a group account."
        Add-WMITreeNode $TreeView "Operating System Classes" "Users" "Win32_GroupInDomain" "Identifies the group accounts associated with a Windows NT domain."
        Add-WMITreeNode $TreeView "Operating System Classes" "Users" "Win32_GroupUser" "Relates a group and an account that is a member of that group."
        Add-WMITreeNode $TreeView "Operating System Classes" "Users" "Win32_LogonSession" "Describes the logon session or sessions associated with a user logged on to Windows."
        Add-WMITreeNode $TreeView "Operating System Classes" "Users" "Win32_LogonSessionMappedDisk" "Represents the mapped logical disks associated with the session."
        Add-WMITreeNode $TreeView "Operating System Classes" "Users" "Win32_NetworkLoginProfile" "Represents the network login information of a specific user on a computer system running Windows."
        Add-WMITreeNode $TreeView "Operating System Classes" "Users" "Win32_SystemAccount" "Represents a system account."
        Add-WMITreeNode $TreeView "Operating System Classes" "Users" "Win32_UserAccount" "Represents information about a user account on a computer system running Windows."
        Add-WMITreeNode $TreeView "Operating System Classes" "Users" "Win32_UserInDomain" "Relates a user account and a Windows NT domain."
        Add-WMITreeNode $TreeView "Operating System Classes" "Windows Event Log" " " "The Windows Event Log subcategory groups classes that represent events, event log entries, event log configuration settings, and so on."
        Add-WMITreeNode $TreeView "Operating System Classes" "Windows Event Log" "Win32_NTEventlogFile" "Represents data stored in a Windows Event log file."
        Add-WMITreeNode $TreeView "Operating System Classes" "Windows Event Log" "Win32_NTLogEvent" "Represents Windows events."
        Add-WMITreeNode $TreeView "Operating System Classes" "Windows Event Log" "Win32_NTLogEventComputer" "Relates instances of Win32_NTLogEvent and Win32_ComputerSystem."
        Add-WMITreeNode $TreeView "Operating System Classes" "Windows Event Log" "Win32_NTLogEventLog" "Relates instances of Win32_NTLogEvent and Win32_NTEventlogFile classes."
        Add-WMITreeNode $TreeView "Operating System Classes" "Windows Event Log" "Win32_NTLogEventUser" "Relates instances of Win32_NTLogEvent and Win32_UserAccount."
        Add-WMITreeNode $TreeView "Operating System Classes" "Windows Product Activation" " " "Windows Product Activation (WPA) is an antipiracy technology to reduce the casual copying of software."
        Add-WMITreeNode $TreeView "Operating System Classes" "Windows Product Activation" "Win32_ComputerSystemWindowsProductActivationSetting" "Relates instances of Win32_ComputerSystem and Win32_WindowsProductActivation."
        Add-WMITreeNode $TreeView "Operating System Classes" "Windows Product Activation" "Win32_Proxy" "Contains properties and methods to query and configure an Internet connection related to WPA."
        Add-WMITreeNode $TreeView "Operating System Classes" "Windows Product Activation" "Win32_WindowsProductActivation" "Contains properties and methods related to WPA."
        Add-WMITreeNode $TreeView "Performance Counter Classes" " " " " "Raw and calculated performance data from performance counters."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" " " "Formatted performance counter classes."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData" "Abstract base class for the formatted data classes."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_ASP_ActiveServerPages" "Performance counters for the Active Server Pages device on the computer system."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_ContentFilter_IndexingServiceFilter" "Performance information about an Indexing Service filter."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_ContentIndex_IndexingService" "Performance data about the state of the Indexing Service."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_InetInfo_InternetInformationServicesGlobal" "Performance counters that monitor Internet Information Services (the web service and the FTP service) as a whole."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_ISAPISearch_HttpIndexingService" "Performance counters that monitor the HTTP Indexing Service."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_MSDTC_DistributedTransactionCoordinator" "Performance counters for Microsoft Distributed Transaction Coordinator performance counters."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_NTFSDRV_SMTPNTFSStoreDriver" "Performance counters for the Exchange NTFS Store driver."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfDisk_LogicalDisk" "Performance counters that monitor logical partitions of a hard or fixed disk drive."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfDisk_PhysicalDisk" "Performance counters that monitor hard or fixed disk drives on a computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfNet_Browser" "Performance counters that measure the rates of announcements, enumerations, and other browser transmissions."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfNet_Redirector" "Performance counters that monitor network connections originating at the local computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfNet_Server" "Performance counters that monitor communications using the WINS Server service."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfNet_ServerWorkQueues" "Performance counters that monitor the length of the queues and objects in the queues."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfOS_Cache" "Performance counters that monitor the file system cache, an area of physical memory that stores recently used data as long as possible to permit access to the data without having to read from the disk."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfOS_Memory" "Performance counters that describe the behavior of physical and virtual memory on the computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfOS_Objects" "Performance counter for the objects contained by the operating system such as events, mutexes, processes, sections, semaphores, and threads."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfOS_PagingFile" "Performance counters that monitor the paging file(s) on the computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfOS_Processor" "Performance counters that measure aspects of processor activity."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfOS_System" "Performance counters that apply to more than one instance of a component processors on the computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfProc_FullImage_Costly" "Performance counters that monitor the virtual address usage of images executed by processes on the computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfProc_Image_Costly" "Performance counters that monitor the virtual address usage of images executed by processes on the computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfProc_JobObject" "Performance counters for the accounting and processor usage data collected by each active named job object."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfProc_JobObjectDetails" "Performance counters for information about the active processes that make up a job object."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfProc_Process" "Performance counters that monitor running application program and system processes."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfProc_ProcessAddressSpace_Costly" "Performance counters that monitor memory allocation and use for a selected process."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfProc_Thread" "Performance counters that measure aspects of thread behavior."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PerfProc_ThreadDetails_Costly" "Performance counters that measure aspects of thread behavior that are difficult or time-consuming to collect."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PSched_PSchedFlow" "Performance counters for flow statistics from the packet scheduler."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_PSched_PSchedPipe" "Performance counters for pipe statistics from the packet scheduler."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_RemoteAccess_RASPort" "Performance counters that monitor individual Remote Access Service ports of the RAS device on the computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_RemoteAccess_RASTotal" "Performance counters that combine values for all ports of the Remote Access service (RAS) device on the computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_RSVP_ACSRSVPInterfaces" "Performance counters for the number of local network interfaces visible to, and used by the RSVP service."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_RSVP_ACSRSVPService" "Performance counters for RSVP or ACS service."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_SMTPSVC_SMTPServer" "Performance counters specific to the SMTP Server."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_Spooler_PrintQueue" "Performance performance counters for a print queue."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_TapiSrv_Telephony" "Represents the telephony system."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_Tcpip_ICMP" "Performance counters that measure the rates at which messages are sent and received by using ICMP protocols."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_Tcpip_IP" "Performance counters that measure the rates at which IP datagrams are sent and received by using IP protocols."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_Tcpip_NBTConnection" "Performance counters that measure the rates at which bytes are sent and received over the NBT connection between the local computer and a remote computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_Tcpip_NetworkInterface" "Performance counters that measure the rates at which bytes and packets are sent and received over a TCP/IP network connection."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_Tcpip_TCP" "Performance counters that measure the rates at which TCP segments are sent and received by using the TCP protocol."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_Tcpip_UDP" "Performance counters that measure the rates at which UDP datagrams are sent and received by using the UDP protocol."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_TermService_TerminalServices" "Performance counters for terminal services summary information."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_TermService_TerminalServicesSession" "Performance counters for terminal services per-session resource monitoring."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Formatted Performance Counter Classes" "Win32_PerfFormattedData_W3SVC_WebService" "Performance counters specific to the World Wide Web Publishing Service."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" " " "Raw performance counter classes."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData" "Abstract base class for all concrete raw performance counter classes."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_ASP_ActiveServerPages" "Performance counters for the Active Server Pages device on the computer system."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_ContentFilter_IndexingServiceFilter" "Performance counters for an Indexing Service filter."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_ContentIndex_IndexingService" "Performance counters for the state of the Indexing Service."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_InetInfo_InternetInformationServicesGlobal" "Performance counters that monitor Internet Information Services (the web service and the FTP service) as a whole."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_ISAPISearch_HttpIndexingService" "Performance counters for the HTTP Indexing Service."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_MSDTC_DistributedTransactionCoordinator" "Performance counters for Microsoft Distributed Transaction Coordinator."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_NTFSDRV_SMTPNTFSStoreDriver" "Performance counters for global counters for the Exchange NTFS Store driver."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfDisk_LogicalDisk" "Performance counters that monitor logical partitions of a hard or fixed disk drive."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfDisk_PhysicalDisk" "Performance counters that monitor hard or fixed disk drives on a computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfNet_Browser" "Performance counters that measure the rates of announcements, enumerations, and other browser transmissions."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfNet_Redirector" "Performance counters that monitor network connections originating at the local computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfNet_Server" "Performance counters that monitor communications using the WINS Server service."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfNet_ServerWorkQueues" "Performance counters that monitor the length of the queues and objects in the queues."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfOS_Cache" "Performance counters that monitor the file system cache."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfOS_Memory" "Performance counters that describe the behavior of physical and virtual memory on the computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfOS_Objects" "Performance counters for objects contained by the operating system such as events, mutexes, processes, sections, semaphores, and threads."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfOS_PagingFile" "Performance counters that monitor the paging file(s) on the computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfOS_Processor" "Performance counters that measure aspects of processor activity."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfOS_System" "Performance counters that apply to more than one instance of a component processors on the computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfProc_FullImage_Costly" "Performance counters that monitor the virtual address usage of images executed by processes on the computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfProc_Image_Costly" "Performance counters that monitor the virtual address usage of images executed by processes on the computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfProc_JobObject" "Performance counters for the accounting and processor usage data collected by each active, named Job object."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfProc_JobObjectDetails" "Performance counters for the active processes that make up a Job object."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfProc_Process" "Performance counters that monitor running application program and system processes."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfProc_ProcessAddressSpace_Costly" "Performance counters that monitor memory allocation and use for a selected process."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfProc_Thread" "Performance counters that measure aspects of thread behavior."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PerfProc_ThreadDetails_Costly" "Performance counters that measure aspects of thread behavior that are difficult or time-consuming to collect."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PSched_PSchedFlow" "Performance counters for flow statistics from the packet scheduler."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_PSched_PSchedPipe" "Performance counters for pipe statistics from the packet scheduler."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_RemoteAccess_RASPort" "Performance counters that monitor individual Remote Access Service ports of the RAS device on the computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_RemoteAccess_RASTotal" "Performance counters that combine values for all ports of the Remote Access service (RAS) device on the computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_RSVP_ACSRSVPInterfaces" "Performance counters for local network interfaces visible to, and used by the RSVP service."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_RSVP_ACSRSVPService" "Performance counters for RSVP or ACS service."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_SMTPSVC_SMTPServer" "Performance counters specific to the SMTP server."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_Spooler_PrintQueue" "Performance counters for a print queue."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_TapiSrv_Telephony" "Performance counters for the telephony system."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_Tcpip_ICMP" "Performance counters that measure the rates at which messages are sent and received by using ICMP protocols."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_Tcpip_IP" "Performance counters that measure the rates at which IP datagrams are sent and received by using IP protocols."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_Tcpip_NBTConnection" "Performance counters that measure the rates at which bytes are sent and received over the NBT connection between the local computer and a remote computer."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_Tcpip_NetworkInterface" "Performance counters that measure the rates at which bytes and packets are sent and received over a TCP/IP network connection."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_Tcpip_TCP" "Performance counters that measure the rates at which TCP Segments are sent and received by using the TCP protocol."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_Tcpip_UDP" "Performance counters that measure the rates at which UDP datagrams are sent and received by using the UDP protocol."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_TermService_TerminalServices" "Performance counters for terminal services summary information."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_TermService_TerminalServicesSession" "Performance counters for terminal services per-session resource monitoring."
        Add-WMITreeNode $TreeView "Performance Counter Classes" "Raw Performance Counter Classes" "Win32_PerfRawData_W3SVC_WebService" "Performance counters specific to the World Wide Web Publishing Service."
        Add-WMITreeNode $TreeView "Software-related objects" " " " " "Software-related objects."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" " " "Software-related objects."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ActionCheck" "Relates a Windows Installer action with any locational information it requires."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ApplicationCommandLine" "Identifies a connection between an application and its command-line access point."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ApplicationService" "Represents any installed or advertised components or applications available on the system."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_Binary" "Represents binary information (such as bitmaps, icons, executable files, and so on) that are used by an installation."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_BindImageAction" "Binds each executable file that must be bound to the DLLs imported by it."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_CheckCheck" "Relates an Installer action with any locational information it requires."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ClassInfoAction" "Manages the registration of COM class information with the system."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_CommandLineAccess" "Represents the command line interface to a service or application."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_Condition" "Represents the criteria used to determine the selection state of any entry in the Win32_Feature class."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_CreateFolderAction" "Creates an empty folder for components set to be installed locally."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_DuplicateFileAction" "Creates one or more copies of files installed by the InstallFiles executable action, either to a different directory than the original file, or to the same directory, but with a different name."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_EnvironmentSpecification" "Contains information about any environment variables that must be registered for their associated products installation."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ExtensionInfoAction" "Manages the registration of extension related information with the system."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_FileSpecification" "Represents a source file with its various attributes, ordered by a unique, non-localized identifier."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_FontInfoAction" "Registers installed fonts with the system."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_IniFileSpecification" "Contains the .INI information that the application needs to set in an .ini file."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_InstalledSoftwareElement" "Identifies the computer system on which a particular software element is installed."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_LaunchCondition" "Contains a list of conditions, all of which must be satisfied for the action to succeed."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ManagedSystemElementResource" "Relates an Installer feature with an action used to register and publish the feature."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_MIMEInfoAction" "Registers the MIME-related registry information with the system."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_MoveFileAction" "Locates files that already exist on the user's computer, and move or copy those files to a new location."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_MSIResource" "Represents any resource used by the Installer during the course of an installation or update."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ODBCAttribute" "Represents attributes that are set off an ODBC driver."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ODBCDataSourceAttribute" "Relates an Installer check with any setting information it requires."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ODBCDataSourceSpecification" "Specifies any data source (DSN) that must be registered as part of an installation."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ODBCDriverAttribute" "Relates an Installer check with any setting information it requires."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ODBCDriverSoftwareElement" "Determines the software element of which the ODBC driver is a part."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ODBCDriverSpecification" "Represents any ODBC driver to be installed as part of a particular product."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ODBCSourceAttribute" "Represents attributes set for an ODBC data source."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ODBCTranslatorSpecification" "Represents any ODBC translator that is included as part of a product installation."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_Patch" "Represents an individual update that is to be applied to a particular file and whose source resides at a specified location."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_PatchFile" "Relates an Installer check with any setting information it requires."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_PatchPackage" "Describes an update package that has been applied to this product."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_Product" "Represents a product as it is installed by Windows Installer."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ProductCheck" "Relates instances of CIM_Check and Win32_Product."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ProductResource" "Relates instances of Win32_Product and Win32_MSIResource."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ProductSoftwareFeatures" "Identifies the software features for a particular product."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ProgIDSpecification" "Represents any ProgID that must be registered during a given installation."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_Property" "Contains the property names and values for all defined properties in the installation."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_PublishComponentAction" "Manages the advertisement of the components that may be faulted in by other products with the system."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_RegistryAction" "Configures registry information that the application desires in the system registry."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_RemoveFileAction" "Uninstalls files previously installed by the InstallFiles action."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_RemoveIniAction" "Deletes .ini file information that the application desires to delete."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ReserveCost" "Reserves a specified amount of disk space in any directory, depending on the installation state of a component."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_SelfRegModuleAction" "Processes all the modules in the SelfReg module to register the modules, if installed."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ServiceControl" "Represents instructions for controlling both installed and uninstalled services."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ServiceSpecification" "Represents a service to be installed along with an associated package."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ServiceSpecificationService" "Represents instances of Win32_ServiceSpecification and Win32_Service."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_SettingCheck" "Relates an Installer check with any setting information it requires."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ShortcutAction" "Manages the creation of shortcuts."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_ShortcutSAP" "Identifies a connection between an application access point and the corresponding shortcut."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_SoftwareElement" "Represents a software element, part of a software feature."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_SoftwareElementAction" "Relates an Installer software element with an action that access the element."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_SoftwareElementCheck" "Relates an Installer element with any condition or locational information that a feature may require."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_SoftwareElementCondition" "Represents conditional checks that must be evaluated to TRUE before their associated Win32_SoftwareElement instance can be installed."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_SoftwareElementResource" "Relates a software element with a resource used by that software element."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_SoftwareFeature" "Represents a distinct subset of a product, consisting of one or more software elements."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_SoftwareFeatureAction" "Relates an Installer feature with an action used to register and publish the feature."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_SoftwareFeatureCheck" "Relates an Installer feature with any condition or locational information that a feature may require."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_SoftwareFeatureParent" "Establishes dependency relationships between objects."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_SoftwareFeatureSoftwareElements" "Identifies the software elements that make up a particular software feature."
        Add-WMITreeNode $TreeView "Software-related objects" "Installed Applications Classes" "Win32_TypeLibraryAction" "Registers type libraries with the system."
        Add-WMITreeNode $TreeView "WMI Service Management Classes" " " " " "Management for WMI."
        Add-WMITreeNode $TreeView "WMI Service Management Classes" "WMI Management Classes" " " "The WMI management classes represent operational parameters for the WMI service."
        Add-WMITreeNode $TreeView "WMI Service Management Classes" "WMI Management Classes" "Win32_WMISetting" "Contains the operational parameters for the WMI service."
        Add-WMITreeNode $TreeView "WMI Service Management Classes" "WMI Management Classes" "Win32_WMIElementSetting" "Association between a service running in the Windows system, and the WMI settings it can use."

        Add-WMITreeNodesOrderedByName

        Write-Progress -Activity "Added WMIClasses" -Status "Done" -Completed 
    }
    Catch
    {
        Write-Verbose "Add-WMITreeNodes Catch"
        Write-Verbose $_.Exception.Message
    }
}
#Adds WMI Category Listitems for a WMI Root
Function Fill-ListViewWMIRoot()
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True)]
    [System.Windows.Forms.ListView]$ListView,
    [parameter(Mandatory=$True)] 
    [Object]$NodeWMIRoot
  )
    Write-Verbose "Fill-ListViewWMIRoot"
    Try
    {
        Clear-ListView $ListView
        $ListView.View = [System.Windows.Forms.View]::Details
        $Column=$ListView.Columns.Add("Category")
        $Column.Width=$ListView.Width *.40
        $Column=$ListView.Columns.Add("Description")
        $Column.Width=$ListView.Width *.59
        ForEach($Node in $NodeWMIRoot.Nodes)
        {

            $Item=$ListView.Items.Add($Node.Tag.Category)
            $Item.SubItems.Add($Node.Tag.Description)
        }
    }
    Catch [System.Exception]
    {
        Write-Verbose "Fill-ListViewWMIRoot Catch"
        Write-Verbose $_.Exception.Message
    }
}
#Adds WMI SubCategory Listitems for a WMI Category
Function Fill-ListViewWMICategory()
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True)]
    [System.Windows.Forms.ListView]$ListView,
    [parameter(Mandatory=$True)] 
    [Object]$NodeCategory
  )
    Write-Verbose "Fill-ListViewCategory"
    Try
    {
        Clear-ListView $ListView
        $ListView.View = [System.Windows.Forms.View]::Details
        $Column=$ListView.Columns.Add("SubCategory")
        $Column.Width=$ListView.Width *.40
        $Column=$ListView.Columns.Add("Description")
        $Column.Width=$ListView.Width *.59
        ForEach($Node in $NodeCategory.Nodes)
        {

            $Item=$ListView.Items.Add($Node.Tag.SubCategory)
            $Item.SubItems.Add($Node.Tag.Description)
        }
    }
    Catch [System.Exception]
    {
        Write-Verbose "Fill-ListViewCategory Catch"
        Write-Verbose $_.Exception.Message
    }
}
#Adds WMI Class Listitems for a WMI SubCategory
Function Fill-ListViewWMISubCategory()
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True)]
    [System.Windows.Forms.ListView]$ListView,
    [parameter(Mandatory=$True)] 
    [Object]$NodeSubCategory
  )
    Write-Verbose "Fill-ListViewSubCategory"
    Try
    {
        Clear-ListView $ListView
        $ListView.View = [System.Windows.Forms.View]::Details
        $Column=$ListView.Columns.Add("Class")
        $Column.Width=$ListView.Width *.40
        $Column=$ListView.Columns.Add("Description")
        $Column.Width=$ListView.Width *.59
        ForEach($Node in $NodeSubCategory.Nodes)
        {

           $Item=$ListView.Items.Add($Node.Tag.Class)
           $Item.SubItems.Add($Node.Tag.Description)
        }
    }
    Catch [System.Exception]
    {
        Write-Verbose $_.Exception.Message
    }
}
#Adds a WMI Object Listitem for a WMI Class
Function Fill-ListViewWMIClass()
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True)]
    [System.Windows.Forms.ListView]$ListView,
    [parameter(Mandatory=$True)] 
    [object]$NodeClass,
    [parameter(Mandatory=$True)] 
    [int]$Count,
    [parameter(Mandatory=$True)] 
    [string]$Name
  )
    Write-Verbose "Fill-ListViewWMIClass"
    Try
    {
        $Item=$ListView.Items.Add($Node.Tag.Class+"["+$Count+"]")
        $Item.SubItems.Add($Name)
    }
    Catch [System.Exception]
    {
        Write-Verbose "Fill-ListViewWMIClass Catch"
        Write-Verbose $_.Exception.Message
    }
}
#Process A WMIObject Instance
Function Process-WMIObjectInstance
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.TreeView]$TreeView,
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)] 
        [System.Windows.Forms.StatusBar]$StatusBar,
        [Parameter(Mandatory=$true)] 
        [Object]$Node
     )
    Write-Verbose "Process-WMIObjectInstance"
    $NodeType=Get-WMIObjectType $Node.Tag
    If ($NodeType -EQ "WMIRoot")
    {
        Write-Verbose "Process-WMIObjectInstance WMIRoot"
        Fill-ListViewWMIRoot $ListView $Node
        Fill-ListViewClass $ListViewClass $Node.Tag
        $TextBoxPSObject.Text = ""
        $StatusBar.Text = $Node.Tag.Description
    }
    ElseIf ($NodeType -EQ "WMICategory")
    {
        Write-Verbose "Process-WMIObjectInstance WMICategory"
        Fill-ListViewWMICategory $ListView $Node
        Fill-ListViewClass $ListViewClass $Node.Tag
        $TextBoxPSObject.Text = ""
        $StatusBar.Text = $Node.Tag.Description
    }
    ElseIf ($NodeType -EQ "WMISubCategory")
    {
        Write-Verbose "Process-WMIObjectInstance WMISubCategory"
        Fill-ListViewWMISubCategory $ListView $Node
        Fill-ListViewClass $ListViewClass $Node.Tag
        $TextBoxPSObject.Text = ""
        $StatusBar.Text = $Node.Tag.Description
    }
    ElseIf ($NodeType -EQ "WMIClass")
    {
        Write-Verbose "Process-WMIObjectInstance WMIClass"
        Clear-ListView $ListView
        $ListView.View = [System.Windows.Forms.View]::Details
        $Column=$ListView.Columns.Add("Instance")
        $Column.Width=$ListView.Width *.45
        $Column=$ListView.Columns.Add("Value")
        $Column.Width=$ListView.Width *.54
        $Node.Nodes.Clear()
        $StatusBar.Text = "Retrieving "+ $Node.Tag.Class +" classes"
        $Objects = Get-WmiObject -Class $Sender.SelectedNode.Text -Computer $TextBoxComputers.Text -Filter $TextBoxFilter.Text
        $Key=""
        $Count=0
        ForEach($Object in $Objects)
        {
            $StatusBar.Text = "Retrieving "+ $Node.Tag.Class +"[" + $Count +"]"
            $Name = Get-InstanceFriendlyName $Object
            $NewNode=$Node.Nodes.Add((Get-NextKey)+" "+$Name,$Name)
            $NewNode.Tag = $Object
            Fill-ListViewWMIClass $ListView $Node $Count $Name
            $Count++
        }
        Fill-ListViewClass $ListViewClass $Node.Tag
        $TextBoxPSObject.Text = ""
        $StatusBar.Text = $Node.Tag.Description
    }
}

#endregion
#region Net Assemblies

#Adds Net Assemblies
Function Add-NetAssemblies
{
    [CmdletBinding()] 
    param()
    Try
    {
        Write-Verbose "Add-NetAssemblies"
        $NetAssemblies=New-Object System.Collections.SortedList
        $Assemblies = [appdomain]::CurrentDomain.GetAssemblies()
        $ProgressCounter = 0
        $ProgressIncrement = 100 / $Assemblies.Count
        ForEach ($Assembly in $Assemblies)
        {
            $AssemblyName=$($Assembly.FullName).Split(",")[0]
            Write-Progress -Activity "Adding Assembly $AssemblyName" -PercentComplete $ProgressCounter -Status "Working ..."
            $ProgressCounter += $ProgressIncrement
            IF ($NetAssemblies[$AssemblyName] -EQ $Null)
            {
                $NetAssemblies.Add($AssemblyName,$Assembly)
            }
        }
        Write-Progress -Activity "Added PS Assemblies" -Status "Done" -Completed 
        $NetAssemblies
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-NetAssemblies Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Adds Net Assemblies node
Function Add-NetAssembliesNode
{
    [CmdletBinding()] 
    param ( [parameter(Mandatory=$True,Position=0)] 
            [System.Windows.Forms.TreeView]$TreeView
    ) 
    Try
    {
        Write-Verbose "Add-NetAssembliesNode"
        $NetAssemblies = Add-NetAssemblies
        $Index=0
        IF ($mnuWMIObjects.Checked) {$Index++}
        $Node = $TreeView.Nodes.Insert($Index,((Get-NextKey)+" " +".Net Assemblies"),".Net Assemblies")
        $Node.Tag = $NetAssemblies
        $Node.EnsureVisible()
        $Node
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-NetAssembliesNode Catch"
        Write-Verbose $_.Exception.Message
    }
}

#endregion
#region Net Classes
#Adds Net Assemblies For Net Classes
Function Add-NetClassAssemblies
{
    [CmdletBinding()] 
    param()
    Try
    {
        Write-Verbose "Add-NetClassAssemblies"
        If ($Script:POETreeNodes["NetAsssembliesList"] -NE $Null)
        {
        }
        Else
        {
            $NetAssemblies=@{}
            $NetAssemblyMaxClasses=0
            $NetAssemblyClasses=0
            $Assemblies = [appdomain]::CurrentDomain.GetAssemblies()
            $ProgressCounter = 0
            $ProgressIncrement = 100 / $Assemblies.Count
            ForEach ($Assembly in $Assemblies)
            {
                $AssemblyName=$Assembly.FullName.Split(",")[0]
                Write-Progress -Activity "Adding Assembly $AssemblyName" -PercentComplete $ProgressCounter -Status "Working ..."
                $ProgressCounter += $ProgressIncrement
                IF ($NetAssemblies[$AssemblyName] -EQ $Null)
                {
                    $NetAssemblies.Add($AssemblyName,$Assembly)
                    $AssemblyClasses=$Assembly.ExportedTypes
                    $AssemblyClassesCount = $AssemblyClasses.Count
                }
                Else
                {
                    $AssemblyClassesCount=0
                }
                IF ($AssemblyClassesCount -GT $NetAssemblyMaxClasses)
                {
                    $NetAssemblyMaxClasses = $AssemblyClassesCount
                }
                $NetAssemblyClasses += $AssemblyClassesCount 
            }
            Write-Progress -Activity "Added PS Assemblies" -Status "Done" -Completed 
            $Script:POETreeNodes.Add("NetAssemblyMaxClasses",$NetAssemblyMaxClasses)
            $Script:POETreeNodes.Add("NetAssemblyClasses",$NetAssemblyClasses)
            $NetAssemblies
        }
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-NetClassAssemblies Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Adds Net Classes
Function Add-NetClasses
{
    [CmdletBinding()] 
    param(
        [Object]$ClassList,
        [String]$ClassName,
        [Object]$Class
    )
    Try
    {
       $Position = $ClassName.IndexOf(".")
       IF ($Position -GT 0)
       {  
          $ClassFirst = $ClassName.Substring(0,$Position)
          If ($ClassList.Count -GT 0)
          {
              $NewClassList = $ClassList[$ClassFirst]
              If ($NewClassList -EQ $Null)
              {
                 $NewClassList = New-Object System.Collections.SortedList
                 $ClassList.Add($ClassFirst,$NewClassList)
              }
          }
          Else
          {
              $NewClassList = New-Object System.Collections.SortedList
              IF ($ClassList -EQ $Null)
              {
              }
              Else
              {
                $ClassList.Add($ClassFirst,$NewClassList)
              }
          }
          $ClassRest  = $ClassName.Substring($Position+1)
          Add-NetClasses $NewClassList $ClassRest $Class
       }     
       Else
       {
          If ($ClassList[$ClassName] -EQ $Null)
          {
             $ClassList.Add($Class.FullName,$Class)
          }
       }
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-NetClasses Catch"
        Write-Verbose $_.Exception.Message
    }
}
Function Add-SomeNetClasses
{
    [CmdletBinding()] 
    param ( [parameter(Mandatory=$True,Position=0)]
            [Int]$Index
    )
    Try
    {
        Write-Verbose "Add-SomeNetClasses Index=$Index"
        $NetClasses=$Script:POETreeNodes["NetClassesList"]
        $NetAssembliesToProcess=$Script:POETreeNodes["NetAssembliesToProcess"]
        $NetClassesProcessed=$Script:POETreeNodes["NetClassesProcessed"]
        $KeysToProcess=$NetAssembliesToProcess.Keys
        $Keys=@()
        ForEach($Key in $KeysToProcess)
        {
            $Keys += $Key
        }
        For ($I=0; $I -LT $Keys.Count;$I++)
        {
            $Key=$Keys[$I]
            $Assembly=$NetAssembliesToProcess[$Key]
            $Classes=$Assembly.ExportedTypes
            $Count=$Classes.Count
            If($Index -LT $Count)
            {
                $Class = $Classes[$Index]
                $NetClassesProcessed++
                IF($Class.IsPublic)
                {
                    $FullName = $Class.FullName
                    IF (($FullName.Contains("_")) -OR
                        ($FullName.Contains("XamlGeneratedNamespace"))
                       )
                    {
                    }
                    Else
                    {
                        IF ($FullName.Contains("``"))
                        {
                            IF ($FullName.Contains("Collections"))
                            {
                                Add-NetClasses $NetClasses $FullName $Class
                            }
                        }
                        Else
                        {
                            Add-NetClasses $NetClasses $FullName $Class
                        }
                    }
                }
            }
            Else
            {
                $NetAssembliesToProcess.Remove($Key)
            }
        }
        $Script:POETreeNodes["NetClassesProcessed"]=$NetClassesProcessed
    }
    Catch
    {
        Write-Verbose "Add-SomeNetClasses Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Add adding Net Classes node
Function Add-NetClassesNode
{
    [CmdletBinding()] 
    param ( [parameter(Mandatory=$True,Position=0)] 
            [System.Windows.Forms.TreeView]$TreeView
    ) 
    Try
    {
        Write-Verbose "Add-NetClassesNode"
        $NetClassesNode = $Script:POETreeNodes["NetClasses"]
        IF ($NetClassesNode -EQ $Null)
        {
            $NetClasses=New-Object System.Collections.SortedList
            $NetAssembliesToProcess = Add-NetClassAssemblies
            $NetClassIndex=[int]0
            $NetClassesProcessed=[int]0
            $Script:POETreeNodes.Add("NetClassesList",$NetClasses)
            $Script:POETreeNodes.Add("NetClassIndex",$NetClassIndex)
            $Script:POETreeNodes.Add("NetAssembliesToProcess",$NetAssembliesToProcess)
            $Script:POETreeNodes.Add("NetClassesProcessed",$NetClassesProcessed)
        }
        $Index=0
        IF ($mnuWMIObjects.Checked) {$Index++}
        IF ($mnuNetAssemblies.Checked) {$Index++}
        $NetClassesNode = $TreeView.Nodes.Insert($Index,((Get-NextKey)+" " +".Net Classes"),".Net Classes")
        $NetClassesNode.Tag = $NetClasses
        $NetClassesNode.EnsureVisible()
        $NetClassesNode
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-NetClassesNodes Catch"
        Write-Verbose $_.Exception.Message
    }
}
#endregion
#region PS Aliases

#Adds a PS Alias
Function Add-PSAlias
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True,
                Position=0)] 
    [Object]$Alias,
    [parameter(Mandatory=$True,
                Position=1)] 
    [Object]$PSAliasesByAlias,
    [parameter(Mandatory=$True,
                Position=2)] 
    [Object]$PSAliasesByCommand
  ) 
    TRY
    {
        Write-Verbose "Add-PSAlias Alias.Name=$($Alias.Name)"
        If ($Alias)  #Not Null
        {
            $AliasName = $Alias.Name
            $Space = $AliasName.PadRight(25-$AliasName.Length)
            $Definition = $Alias.Definition
            $Name = $Space+$Definition
            $PSAliasesByAlias.Add($Name,$Alias)

            $AliasName = $Alias.Name
            $Definition = $Alias.Definition
            $Space = $Definition.PadRight(50-$Definition.Length)
            $Name = $Space+$AliasName
            $PSAliasesByCommand.Add($Name,$Alias)
        }

    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-PSAlias Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Adds PS Aliases
Function Add-PSAliases
{
    [CmdletBinding()] 
    param () 
    Try
    {
        Write-Verbose "Add-PSAliases"
        $PSAliases=[ordered]@{}
        $PSAliasesByAlias=New-Object System.Collections.SortedList
        $PSAliasesByCommand=New-Object System.Collections.SortedList
        $Aliases = Get-Alias 
        $ProgressCounter = 0
        $ProgressIncrement = 100 / $Aliases.Count
        For($I=0;$I -LT $Aliases.Count;$I++)
        {
           $Alias=$Aliases[$I]
           Write-Progress -Activity "Adding Alias $Alias" -PercentComplete $ProgressCounter -Status "Working ..."
           $ProgressCounter += $ProgressIncrement
           $AliasNode = Add-PSAlias $Alias $PSAliasesByAlias $PSAliasesByCommand
        }
        Write-Progress -Activity "Added PS Aliases" -Status "Done" -Completed 
        $PSAliases.Add("By Alias",$PSAliasesByAlias)
        $PSAliases.Add("By Command",$PSAliasesByCommand)
        $PSAliases
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-PSAliases Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Add TreeView node for PS Aliases
Function Add-PSAliasesNode
{
    [CmdletBinding()] 
    param ( [parameter(Mandatory=$True,Position=0)] 
            [System.Windows.Forms.TreeView]$TreeView
    ) 
    Try
    {
        Write-Verbose "Add-PSAliasesNode"
        $PSAliases = Add-PSAliases
        $Index=0
        IF ($mnuWMIObjects.Checked) {$Index++}
        IF ($mnuNetAssemblies.Checked) {$Index++}
        IF ($mnuNetClasses.Checked) {$Index++}
        $Node = $TreeView.Nodes.Insert($Index,((Get-NextKey)+" " +"PowerShell Aliases"),"PowerShell Aliases")
        $Node.Tag = $PSAliases
        $Node.EnsureVisible()
        $Node
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-PSAliasesNode Catch"
        Write-Verbose $_.Exception.Message
    }
}

#endregion
#region PS Commands

#Adds a PS Command
Function Add-PSCommand
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True,
                Position=0)] 
    [Object]$PSCommand,
    [parameter(Mandatory=$True,
                Position=1)] 
    [Object]$PSCommandsByName,
    [parameter(Mandatory=$True,
                Position=2)] 
    [Object]$PSCommandsByModule,
    [parameter(Mandatory=$True,
                Position=3)] 
    [Object]$PSCommandsByApprovedVerb,
    [parameter(Mandatory=$True,
                Position=4)] 
    [Object]$PSCommandsByNonApprovedVerb
  ) 
    TRY
    {
        Write-Verbose "Add-PSCommand PSCommand.Name=$($PSCommand.Name)"
        If ($PSCommand -NE $Null)
        {
            $CommandName = $PSCommand.Name
            $PSCommandsByName.Add($CommandName,$Command)

            $ModuleName = $Command.Module.Name
            IF ($ModuleName -NE $Null)
            {
                $Module = $PSCommandsByModule[$ModuleName]
                If ($Module -EQ $Null)
                {
                    $Module=New-Object System.Collections.SortedList
                    $PSCommandsByModule.Add($ModuleName,$Module)
                }
                $Module.Add($CommandName,$Command)
            }
            $VerbName = $PSCommand.Verb
            IF ($VerbName -NE "")
            {
                $Verb = $PSCommandsByApprovedVerb[$VerbName]
                If ($Verb -EQ $Null)
                {
                    $Verb = $PSCommandsByNonApprovedVerb[$VerbName]
                    IF($Verb -EQ $Null)
                    {
                       $Verb=New-Object System.Collections.SortedList
                       $PSCommandsByNonApprovedVerb.Add($VerbName,$Verb)
                    }
                }
            }
            Else
            {
                If ($CommandName.Contains(":"))
                {
                    $VerbName = " Drive Alias"
                }
                ElseIf ($CommandName.Contains("_"))
                {
                    $VerbName = " Event Handler"
                }
                ElseIf ($CommandName.Contains("-"))
                {
                    $VerbName = $CommandName.Split("-")[0]
                }
                Else
                {
                    $VerbName = " Alias"
                }
                $Verb = $PSCommandsByNonApprovedVerb[$VerbName]
                IF($Verb -EQ $Null)
                {
                   $Verb=New-Object System.Collections.SortedList
                   $PSCommandsByNonApprovedVerb.Add($VerbName,$Verb)
                }
            }
            $Verb.Add($CommandName,$PSCommand)
        }
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-PSCommand Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Adds PS Commands
Function Add-PSCommands
{
    [CmdletBinding()] 
    param () 
    Try
    {
        Write-Verbose "Add-PSCommands"
        $PSCommands=[ordered]@{}
        $PSCommandsByModule=New-Object System.Collections.SortedList
        $PSCommandsByName=New-Object System.Collections.SortedList
        $PSCommandsByApprovedVerb=New-Object System.Collections.SortedList
        $PSCommandsByNonApprovedVerb=New-Object System.Collections.SortedList
        $Commands = Get-Command 
        $ProgressCounter = 0
        $ProgressIncrement = 100 / $Commands.Count
        $PSVerbs = Get-Verb
        Write-Verbose "Add-PSCommands Getting Approved Verbs"
        ForEach ($PSVerb IN $PSVerbs)
        {
            $PSCommandsByApprovedVerb.Add($PSVerb.Verb,(New-Object System.Collections.SortedList))
        }
        For($I=0;$I -LT $Commands.Count;$I++)
        {
           $Command=$Commands[$I]
           Write-Progress -Activity "Adding Command $Command" -PercentComplete $ProgressCounter -Status "Working ..."
           $ProgressCounter += $ProgressIncrement
           $CommandNode = Add-PSCommand $Command $PSCommandsByName $PSCommandsByModule $PSCommandsByApprovedVerb $PSCommandsByNonApprovedVerb
        }
        Write-Progress -Activity "Added PS Commands" -Status "Done" -Completed 
        $PSCommands.Add("By Name",$PSCommandsByName)
        $PSCommands.Add("By Module",$PSCommandsByModule)
        $PSCommands.Add("By Approved Verb",$PSCommandsByApprovedVerb)
        $PSCommands.Add("By Non Approved Verb",$PSCommandsByNonApprovedVerb)
        $PSCommands
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-PSCommands Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Add TreeView node for PS Commands
Function Add-PSCommandsNode
{
    [CmdletBinding()] 
    param ( [parameter(Mandatory=$True,Position=0)] 
            [System.Windows.Forms.TreeView]$TreeView
    ) 
    Try
    {
        Write-Verbose "Add-PSCommandsNode"
        IF ($Script:PSCommands)
        {
        }
        Else
        {
            $PSCommands = Add-PSCommands
        }
        $Index=0
        IF ($mnuWMIObjects.Checked) {$Index++}
        IF ($mnuNetAssemblies.Checked) {$Index++}
        IF ($mnuNetClasses.Checked) {$Index++}
        IF ($mnuPSAliases.Checked) {$Index++}
        $Node = $TreeView.Nodes.Insert($Index,((Get-NextKey)+" " +"PowerShell Commands"),"PowerShell Commands")
        $Node.Tag = $PSCommands
        $Node.EnsureVisible()
        $Node
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-PSCommandsNode Catch"
        Write-Verbose $_.Exception.Message
    }
}

#endregion
#region PS Drives

#Adds a PS Drive
Function Add-PSDrive
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True,
                Position=0)] 
    [Object]$PSDrive,
    [parameter(Mandatory=$True,
                Position=1)] 
    [Object]$PSDrivesByName,
    [parameter(Mandatory=$True,
                Position=2)] 
    [Object]$PSDrivesByProvider
  ) 
    TRY
    {
        Write-Verbose "Add-PSDrive PSDrive.Name=$($PSDrive.Name)"
        If ($PSDrive -NE $Null)
        {
            $DriveName = $Drive.Name
            $PSDrivesByName.Add($DriveName,$PSDrive)

            $ProviderName = $PSDrive.Provider.Name
            $Provider = $PSDrivesByProvider[$ProviderName]
            If ($Provider -NE $NULL)
            {
            }
            Else
            {
                $Provider=New-Object System.Collections.SortedList
                $PSDrivesByProvider.Add($ProviderName,$Provider)
            }
            $Provider.Add($DriveName,$Drive)
        }
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-PSDrive Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Adds PS Drives
Function Add-PSDrives
{
    [CmdletBinding()] 
    param () 
    Try
    {
        Write-Verbose "Add-PSDrives"
        $PSDrives=[ordered]@{}
        $PSDrivesByProvider=New-Object System.Collections.SortedList
        $PSDrivesByName=New-Object System.Collections.SortedList
        $Drives = Get-PSDrive 
        $ProgressCounter = 0
        $ProgressIncrement = 100 / $Drives.Count
        For($I=0;$I -LT $Drives.Count;$I++)
        {
           $Drive=$Drives[$I]
           Write-Progress -Activity "Adding Drive $Drive" -PercentComplete $ProgressCounter -Status "Working ..."
           $ProgressCounter += $ProgressIncrement
           Add-PSDrive $Drive $PSDrivesByName $PSDrivesByProvider
        }
        Write-Progress -Activity "Added PS Drives" -Status "Done" -Completed 
        $PSDrives.Add("By Name",$PSDrivesByName)
        $PSDrives.Add("By Provider",$PSDrivesByProvider)
        $PSDrives
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-PSDrives Catch"
        Write-Verbose $_.Exception.Message
    }
}
#Add TreeView node for PS Drives

Function Add-PSDrivesNode
{
    [CmdletBinding()] 
    param ( [parameter(Mandatory=$True,Position=0)] 
            [System.Windows.Forms.TreeView]$TreeView
    ) 
    Try
    {
        Write-Verbose "Add-PSDrivesNode"
        $PSDrives = Add-PSDrives
        $Index=0
        IF ($mnuWMIObjects.Checked) {$Index++}
        IF ($mnuNetAssemblies.Checked) {$Index++}
        IF ($mnuNetClasses.Checked) {$Index++}
        IF ($mnuPSAliases.Checked) {$Index++}
        IF ($mnuPSCommands.Checked) {$Index++}
        $Node = $TreeView.Nodes.Insert($Index,((Get-NextKey)+" " +"PowerShell Drives"),"PowerShell Drives")
        $Node.Tag = $PSDrives
        $Node.EnsureVisible()
        $Node
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-PSDrivesNode Catch"
        Write-Verbose $_.Exception.Message
    }
}

#endregion
#region PS Modules

#Adds loaded PS Modules
Function Add-PSModules
{
    [CmdletBinding()] 
    param()
    Try
    {
        Write-Verbose "Add-PSModules"
        $PSModules=[ordered]@{}
        $Modules=Get-Module
        $ProgressCounter = 0
        $ProgressIncrement = 100 / $Modules.Count
        ForEach ($Module In $Modules)
        {
           Write-Progress -Activity "Adding Module $Module" -PercentComplete $ProgressCounter -Status "Working ..."
           $ProgressCounter += $ProgressIncrement
           IF (! $PSModules[$Module.Name])
           {
               $PSModules.Add($Module.Name,$Module)
           }
        }
        Write-Progress -Activity "Added PS Modules" -Status "Done" -Completed 
        $PSModules
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-PSModules Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Add TreeView node for PS Variables
Function Add-PSModulesNode
{
    [CmdletBinding()] 
    param ( [parameter(Mandatory=$True,Position=0)] 
            [System.Windows.Forms.TreeView]$TreeView
    ) 
    Try
    {
        Write-Verbose "Add-PSModulesNode"
        $PSModules = Add-PSModules
        $Index=0
        IF ($mnuWMIObjects.Checked) {$Index++}
        IF ($mnuNetAssemblies.Checked) {$Index++}
        IF ($mnuNetClasses.Checked) {$Index++}
        IF ($mnuPSAliases.Checked) {$Index++}
        IF ($mnuPSCommands.Checked) {$Index++}
        IF ($mnuPSDrives.Checked) {$Index++}
        $Node = $TreeView.Nodes.Insert($Index,((Get-NextKey)+" " +"PowerShell Modules"),"PowerShell Modules")
        $Node.Tag = $PSModules
        $Node.EnsureVisible()
        $Node
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-PSModulesNode Catch"
        Write-Verbose $_.Exception.Message
    }
}

#endregion
#region PS Variables

#Add PS Variable
Function Add-PSVariable
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True,
                Position=0)] 
    [Object]$Variable,
    [parameter(Mandatory=$True,
                Position=1)] 
    [Object]$PSVariablesAuto,
    [parameter(Mandatory=$True,
                Position=2)] 
    [Object]$PSVariablesConfig,
    [parameter(Mandatory=$True,
                Position=3)] 
    [Object]$PSVariablesForm,
    [parameter(Mandatory=$True,
                Position=4)] 
    [Object]$PSVariablesScript,
    [parameter(Mandatory=$True,
                Position=5)] 
    [Object]$PSVariablesLocal
  ) 
    Write-Debug "Add-PSVariable Variable.Name=$($Variable.Name)"
    TRY
    {
        If ($Variable -NE $Null)  #Not Null
        {
            If ($IsPSAutoVariable[$Variable.Name])
            {
                $PSVariablesAuto.Add($Variable.Name,$Variable)
                Write-Debug "PSVariablesAuto.Count=$($PSSAutoVariables.Count)"
            }
            ElseIf ($IsPSConfigVariable[$Variable.Name])
            {
                $PSVariablesConfig.Add($Variable.Name,$Variable)
                Write-Debug "PSVariablesConfig.Count=$($PSVariablesConfig.Count)"
            }
            ElseIf ($IsPSFormVariable[$Variable.Name])
            {
                $PSVariablesForm.Add($Variable.Name,$Variable)
                Write-Debug "PSVariablesForm.Count=$($PSVariablesForm.Count)"
            }
            ElseIf ($IsPSScriptVariable[$Variable.Name])
            {
                $PSVariablesScript.Add($Variable.Name,$Variable)
                Write-Debug "PSVariablesScript.Count=$($PSVariablesScript.Count)"
            }
            Else
            {
                IF (($Variable.Value -Is [System.Windows.Forms.TreeView]) -And
                    ($Variable.Value.Name -EQ "TreeViewInstance")
                   )
                {
                }
                Else
                {
                    $PSVariablesLocal.Add($Variable.Name,$Variable)
                    Write-Debug "PSVariablesLocal.Count=$($PSVariablesLocal.Count)"
                }
            } 
        }
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-PSVariable Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Adds PS Variables
Function Add-PSVariables
{
  [CmdletBinding()] 
  param () 
    Try
    {
        Write-Verbose "Add-PSVariables"
        $Variables = Get-Variable 
        Write-Verbose "Variables.GetType=$($Variables.GetType())"
        Write-Verbose "Variables.Count=$($Variables.Count)"
        $PSVariables=[ordered]@{}
        $PSVariablesAuto=[ordered]@{}
        $PSVariablesConfig=[ordered]@{}
        $PSVariablesForm=[ordered]@{}
        $PSVariablesScript=[ordered]@{}
        $PSVariablesLocal=[ordered]@{}
        $ProgressCounter = 0
        $ProgressIncrement = 100 / $Variables.Count
        ForEach ($Variable In $Variables)
        {
           Write-Progress -Activity "Adding Variable $Variable" -PercentComplete $ProgressCounter -Status "Working ..."
           $ProgressCounter += $ProgressIncrement
           Add-PSVariable $Variable $PSVariablesAuto $PSVariablesConfig $PSVariablesForm $PSVariablesScript $PSVariablesLocal
        }
        Write-Progress -Activity "Added PS Variables" -Status "Done" -Completed 
        $PSVariables.Add("PowerShell Automatic Variables",$PSVariablesAuto)
        $PSVariables.Add("PowerShell Preference Variables",$PSVariablesConfig)
        $PSVariables.Add("Form Variables",$PSVariablesForm)
        $PSVariables.Add("Script Variables",$PSVariablesScript)
        $PSVariables.Add("User Defined Variables",$PSVariablesLocal)
        $PSVariables
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-PSVariables Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Add TreeView node for PS Variables
Function Add-PSVariablesNode
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True,
                Position=0)] 
    [System.Windows.Forms.TreeView]$TreeView
  ) 
    Try
    {
        Write-Verbose "Add-PSVariablesNode"
        $PSVariables = Add-PSVariables
        $Index=0
        IF ($mnuWMIObjects.Checked) {$Index++}
        IF ($mnuNetAssemblies.Checked) {$Index++}
        IF ($mnuNetClasses.Checked) {$Index++}
        IF ($mnuPSAliases.Checked) {$Index++}
        IF ($mnuPSCommands.Checked) {$Index++}
        IF ($mnuPSDrives.Checked) {$Index++}
        IF ($mnuPSModules.Checked) {$Index++}
        $Node = $TreeView.Nodes.Insert($Index,((Get-NextKey)+" " +"PowerShell Variables"),"PowerShell Variables")
        $Node.Tag = $PSVariables
        $Node.EnsureVisible()
        $Node
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-PSVariablesNode Catch"
        Write-Verbose $_.Exception.Message
    }
}

#endregion
#region WIN Features

#Adds Windows Features
Function Add-WINFeatures
{
  [CmdletBinding()] 
  param (
  ) 
    Try
    {
        Write-Verbose "Add-WINFeatures"
        $WINFeatureInstalled=New-Object System.Collections.SortedList
        $WINFeatureNotInstalled=New-Object System.Collections.SortedList
        $WINFeatureAll=New-Object System.Collections.SortedList
        $WINFeatures=[ordered]@{}
        $Features = Get-WindowsFeature -Verbose:$False
        Write-Verbose "Features.GetType=$($Features.GetType())"
        Write-Verbose "Features.Count=$($Features.Count)"
        $ProgressCounter = 0
        $ProgressIncrement = 100 / $Features.Count
        ForEach ($Feature In $Features)
        {
           Write-Progress -Activity "Adding Windows Feature $Feature" -PercentComplete $ProgressCounter -Status "Working ..."
           $ProgressCounter += $ProgressIncrement
           IF ($Feature.Installed)
           {
               $WINFeatureInstalled.Add($Feature.Name,$Feature)
           }
           Else
           {
               $WINFeatureNotInstalled.Add($Feature.Name,$Feature)
           }
           $WINFeatureAll.Add($Feature.Name,$Feature)
        }
        Write-Progress -Activity "Added Windows Features" -Status "Done" -Completed 
        $WINFeatures.Add("Installed",$WINFeatureInstalled)
        $WINFeatures.Add("Not Installed",$WINFeatureNotInstalled)
        $WINFeatures.Add("Sorted By Name",$WINFeatureAll)
        $WINFeatures
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-WINFeatures Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Add TreeView node for Windows Features
Function Add-WINFeaturesNode
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True,
                Position=0)] 
    [System.Windows.Forms.TreeView]$TreeView
  ) 
    Try
    {
        Write-Verbose "Add-WINFeaturesNode"
        $WINFeatures = Add-WINFeatures
        $Index=0
        IF ($mnuWMIObjects.Checked) {$Index++}
        IF ($mnuNetAssemblies.Checked) {$Index++}
        IF ($mnuNetClasses.Checked) {$Index++}
        IF ($mnuPSAliases.Checked) {$Index++}
        IF ($mnuPSCommands.Checked) {$Index++}
        IF ($mnuPSDrives.Checked) {$Index++}
        IF ($mnuPSModules.Checked) {$Index++}
        IF ($mnuPSVariables.Checked) {$Index++}
        $Node = $TreeView.Nodes.Insert($Index,((Get-NextKey)+" " +"Windows Features"),"Windows Features")
        $Node.Tag = $WINFeatures
        $Node.EnsureVisible()
        $Node
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-WINFeaturesNode Catch"
        Write-Verbose $_.Exception.Message
    }
}

#endregion
#region WIN Processes

#Adds Windows Processes
Function Add-WINProcesses
{
  [CmdletBinding()] 
  param (
  ) 
    Try
    {
        Write-Verbose "Add-WINProcesses"
        $Processes = Get-Process 
        $WINProcesses=[Ordered]@{}
        $WINProcessesID=New-Object System.Collections.SortedList
        $WINProcessesName=$Processes
        $WINProcessesWindow=New-Object System.Collections.SortedList
        $WINProcessesNonWindow=New-Object System.Collections.SortedList
        Write-Verbose "Processes.GetType=$($Processes.GetType())"
        Write-Verbose "Processes.Count=$($Processes.Count)"
        $ProgressCounter = 0
        $ProgressIncrement = 100 / $Processes.Count
        ForEach ($Process In $Processes)
        {
           Write-Progress -Activity "Adding Windows Process $Process" -PercentComplete $ProgressCounter -Status "Working ..."
           $ProgressCounter += $ProgressIncrement
           $WINProcessesID.Add($Process.ID,$Process)
           IF($Process.MainWindowTitle -EQ "")
           {
              $WINProcessesNonWindow.Add("$($Process.Name) ($($Process.ID))",$Process)
           }
           Else
           {
              $WINProcessesWindow.Add("$($Process.Name) ($($Process.ID))",$Process)
           }
        }
        Write-Progress -Activity "Added Windows Processes" -Status "Done" -Completed 
        $WINProcesses.Add("By ID",$WINProcessesID)
        $WINProcesses.Add("By Name",$WINProcessesName)
        $WINProcesses.Add("Applications",$WINProcessesWindow)
        $WINProcesses.Add("Background Processes",$WINProcessesNonWindow)
        $WINProcesses
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-WINProcesss Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Add TreeView node for Windows Processs
Function Add-WINProcessesNode
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True,
                Position=0)] 
    [System.Windows.Forms.TreeView]$TreeView
  ) 
    Try
    {
        Write-Verbose "Add-WINProcessesNode"
        $WINProcesses = Add-WINProcesses
        $Index=0
        IF ($mnuWMIObjects.Checked) {$Index++}
        IF ($mnuNetAssemblies.Checked) {$Index++}
        IF ($mnuNetClasses.Checked) {$Index++}
        IF ($mnuPSAliases.Checked) {$Index++}
        IF ($mnuPSCommands.Checked) {$Index++}
        IF ($mnuPSDrives.Checked) {$Index++}
        IF ($mnuPSModules.Checked) {$Index++}
        IF ($mnuPSVariables.Checked) {$Index++}
        IF ($mnuWINFeature.Checked) {$Index++}
        $Node = $TreeView.Nodes.Insert($Index,((Get-NextKey)+" " +"Windows Processes"),"Windows Processes")
        $Node.Tag = $WINProcesses
        $Node.EnsureVisible()
        $Node
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-WINProcessesNode Catch"
        Write-Verbose $_.Exception.Message
    }
}

#endregion
#region WIN Services

#Adds Windows Services
Function Add-WINServices
{
  [CmdletBinding()] 
  param (
  ) 
    Try
    {
        Write-Verbose "Add-WINServices"
        $WINServiceRunning=New-Object System.Collections.SortedList
        $WINServiceNotRunning=New-Object System.Collections.SortedList
        $WINServiceAll=New-Object System.Collections.SortedList
        $WINServices=[ordered]@{}
        $Services = Get-Service
        Write-Verbose "Services.GetType=$($Services.GetType())"
        Write-Verbose "Services.Count=$($Services.Count)"
        $ProgressCounter = 0
        $ProgressIncrement = 100 / $Services.Count
        ForEach ($Service In $Services)
        {
           Write-Progress -Activity "Adding Windows Service $Service" -PercentComplete $ProgressCounter -Status "Working ..."
           $ProgressCounter += $ProgressIncrement
           IF ($Service.Status.ToString() -EQ "Running")
           {
               $WINServiceRunning.Add($Service.Name,$Service)
           }
           Else
           {
               $WINServiceNotRunning.Add($Service.Name,$Service)
           }
           $WINServiceAll.Add($Service.Name,$Service)
        }
        Write-Progress -Activity "Added Windows Services" -Status "Done" -Completed 
        $WINServices.Add("Running",$WINServiceRunning)
        $WINServices.Add("Not Running",$WINServiceNotRunning)
        $WINServices.Add("Sorted By Name",$WINServiceAll)
        $WINServices
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-WINServices Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Add TreeView node for Windows Services
Function Add-WINServicesNode
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True,
                Position=0)] 
    [System.Windows.Forms.TreeView]$TreeView
  ) 
    Try
    {
        Write-Verbose "Add-WINServicesNode"
        $WINServices = Add-WINServices
        $Index=0
        IF ($mnuWMIObjects.Checked) {$Index++}
        IF ($mnuNetAssemblies.Checked) {$Index++}
        IF ($mnuNetClasses.Checked) {$Index++}
        IF ($mnuPSAliases.Checked) {$Index++}
        IF ($mnuPSCommands.Checked) {$Index++}
        IF ($mnuPSDrives.Checked) {$Index++}
        IF ($mnuPSModules.Checked) {$Index++}
        IF ($mnuPSVariables.Checked) {$Index++}
        IF ($mnuWINFeature.Checked) {$Index++}
        IF ($mnuWINProcess.Checked) {$Index++}
        $Node = $TreeView.Nodes.Insert($Index,((Get-NextKey)+" " +"Windows Services"),"Windows Services")
        $Node.Tag = $WINServices
        $Node.EnsureVisible()
        $Node
    }
    Catch [System.Exception]
    {
        Write-Verbose "Add-WINServicesNode Catch"
        Write-Verbose $_.Exception.Message
    }
}

#endregion
#region "Test Cases"

#Add TreeView nodes for Test Cases
Function Add-TestCaseLeaf
{
    [CmdletBinding()] 
    param ( [parameter(Mandatory=$True,
                        Position=0)] 
            [Object]$Root,
            [parameter(Mandatory=$True,
                        Position=1)] 
            [String]$Key,
            [parameter(Mandatory=$True,
                        Position=2)] 
            [Object]$Value
    ) 
    Try
    {
        Write-Debug "Add-TestCaseLeaf $Key"
        $Leaf = $Root[$Key]
        If (! $Leaf)
        {
            $Root.Add($Key,$Value)
        }
    }
    Catch
    {
        Write-Verbose "Add-TestCaseLeaf Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Add TreeView nodes for Test Cases
Function Add-TestCaseBranch
{
    [CmdletBinding()] 
    param ( [parameter(Mandatory=$True,
                        Position=0)] 
            [Object]$Root,
            [parameter(Mandatory=$True,
                        Position=1)] 
            [String]$Key
    ) 
    Try
    {
        Write-Debug "Add-TestCaseBranch $Key"
        $Branch = $Root[$Key]
        If (! $Branch)
        {
            $Branch = [ordered]@{}
            $Root.Add($Key,$Branch)
        }
        Else
        {
        }
        $Branch
    }
    Catch
    {
        Write-Verbose "Add-TestCaseBranch Catch"
        Write-Verbose $_.Exception.Message
    }
}
#Adds PSCustomObject Test Cases
Function Add-PSCustomObjectTestCase
{
    [CmdletBinding()] 
    param ( [parameter(Mandatory=$True,
                        Position=0)] 
            [Object]$Root,
            [parameter(Mandatory=$True,
                        Position=1)] 
            [Object]$Key,
            [parameter(Mandatory=$True,
                        Position=2)] 
            [Object]$Value,
            [parameter(Mandatory=$True,
                        Position=3)] 
            [Object]$Type
    ) 
    Try
    {
        Write-Verbose "Add-PSCustomObjectTestCase Key=$Key"
        [string]$PSObjectProperty=$Key
        $PSObjectProperty=$PSObjectProperty.Replace("[","")
        $PSObjectProperty=$PSObjectProperty.Replace("]","_")
        $PSObjectProperty=$PSObjectProperty.Replace("(","")
        $PSObjectProperty=$PSObjectProperty.Replace(")","")
        $PSObjectProperty=$PSObjectProperty.Replace(":","")
        $PSObjectProperty=$PSObjectProperty.Replace("$","")
        $PSObjectProperty=$PSObjectProperty.Replace("-","")
        $PSObjectProperty=$PSObjectProperty.Replace("""","")
        $PSObjectProperty=$PSObjectProperty.Replace("'","")
        $PSObjectProperty=$PSObjectProperty.Replace(" ","")
        $PSObjectProperty=$PSObjectProperty.Replace(".","_")
        Write-Verbose "Add-PSCustomObjectTestCase PSObjectProperty=$PSObjectProperty"

        $Level1=Add-TestCaseBranch $Root   "PSCustomObject"
        $Level2=Add-TestCaseBranch $Level1 "[PSCustomObject] Test Cases"

        $PSObjectKey="PSCustomObject Object"
        $PSObject = $Level2[$PSObjectKey]
        If ($PSObject -EQ $Null)
        {
           Write-Verbose "Add-PSCustomObjectTestCase Adding PSCustomObject Object"
           $PSObject = New-Object PSObject -Property ([ordered]@{$PSObjectProperty=$Value;})
           $PSObjectLeaf=Add-TestCaseLeaf $Level2 $PSObjectKey $PSObject
           $PSObjectType=$PSObject.GetType()
           Write-Verbose "Add-PSCustomObjectTestCase Adding [PSObject]"
           $PSObjectTypeLeaf=Add-TestCaseLeaf $Level1 "[$($PSObjectType.FullName)]" $PSObjectType
           Write-Verbose "Add-PSCustomObjectTestCase Adding PSObject.BaseType"
           $BaseLeaf =Add-BaseTypeTestCase $Root $PSObjectType.BaseType $Level2
           $ArrayBranch=Add-TestCaseBranch $Level1 "$($PSObjectType.FullName)[]" 
           [PSCustomObject[]]$PSObjectArray=@($PSObject)
           $ArrayLeaf=Add-TestCaseLeaf $ArrayBranch ($PSObjectType.FullName+"[]Test Case") $PSObjectArray
           $ArrayType=$PSObjectArray.GetType()
           $ArrayTypeLeaf=Add-TestCaseLeaf $ArrayBranch "[$($ArrayType.FullName)]" $ArrayType
        }
        Else
        {
            Add-Member -InputObject $PSObject -MemberType NoteProperty -Name $PSObjectProperty -Value $Value
        }

        $PSCustomObjectKey="PSCustomObject "+$($Type.Name)
        $PSCustomObject = $Level2[$PSCustomObjectKey]
        If ($PSCustomObject -EQ $Null)
        {
           $PSCustomObject = New-Object PSObject -Property ([ordered]@{$PSObjectProperty=$Value;})
           $PSObjectLeaf=Add-TestCaseLeaf $Level2 $PSCustomObjectKey $PSCustomObject
           $PSObjectType=$PSObject.GetType()
           $ArrayBranch=Add-TestCaseBranch $Level1 "$($PSObjectType.FullName)[]" 
           [PSCustomObject[]]$PSObjectArray=@($PSCustomObject)
           $OldArray=$ArrayBranch[$PSObjectType.FullName+"[]Test Case"] 
           $NewArray=$OldArray + $PSObjectArray
           $ArrayBranch[$PSObjectType.FullName+"[]Test Case"] = $NewArray
        }
        Else
        {
            Add-Member -InputObject $PSCustomObject -MemberType NoteProperty -Name $PSObjectProperty -Value $Value
        }
    }
    Catch
    {
        Write-Verbose "Add-PSCustomObjectTestCase Catch"
        Write-Verbose $_.Exception.Message
    }
}
#Adds Array Test Case
Function Add-ArrayTestCase
{
    [CmdletBinding()] 
    param ( [parameter(Mandatory=$True,
                        Position=0)] 
            [Object]$Root,
            [parameter(Mandatory=$True,
                        Position=1)] 
            [String]$Type,
            [parameter(Mandatory=$True,
                        Position=2)] 
            [Object]$Value
    ) 
    Try
    {
        Write-Verbose "Add-ArrayTestCase $Type"
        $String  = "`n"
        $String += "[$Type]"+"$"+"Element="+"$"+"Value`n"
        $String += "[$Type[]]"+"$"+"NewArray=@("+"$"+"Element)"
        Write-Debug "Add-ArrayTestCase String=$String"
        Invoke-Expression $String
        $GetType=$NewArray.GetType()
        $Level1=Add-TestCaseBranch $Root $GetType.BaseType.Name
        $Level2=Add-TestCaseBranch $Level1 $GetType.FullName
        $ArrayKey="[$($GetType.Name)]Test Case"
        $String  = "`n"
        $String += "[$Type[]]"+"$"+"Array="+"$"+"Level2["+"$"+"ArrayKey]"
        Write-Debug "Add-ArrayTestCase String=$String"
        Invoke-Expression $String
        IF ($Array.Count -GT 0)
        {
            $String  = "`n"
            $String += "[$Type[]]"+"$" + "AddArray="+"$"+"Array+"+"$"+"NewArray"
            Write-Debug "Add-ArrayTestCase String=$String"
            Invoke-Expression $String
            $Level2[$ArrayKey]=$AddArray
        }
        Else
        {
            $Level2.Add($ArrayKey, $NewArray)
        }
        $TypeLeaf =Add-TestCaseLeaf $Level2 "[$($GetType.FullName)]" $GetType
        $BaseType =Add-BaseTypeTestCase $Root $GetType.BaseType $Level1
        $Level2
    }
    Catch
    {
        Write-Verbose "Add-ArrayTestCase Catch"
        Write-Verbose $_.Exception.Message
    }
}
#Adds Base Type Test Cases
Function Add-BaseTypeTestCase
{
    [CmdletBinding()] 
    param ( [parameter(Mandatory=$True,
                        Position=0)] 
            [Object]$Root,
            [parameter(Mandatory=$True,
                        Position=1)] 
            [Object]$Type,
            [parameter(Mandatory=$True,
                        Position=2)] 
            [Object]$Branch
    ) 
    Try
    {
        Write-Verbose "Add-BaseTypeTestCase Type.FullName=$($Type.FullName)"
        $BaseType=$Type.BaseType
        Write-Debug "Add-BaseTypeTestCase Type.BaseType=$BaseType"
        If ($BaseType -NE $Null)
        {
            $BaseTypeBranch = Add-BaseTypeTestCase $Root $BaseType $Branch
            $BaseTypeLeaf = Add-TestCaseLeaf $BaseTypeBranch $Type.FullName $Branch

        }
        Else
        {
            $BaseTypeBranch = Add-TestCaseBranch $Root $Type.Name 
        }
        $BaseTypeBranch
    }
    Catch
    {
        Write-Verbose "Add-BaseTypeTestCase Catch"
        Write-Verbose $_.Exception.Message
    }
}
#Add TreeView nodes for Test Cases
Function Add-ValueTypeTestCase
{
    [CmdletBinding()] 
    param ( [parameter(Mandatory=$True,
                        Position=0)] 
            [Object]$Root,
            [parameter(Mandatory=$True,
                        Position=1)] 
            [String]$Key,
            [parameter(Mandatory=$True,
                        Position=2)] 
            [Object]$Value
    ) 
    Try
    {
        Write-Verbose " "
        Write-Verbose "Add-ValueTypeTestCase Key=$Key"
        $GetType=$Value.GetType()
        Write-Debug "Add-ValueTypeTestCase GetType=$GetType"
        $Level1=Add-TestCaseBranch $Root $GetType.BaseType.Name
        $Level2=Add-TestCaseBranch $Level1 $GetType.FullName
        $Level3=Add-TestCaseBranch $Level2 "[$($GetType.Name)]Test Cases"
        $ValueLeaf=Add-TestCaseLeaf $Level3 $Key $Value
        $TypeLeaf =Add-TestCaseLeaf $Level2 "[$($GetType.FullName)]" $GetType
        $BaseLeaf =Add-BaseTypeTestCase $Root $GetType.BaseType $Level1
        $ArrayLeaf=Add-ArrayTestCase $Root $GetType.FullName $Value
        $ArrayBranch=Add-TestCaseLeaf $Level2 ($GetType.FullName+"[]") $ArrayLeaf

        $ArrayKey="[$($GetType.Name)[]]Test Case"
        $Array=$ArrayLeaf[$ArrayKey]
        $ArrayFullName=$Array.GetType().FullName

        $ObjectKey="Object[]Test Case"
        $ObjectLevel1=Add-TestCaseBranch $Root "Array" 
        $ObjectLevel2=Add-TestCaseBranch $ObjectLevel1 "System.Object[]" 
        $ObjectArray = $ObjectLevel2[$ObjectKey]

        $TypeFound=$False
        $TypeIndex=-1
        FOR ($I=0;$I -LT $ObjectArray.Count;$I++)
        {
            $Elements=$ObjectArray[$I]
            $ElementsFullName=$Elements.GetType().FullName 
            IF ($ElementsFullName -EQ $ArrayFullName)
            {
                $TypeFound=$True
                $TypeIndex = $I
                break
            }
        }
        Write-Debug "Add-ValueTypeTestCase TypeFound=$TypeFound"
        IF ($TypeFound)
        {
            $ObjectArray[$TypeIndex] = $Array
        }
        Else
        {
            $NewObjectArray = $ObjectArray + @($Array)
            $NewObjectArray[$ObjectArray.Count] = $Array
            $ObjectLevel2[$ObjectKey]=$NewObjectArray
        }
        Add-PSCustomObjectTestCase $Root $Key $Value $GetType
     }
    Catch
    {
        Write-Verbose "Add-ValueTypeTestCase Catch"
        Write-Verbose $_.Exception.Message
    }
}
#Add Test Cases
Function Add-TestCases
{
    [CmdletBinding()] 
    param ()
    Try
    {
        Write-Verbose "Add-TestCases"
        $TestCases=[ordered]@{}
        $ObjectBranch         = Add-TestCaseBranch $TestCases "Object"
        $ValueTypeBranch      = Add-TestCaseBranch $TestCases "ValueType"
        $StringBranch         = Add-TestCaseBranch $TestCases "String"
        $EnumBranch           = Add-TestCaseBranch $TestCases "Enum"
        $ArrayBranch          = Add-TestCaseBranch $TestCases "Array"
        $PSObjectBranch       = Add-TestCaseBranch $TestCases "PSCustomObject"
        $ObjectArrayBranch    = Add-TestCaseBranch $ArrayBranch  "System.Object[]"
        $ObjectArrayLeaf      = Add-TestCaseLeaf $ObjectArrayBranch  "Object[]Test Case" @()
        $ObjectArrayTypeLeaf  = Add-TestCaseLeaf $ObjectArrayBranch  "[System.Object[]]" ((@()).GetType())
        $ObjectLeaf           = Add-TestCaseLeaf $ObjectBranch "System.Object"    $ObjectBranch
        $ValueTypeLeaf        = Add-TestCaseLeaf $ObjectBranch "System.ValueType" $ValueTypeBranch
        $StringLeaf           = Add-TestCaseLeaf $ObjectBranch "System.String"    $StringBranch
        $EnumLeaf             = Add-TestCaseLeaf $ObjectBranch "System.Enum"      $EnumBranch
        $ArrayLeaf            = Add-TestCaseLeaf $ObjectBranch "System.Array"     $ArrayBranch
        $PSObjectLeaf         = Add-TestCaseLeaf $ObjectBranch "System.Management.Automation.PSCustomObject" $PSObjectBranch
               
        #System.Boolean
        Add-ValueTypeTestCase $TestCases '[Boolean]$True'                  ([Boolean]$True)  
        Add-ValueTypeTestCase $TestCases '[Boolean]$False'                 ([Boolean]$False) 
        #System.Byte
        Add-ValueTypeTestCase $TestCases '[Byte]0'                         ([Byte]0)          
        Add-ValueTypeTestCase $TestCases '[Byte]1'                         ([Byte]1)          
        Add-ValueTypeTestCase $TestCases '[Byte]::MinValue'                ([Byte]::MinValue) 
        Add-ValueTypeTestCase $TestCases '[Byte]::MaxValue'                ([Byte]::MaxValue)
        #System.SByte 
        Add-ValueTypeTestCase $TestCases '[SByte]0'                        ([SByte]0)         
        Add-ValueTypeTestCase $TestCases '[SByte]1'                        ([SByte]1)         
        Add-ValueTypeTestCase $TestCases '[SByte]::MinValue'               ([SByte]::MinValue) 
        Add-ValueTypeTestCase $TestCases '[SByte]::MaxValue'               ([SByte]::MaxValue) 
        #System.UInt16
        Add-ValueTypeTestCase $TestCases '[UInt16]0'                       ([UInt16]0)       
        Add-ValueTypeTestCase $TestCases '[UInt16]1'                       ([UInt16]1)       
        Add-ValueTypeTestCase $TestCases '[UInt16]::MinValue'              ([UInt16]::MinValue) 
        Add-ValueTypeTestCase $TestCases '[UInt16]::MaxValue'              ([UInt16]::MaxValue) 
        #System.Int16
        Add-ValueTypeTestCase $TestCases '[Int16]0'                        ([Int16]0)        
        Add-ValueTypeTestCase $TestCases '[Int16]1'                        ([Int16]1)        
        Add-ValueTypeTestCase $TestCases '[Int16]::MinValue'               ([Int16]::MinValue) 
        Add-ValueTypeTestCase $TestCases '[Int16]::MaxValue'               ([Int16]::MaxValue) 
        #System.UInt32
        Add-ValueTypeTestCase $TestCases '[UInt32]0'                       ([UInt32]0)       
        Add-ValueTypeTestCase $TestCases '[UInt32]1'                       ([UInt32]1)       
        Add-ValueTypeTestCase $TestCases '[UInt32]::MinValue'              ([UInt32]::MinValue) 
        Add-ValueTypeTestCase $TestCases '[UInt32]::MaxValue'              ([UInt32]::MaxValue) 
        #System.Int32
        Add-ValueTypeTestCase $TestCases '[Int32]0'                        ([Int32]0)        
        Add-ValueTypeTestCase $TestCases '[Int32]1'                        ([Int32]1)        
        Add-ValueTypeTestCase $TestCases '[Int32]::MinValue'               ([Int32]::MinValue) 
        Add-ValueTypeTestCase $TestCases '[Int32]::MaxValue'               ([Int32]::MaxValue) 
        #System.UInt64
        Add-ValueTypeTestCase $TestCases '[UInt64]0'                       ([UInt64]0)       
        Add-ValueTypeTestCase $TestCases '[UInt64]1'                       ([UInt64]1)       
        Add-ValueTypeTestCase $TestCases '[UInt64]::MinValue'              ([UInt64]::MinValue) 
        Add-ValueTypeTestCase $TestCases '[UInt64]::MaxValue'              ([UInt64]::MaxValue) 
        #System.Int64
        Add-ValueTypeTestCase $TestCases '[Int64]0'                        ([Int64]0)        
        Add-ValueTypeTestCase $TestCases '[Int64]1'                        ([Int64]1)        
        Add-ValueTypeTestCase $TestCases '[Int64]::MinValue'               ([Int64]::MinValue) 
        Add-ValueTypeTestCase $TestCases '[Int64]::MaxValue'               ([Int64]::MaxValue) 
        #System.Int
        Add-ValueTypeTestCase $TestCases '[Int]0'                          ([Int]0)        
        Add-ValueTypeTestCase $TestCases '[Int]1'                          ([Int]1)        
        Add-ValueTypeTestCase $TestCases '[Int]::MinValue'                 ([Int]::MinValue) 
        Add-ValueTypeTestCase $TestCases '[Int]::MaxValue'                 ([Int]::MaxValue) 
        #System.Long
        Add-ValueTypeTestCase $TestCases '[Long]0'                         ([Long]0)       
        Add-ValueTypeTestCase $TestCases '[Long]1'                         ([Long]1)       
        Add-ValueTypeTestCase $TestCases '[Long]::MinValue'                ([Long]::MinValue) 
        Add-ValueTypeTestCase $TestCases '[Long]::MaxValue'                ([Long]::MaxValue) 
        #System.Single
        Add-ValueTypeTestCase $TestCases '[Single]0'                       ([Single]0)       
        Add-ValueTypeTestCase $TestCases '[Single]1'                       ([Single]1)       
        Add-ValueTypeTestCase $TestCases '[Single]::MinValue'              ([Single]::MinValue) 
        Add-ValueTypeTestCase $TestCases '[Single]::MaxValue'              ([Single]::MaxValue) 
        Add-ValueTypeTestCase $TestCases '[Single]::Epsilon'               ([Single]::Epsilon) 
        Add-ValueTypeTestCase $TestCases '[Single]::NegativeInfinity'      ([Single]::NegativeInfinity) 
        Add-ValueTypeTestCase $TestCases '[Single]::PositiveInfinity'      ([Single]::PositiveInfinity) 
        #System.Double
        Add-ValueTypeTestCase $TestCases '[Double]0'                       ([Double]0)       
        Add-ValueTypeTestCase $TestCases '[Double]1'                       ([Double]1)       
        Add-ValueTypeTestCase $TestCases '[Double]::MinValue'              ([Double]::MinValue) 
        Add-ValueTypeTestCase $TestCases '[Double]::MaxValue'              ([Double]::MaxValue) 
        Add-ValueTypeTestCase $TestCases '[Double]::Epsilon'               ([Double]::Epsilon) 
        Add-ValueTypeTestCase $TestCases '[Double]::NegativeInfinity'      ([Double]::NegativeInfinity) 
        Add-ValueTypeTestCase $TestCases '[Double]::PositiveInfinity'      ([Double]::PositiveInfinity) 
        #System.Float
        Add-ValueTypeTestCase $TestCases '[Float]0'                        ([Float]0)       
        Add-ValueTypeTestCase $TestCases '[Float]1'                        ([Float]1)       
        Add-ValueTypeTestCase $TestCases '[Float]::MinValue'               ([Float]::MinValue) 
        Add-ValueTypeTestCase $TestCases '[Float]::MaxValue'               ([Float]::MaxValue) 
        Add-ValueTypeTestCase $TestCases '[Float]::Epsilon'                ([Float]::Epsilon) 
        Add-ValueTypeTestCase $TestCases '[Float]::NegativeInfinity'       ([Float]::NegativeInfinity) 
        Add-ValueTypeTestCase $TestCases '[Float]::PositiveInfinity'       ([Float]::PositiveInfinity) 
        #System.Decimal
        Add-ValueTypeTestCase $TestCases '[Decimal]0'                      ([Decimal]0)       
        Add-ValueTypeTestCase $TestCases '[Decimal]1'                      ([Decimal]1)       
        Add-ValueTypeTestCase $TestCases '[Decimal]::MinValue'             ([Decimal]::MinValue) 
        Add-ValueTypeTestCase $TestCases '[Decimal]::MaxValue'             ([Decimal]::MaxValue) 
        Add-ValueTypeTestCase $TestCases '[Decimal]::MinusOne'             ([Decimal]::MinusOne) 
        Add-ValueTypeTestCase $TestCases '[Decimal]::Zero'                 ([Decimal]::Zero) 
        Add-ValueTypeTestCase $TestCases '[Decimal]::One'                  ([Decimal]::One) 
        #System.Math
        Add-ValueTypeTestCase $TestCases '[Math]::PI'                      ([Math]::PI) 
        Add-ValueTypeTestCase $TestCases '[Math]::E'                       ([Math]::E) 
        #System.Numerics.BigInteger
        Add-ValueTypeTestCase $TestCases '[System.Numerics.BigInteger]::Zero'                 ([System.Numerics.BigInteger]::Zero) 
        Add-ValueTypeTestCase $TestCases '[System.Numerics.BigInteger]::One'                  ([System.Numerics.BigInteger]::One) 
        Add-ValueTypeTestCase $TestCases '[System.Numerics.BigInteger]::MinusOne'             ([System.Numerics.BigInteger]::MinusOne) 
        #System.Numerics.Complex
        Add-ValueTypeTestCase $TestCases '[System.Numerics.Complex]::Zero'                    ([System.Numerics.Complex]::Zero) 
        Add-ValueTypeTestCase $TestCases '[System.Numerics.Complex]::One'                     ([System.Numerics.Complex]::One) 
        Add-ValueTypeTestCase $TestCases '[System.Numerics.Complex]::ImaginaryOne'            ([System.Numerics.Complex]::ImaginaryOne) 
        Add-ValueTypeTestCase $TestCases '[System.Numerics.Complex]::Zero+[Math]::PI'         ([System.Numerics.Complex]::Zero+[Math]::PI) 
        Add-ValueTypeTestCase $TestCases '[System.Numerics.Complex]::Zero+[Math]::E'          ([System.Numerics.Complex]::Zero+[Math]::E) 
        Add-ValueTypeTestCase $TestCases '[System.Numerics.Complex]::One *[Math]::PI'         ([System.Numerics.Complex]::One*[Math]::PI) 
        Add-ValueTypeTestCase $TestCases '[System.Numerics.Complex]::One *[Math]::E'          ([System.Numerics.Complex]::One*[Math]::E) 
        Add-ValueTypeTestCase $TestCases '[System.Numerics.Complex]::ImaginaryOne*[Math]::PI' ([System.Numerics.Complex]::ImaginaryOne*[Math]::PI) 
        Add-ValueTypeTestCase $TestCases '[System.Numerics.Complex]::ImaginaryOne*[Math]::E'  ([System.Numerics.Complex]::ImaginaryOne*[Math]::E) 
        #System.Char
        Add-ValueTypeTestCase $TestCases '[Char]''A'''                     ([Char]'A')        
        Add-ValueTypeTestCase $TestCases '[Char]::MinValue'                ([Char]::MinValue)        
        Add-ValueTypeTestCase $TestCases '[Char]::MaxValue'                ([Char]::MaxValue)        
        #System.String
        Add-ValueTypeTestCase $TestCases '[String]"A"'                     ([String]"A")       
        Add-ValueTypeTestCase $TestCases '[String]::Empty'                 ([String]::Empty)       
        #System.DateTime
        Add-ValueTypeTestCase $TestCases '[DateTime]Get-Date'              (Get-Date)        
        #System.TimeSpan
        Add-ValueTypeTestCase $TestCases '[TimeSpan](Get-Date).TimeOfDay'  ((Get-Date).TimeOfDay)        
        #System.DayOfWeek
        Add-ValueTypeTestCase $TestCases '[DayOfWeek](Get-Date).DayOfWeek' ((Get-Date).DayOfWeek)       
        #System.Guid
        Add-ValueTypeTestCase $TestCases '[Guid][System.Guid]::NewGuid()'  ([System.Guid]::NewGuid())       

        $TestCases
    }
    Catch
    {
        Write-Verbose "Add-TestCases Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Add TreeView nodes for Test Cases
Function Add-TestCaseNodes
{
    [CmdletBinding()] 
    param ( [parameter(Mandatory=$True,Position=0)] 
            [System.Windows.Forms.TreeView]$TreeView
    ) 
    Try
    {
        Write-Verbose "Add-TestCaseNodes"

        $TestCases=Add-TestCases

        $Index=0
        IF ($mnuWMIObjects.Checked) {$Index++}
        IF ($mnuNetAssemblies.Checked) {$Index++}
        IF ($mnuNetClasses.Checked) {$Index++}
        IF ($mnuPSAliases.Checked) {$Index++}
        IF ($mnuPSCommands.Checked) {$Index++}
        IF ($mnuPSDrives.Checked) {$Index++}
        IF ($mnuPSModules.Checked) {$Index++}
        IF ($mnuPSVariables.Checked) {$Index++}
        IF ($mnuWINFeature.Checked) {$Index++}
        IF ($mnuWINProcess.Checked) {$Index++}
        IF ($mnuWINService.Checked) {$Index++}
        $Node = $TreeView.Nodes.Insert($Index,((Get-NextKey)+" " +"Test Cases"),"Test Cases")
        $Node.Tag=$TestCases
        $Node.EnsureVisible()
        $Node
    }
    Catch
    {
        Write-Verbose "Add-TestCaseNodes Catch"
        Write-Verbose $_.Exception.Message
    }
}

#endregion

#Clears a listview columnns and items
Function Clear-ListView
{
  [CmdletBinding()] 
  param( 
    [parameter(Mandatory=$True)]
    [System.Windows.Forms.ListView]$ListView
  )
    Write-Verbose "Clear-ListView"
    $ListView.Items.Clear()
    $ListView.Columns.Clear()
}

#Fills Listview with a class defintion
Function Fill-ListViewClass
{
  [CmdletBinding()] 
  param ( 
    [Parameter(Mandatory=$true)]
    [System.Windows.Forms.ListView]$ListView,
    [parameter(Mandatory=$True)] 
    [object]$Object
  )
    Try
    {
        Write-Verbose "Fill-ListViewClass"
        Clear-ListView $ListViewClass
        $ListView.View = [System.Windows.Forms.View]::Details
        $Column=$ListView.Columns.Add("Member Type")
        $Column.Width=$ListView.Width *.14
        $Column=$ListView.Columns.Add("Return Type")
        $Column.Width=$ListView.Width *.30
        $Column=$ListView.Columns.Add("Definition")
        $Column.Width=$ListView.Width *.52
        ForEach ($M in (Get-Member -InputObject $Object))
        {
            [String]$MemberName = $M.Name
            [String]$MemberType = $M.MemberType
            [String]$MemberTypeName = $M.TypeName
            [String]$MemberDefinition = $M.Definition
            $Space = $MemberDefinition.IndexOf(" ")
            [String]$ReturnType = $MemberDefinition.Substring(0,$Space)
            [String]$Definition = $MemberDefinition.Substring($Space+1)
            $Item=$ListView.Items.Add($MemberType)
            $Item.SubItems.Add($ReturnType)
            $Item.SubItems.Add($Definition)
        }
    }
    Catch [System.Exception]
    {
        Write-Verbose "Fill-ListViewClass Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Creates a PSObject definition from a object
Function Get-PSObjectTextFromObject
{
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory=$true)]
        [String]$Class,
        [Parameter(Mandatory=$true)]
        [Object]$Object
    )
    Try
    {
        Write-Verbose "Get-PSObjectTextFromObject"
        $Members=Get-Member -InputObject $Object 
        $ValidPropertyType = @{"{get;set;}"=$True;"{get;}"=$True;}
        $ValidReturnType = @{"bool"=$True;"byte"=$True;"string"=$True;"string[]"=$True;
                             "int"=$True;"int16"=$True;"int32"=$True;"int64"=$True;
                             "uint"=$True;"uint16"=$True;"uint32"=$True;"uint64"=$True;"long"=$True;
                             "datetime"=$True;"timespan"=$True;
                             "system.boolean"=$True;"system.byte"=$True;"system.string"=$True;"system.string[]"=$True;
                             "system.int"=$True;"system.int16"=$True;"system.int32"=$True;"system.int64"=$True;
                             "system.uint"=$True;"system.uint16"=$True;"system.uint32"=$True;"system.uint64"=$True;"system.long"=$True;
                             "system.datetime"=$True;"system.timespan"=$True
                            }
        [string]$String=""
        $String=$String+"New-Object PSObject -Property ([Ordered]@{ `r`n"

        ForEach ($Member in $Members)
        {
            IF ($Member.MemberType -EQ "Property" -OR $Member.MemberType -EQ "NoteProperty")
            {
               [string]$Name=$Member.Name
               IF ($Name.Substring(0,1) -NE "_")
               {
                   IF (-NOT $Name.Contains("-"))
                   {
                       [String[]]$Definition=$Member.Definition.Split(" ")
                       [string]$PropertyType=$Definition[2]
                       IF ($ValidPropertyType[$PropertyType]) 
                       {
                           $ReturnType=$Definition[0]
                           If ($ValidReturnType[$ReturnType])
                           {
                                $String=$String+"           $Name="+"$"+"$Class.$Name `r`n"
                           }
                       }
                    }
                }
            }
        }
        $String=$String+"}) `r`n"
        $String
    }
    Catch [System.Exception]
    {
        Write-Verbose "Get-PSObjectTextFromObject Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Prepare ListView For ValueType Instance
Function Prepare-ListViewForValueType
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView
     )
     Try
     {
        Write-Verbose "Prepare-ListViewForValueType"
        Clear-ListView $ListView
        $ListView.View = [System.Windows.Forms.View]::Details
        $Column=$ListView.Columns.Add("Type")
        $Column.Width=$ListView.Width *.45
        $Column=$ListView.Columns.Add("Value")
        $Column.Width=$ListView.Width *.54
     }
    Catch [System.Exception]
    {
        Write-Verbose "Prepare-ListViewForValueType Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Prepare ListView For Object Instance
Function Prepare-ListViewForObject
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView
     )
     Try
     {
        Write-Verbose "Prepare-ListViewForObject"
        Clear-ListView $ListView
        $ListView.View = [System.Windows.Forms.View]::Details
        $Column=$ListView.Columns.Add("Property")
        $Column.Width=$ListView.Width *.45
        $Column=$ListView.Columns.Add("Value")
        $Column.Width=$ListView.Width *.54
     }
    Catch [System.Exception]
    {
        Write-Verbose "Prepare-ListViewForObject Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Prepare ListView For Array Instance
Function Prepare-ListViewForArray
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView
     )
     Try
     {
        Write-Verbose "Prepare-ListViewForArray"
        Clear-ListView $ListView
        $ListView.View = [System.Windows.Forms.View]::Details
        $Column=$ListView.Columns.Add("Element")
        $Column.Width=$ListView.Width *.45
        $Column=$ListView.Columns.Add("Value")
        $Column.Width=$ListView.Width *.54
     }
    Catch [System.Exception]
    {
        Write-Verbose "Prepare-ListViewForArray Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Prepare ListView For Collection Instance
Function Prepare-ListViewForCollection
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView
     )
     Try
     {
        Write-Verbose "Prepare-ListViewForCollection"
        Clear-ListView $ListView
        $ListView.View = [System.Windows.Forms.View]::Details
        $Column=$ListView.Columns.Add("Item")
        $Column.Width=$ListView.Width *.45
        $Column=$ListView.Columns.Add("Value")
        $Column.Width=$ListView.Width *.54
     }
    Catch [System.Exception]
    {
        Write-Verbose "Prepare-ListViewForCollection Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Prepare ListView For HashTable Instance
Function Prepare-ListViewForHashTable
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView
     )
     Try
     {
        Write-Verbose "Prepare-ListViewForHashTable"
        Clear-ListView $ListView
        $ListView.View = [System.Windows.Forms.View]::Details
        $Column=$ListView.Columns.Add("Key")
        $Column.Width=$ListView.Width *.45
        $Column=$ListView.Columns.Add("Value")
        $Column.Width=$ListView.Width *.54
     }
    Catch [System.Exception]
    {
        Write-Verbose "Prepare-ListViewForHashTable Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Process a Boolean Property
Function Process-BooleanProperty
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)] 
        [System.String]$PropertyName,
        [Parameter(Mandatory=$true)] 
        [System.Boolean]$Boolean
     )
     Try
     {
        Write-Verbose "Process-BooleanProperty PropertyName=$PropertyName Value=$Boolean"
        $Item=$ListView.Items.Add($PropertyName)
        IF ($Boolean)
        {
            $Item.SubItems.Add("True")
        }
        Else
        {
            $Item.SubItems.Add("False")
        }
        $Script:POEValues += "$PropertyName = $Boolean `r`n"
     }
    Catch [System.Exception]
    {
        Write-Verbose "Process-BooleanProperty Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Process a ValueType Property
Function Process-ValueTypeProperty
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)] 
        [System.String]$PropertyName,
        [Parameter(Mandatory=$true)] 
        [Object]$ValueType
     )
     Try
     {
        Write-Verbose "Process-ValueTypeProperty PropertyName=$PropertyName Value=$ValueType"
        $Item=$ListView.Items.Add($PropertyName)
        $Item.SubItems.Add($ValueType.ToString())
        $Script:POEValues += "$PropertyName = $ValueType `r`n"
     }
    Catch [System.Exception]
    {
        Write-Verbose "Process-ValueTypeProperty Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Process a String Property
Function Process-StringProperty
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)] 
        [System.String]$PropertyName,
        [Parameter(Mandatory=$true)] 
        [System.String]$String
     )
     Try
     {
        Write-Verbose "Process-StringProperty PropertyName=$PropertyName Value=$String"
        $Item=$ListView.Items.Add($PropertyName)
        $Item.SubItems.Add($String)
        $Script:POEValues += "$PropertyName = $String `r`n"
     }
    Catch [System.Exception]
    {
        Write-Verbose "Process-StringProperty Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Process a ValueType Note Property
Function Process-ValueTypeNoteProperty
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)] 
        [String]$PropertyName,
        [Parameter(Mandatory=$true)] 
        [Object]$PropertyValue
     )
     Try
     {
        Write-Verbose "Process-ValueTypeNoteProperty PropertyName=$PropertyName PropertyValue=$PropertyValue"
        $Item=$ListView.Items.Add($PropertyName)
        $Item.SubItems.Add($PropertyValue)
        $Script:POEValues += "$PropertyName = $PropertyValue `r`n"
     }
    Catch [System.Exception]
    {
        Write-Verbose "Process-ValueTypeNoteProperty Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Process An Enum Property
Function Process-EnumProperty
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)] 
        [String]$PropertyName,
        [Parameter(Mandatory=$true)] 
        [Object]$Enum
     )
     Try
     {
        Write-Verbose "Process-EnumProperty PropertyName=$PropertyName PropertyValue=$Enum"
        $Item=$ListView.Items.Add($PropertyName)
        $Item.SubItems.Add("[$($Enum.GetType().FullName)]::$($Enum.ToString())")
        $Script:POEValues += "$PropertyName = [$($Enum.GetType().FullName)]::$($Enum.ToString()) `r`n"
     }
    Catch [System.Exception]
    {
        Write-Verbose "Process-EnumProperty Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Process An Struct Property
Function Process-StructProperty
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.TreeView]$TreeView,
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)] 
        [String]$PropertyName,
        [Parameter(Mandatory=$true)] 
        [Object]$Struct
     )
     Try
     {
        Write-Verbose "Process-StructProperty PropertyName=$PropertyName"
        Write-Verbose "Process-StructProperty ObjectType=$($Struct.GetType().FullName)"
        Process-ValueTypeProperty $ListView $PropertyName (Get-PropertyFriendlyName $Struct)
        If ($mnuStructs.Checked)
        {
            Add-TreeNode $TreeView.SelectedNode $Struct $PropertyName
        }
     }
    Catch [System.Exception]
    {
        Write-Verbose "Process-StructProperty Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Process an Object Property
Function Process-ObjectProperty
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.TreeView]$TreeView,
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)] 
        [String]$PropertyName,
        [Parameter(Mandatory=$true)] 
        [Object]$Object
     )
     Try
     {
        Write-Verbose "Process-ObjectProperty PropertyName=$PropertyName"
        Write-Verbose "Process-ObjectProperty ObjectType=$($Object.GetType().FullName)"
        Process-ValueTypeProperty $ListView $PropertyName (Get-PropertyFriendlyName $Object)
        If ($mnuObjects.Checked)
        {
            Add-TreeNode $TreeView.SelectedNode $Object $PropertyName
        }
     }
    Catch [System.Exception]
    {
        Write-Verbose "Process-ObjectProperty Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Process an Array Property
Function Process-ArrayProperty
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.TreeView]$TreeView,
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)] 
        [System.Windows.Forms.StatusBar]$StatusBar,
        [Parameter(Mandatory=$true)] 
        [String]$PropertyName,
        [Parameter(Mandatory=$true)] 
        [Object]$Array
     )
     Try
     {
        $ArrayType = $Array.GetType().FullName
        $ArrayCount = $Array.Count
        Write-Verbose "Process-ArrayInstance $ArrayType.Count=$ArrayCount"
        $StatusBarText = $StatusBar.Text
        $Node =Add-TreeNode $TreeView.SelectedNode $Array $PropertyName
        [Int]$I=0
        ForEach($Object in $Array)
        {
            $StatusBar.Text = "$StatusBarText $ArrayType ($I of $ArrayCount)"
            $ChildNode =Add-TreeNode $Node $Object
            $I++
        }
        If ($mnuCollections.Checked)
        {
            Process-ValueTypeProperty $ListView $PropertyName (Get-PropertyFriendlyName $Array)
        }
        $StatusBar.Text = $StatusBarText
     }
    Catch [System.Exception]
    {
        Write-Verbose "Process-ArrayProperty Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Process A Collection Property
Function Process-CollectionProperty
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.TreeView]$TreeView,
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)] 
        [System.Windows.Forms.StatusBar]$StatusBar,
        [Parameter(Mandatory=$true)] 
        [String]$PropertyName,
        [Parameter(Mandatory=$true)] 
        [Object]$Collection
     )
     Try
     {
        $CollectionType = $Collection.GetType().FullName
        $CollectionCount = $Collection.Count
        Write-Verbose "Process-CollectionInstance $CollectionType.Count=$CollectionCount"
        $StatusBarText = $StatusBar.Text
        $Node =Add-TreeNode $TreeView.SelectedNode $Collection $PropertyName
        [Int]$I=0
        ForEach($Object in $Collection)
        {
            $StatusBar.Text = "$StatusBarText $CollectionType ($I of $CollectionCount)"
            $ChildNode =Add-TreeNode $Node $Object
            $I++
        }
        If ($mnuCollections.Checked)
        {
            Process-ValueTypeProperty $ListView $PropertyName (Get-PropertyFriendlyName $Collection)
        }
        $StatusBar.Text = $StatusBarText
     }
    Catch [System.Exception]
    {
        Write-Verbose "Process-CollectionProperty Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Process A HashTable Property
Function Process-HashTableProperty
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.TreeView]$TreeView,
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)] 
        [System.Windows.Forms.StatusBar]$StatusBar,
        [Parameter(Mandatory=$true)] 
        [String]$PropertyName,
        [Parameter(Mandatory=$true)] 
        [Object]$HashTable
     )
     Try
     {
        $HashTableType = $HashTable.GetType().FullName
        $HashTableCount = $HashTable.Count
        Write-Verbose "Process-HashTableProperty $HashTableType.Count=$HashTableCount"
        $StatusBarText = $StatusBar.Text
        $Node=Add-TreeNode $TreeView.SelectedNode $HashTable $PropertyName
        [Int]$I=0
        $Keys=$HashTable.Keys
        ForEach($Key In $Keys)
        {
            $StatusBar.Text = "$StatusBarText $HashTableType ($($I+1) of $HashTableCount)"
            IF ($HashTable[$Key] -NE $Null)
            {
               $ChildNode=Add-TreeNode $Node $HashTable[$Key] $Key
            }
            Else
            {
               $ChildNode=Add-TreeNode $Node "Null" $Key
            }
            $I++
        }
        If ($mnuCollections.Checked)
        {
            Process-ValueTypeProperty $ListView $PropertyName (Get-PropertyFriendlyName $HashTable)
        }
        $StatusBar.Text = $StatusBarText
     }
    Catch [System.Exception]
    {
        Write-Verbose "Process-HashTableProperty Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Process A Dictionary Property
Function Process-DictionaryProperty
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.TreeView]$TreeView,
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)] 
        [System.Windows.Forms.StatusBar]$StatusBar,
        [Parameter(Mandatory=$true)] 
        [String]$PropertyName,
        [Parameter(Mandatory=$true)] 
        [Object]$Dictionary
     )
     Try
     {
        $DictionaryType = $Dictionary.GetType().FullName
        $DictionaryCount = $Dictionary.Count
        Write-Verbose "Process-DictionaryInstance $DictionaryType.Count=$DictionaryCount"
        $StatusBarText = $StatusBar.Text
        $Node=Add-TreeNode $TreeView.SelectedNode $Dictionary $PropertyName
        [Int]$I=0
        ForEach($Key In $Keys)
        {
            $StatusBar.Text = "$StatusBarText $DictionaryType ($($I+1) of $DictionaryCount)"
            IF ($Dictionary[$Key] -NE $Null)
            {
               $ChildNode=Add-TreeNode $Node $Dictionary[$Key] $Key
            }
            Else
            {
               $ChildNode=Add-TreeNode $Node "Null" $Key
            }
            $I++
        }
        If ($mnuCollections.Checked)
        {
            Process-ValueTypeProperty $ListView $PropertyName (Get-PropertyFriendlyName $Dictionary)
        }
        $StatusBar.Text = $StatusBarText
     }
    Catch [System.Exception]
    {
        Write-Verbose "Process-DictionaryProperty Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Process A Boolean Instance
Function Process-BooleanInstance
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.TreeView]$TreeView,
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)] 
        [System.Windows.Forms.StatusBar]$StatusBar,
        [Parameter(Mandatory=$true)] 
        [System.Boolean]$Boolean
    )
    Try
    {
        Write-Verbose "Process-BooleanInstance $Boolean"
        Prepare-ListViewForValueType $ListView
        Process-BooleanProperty $ListView "Boolean" $Boolean
        $StatusBar.Text="System.Boolean"
    }
    Catch [System.Exception]
    {
        Write-Verbose "Process-ArrayBoolean Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Process A ValueType Instance
Function Process-ValueTypeInstance
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.TreeView]$TreeView,
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)] 
        [System.Windows.Forms.StatusBar]$StatusBar,
        [Parameter(Mandatory=$true)] 
        [Object]$ValueType
    )
    Try
    {
        Write-Verbose "Process-ValueTypeInstance $($ValueType.GetType().Name)=$ValueType"
        Prepare-ListViewForValueType $ListView
        Process-ValueTypeProperty $ListView $ValueType.GetType().Name $ValueType
        $StatusBar.Text="$($ValueType.GetType().FullName)"
    }
    Catch [System.Exception]
    {
        Write-Verbose "Process-ValueTypeInstance Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Process A String Instance
Function Process-StringInstance
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.TreeView]$TreeView,
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)] 
        [System.Windows.Forms.StatusBar]$StatusBar,
        [Parameter(Mandatory=$true)] 
        [System.String]$String
    )
    Try
    {
        Write-Verbose "Process-StringInstance $($String.GetType().Name)=$String"
        Prepare-ListViewForValueType $ListView
        Process-ValueTypeProperty $ListView "String" $String
        Process-ValueTypeProperty $ListView "Length" $String.Length
        $StatusBar.Text="$($String.GetType().FullName)"
    }
    Catch [System.Exception]
    {
        Write-Verbose "Process-StringInstance Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Process A Enum Instance
Function Process-EnumInstance
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.TreeView]$TreeView,
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)] 
        [System.Windows.Forms.StatusBar]$StatusBar,
        [Parameter(Mandatory=$true)] 
        [Object]$Enum
    )
    Try
    {
        Write-Verbose "Process-EnumInstance [$($Enum.GetType().FullName)]::$Enum"
        Prepare-ListViewForValueType $ListView
        Process-EnumProperty $ListView $Enum.GetType().Name $Enum
        $StatusBar.Text="$($Enum.GetType().FullName)"
    }
    Catch [System.Exception]
    {
        Write-Verbose "Process-EnumInstance Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Gets object's property
Function Get-ObjectInstanceProperty
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [Object]$Object,
        [Parameter(Mandatory=$true)]
        [System.String]$Property,
        [Parameter(Mandatory=$true)]
        [System.String]$PropertyType
    )
    Try
    {
        Write-Verbose "Get-ObjectInstanceProperty Object=$($Object.GetType().FullName) Property=$Property"
        $ObjectProperty=$Null
        $String="[$PropertyType]"+"$"+"ObjectProperty="+"$"+"Object.$Property"
        Write-Verbose "Get-ObjectInstanceProperty String=$String"
        Invoke-Expression $String
        Write-Verbose "Get-ObjectInstanceProperty ObjectProperty=$($ObjectProperty.GetType().FullName)"
        $ObjectProperty
    }
    Catch [System.Exception]
    {
        Write-Verbose "Get-ObjectInstanceProperty Catch"
        Write-Error $_.Exception.Message
        $Null
    }
}

#Process An Object Instance
Function Process-ObjectInstance
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.TreeView]$TreeView,
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)] 
        [System.Windows.Forms.StatusBar]$StatusBar,
        [Parameter(Mandatory=$true)]
        [Object]$Object
     )
     Try
     {
        $ObjectType = $Object.GetType().FullName
        Write-Verbose "Process-ObjectInstance ObjectType=$ObjectType"
        $Node=$TreeView.SelectedNode
        $Node.Nodes.Clear()
        Prepare-ListViewForObject $ListView
        $Members=Get-Member -InputObject $Object 
        $MemberCount = $Members.Count
        $MemberIndex = 0
        [string]$String=""
        ForEach ($Member in $Members)
        {
            Write-Verbose " "
            [String]$MemberTypeName=$Member.TypeName
            Write-Verbose "Process-ObjectInstance MemberTypeName=$MemberTypeName"
            [String]$MemberName=$Member.Name
            Write-Verbose "Process-ObjectInstance MemberName=$MemberName"
            [String]$MemberType=$Member.MemberType
            $MemberIndex++
            $StatusBar.Text = "Processing $MemberTypeName $MemberType[$MemberIndex of $MemberCount] $MemberName"
            If ($Script:IsValidMemberType[$MemberType])
            {
                Write-Verbose "Process-ObjectInstance MemberType=$MemberType"
                If (Get-IsValidMemberName $MemberName $MemberTypeName)
                {
                    [String[]]$Definition=$Member.Definition.Split(" ")
                    [String]$PropertyType=$Definition[2]
                    Write-Verbose "Process-ObjectInstance PropertyType=$PropertyType"
                    [String]$MemberReturnType=$Definition[0]
                    Write-Verbose "Process-ObjectInstance MemberReturnType=$MemberReturnType"
                    If ($MemberType -EQ "Property")
                    {
                        If ($Script:IsValidPropertyType[$PropertyType])
                        {
                            $ObjectProperty=$Null
                            $String="[$MemberReturnType]"+"$"+"ObjectProperty="+"$"+"Object.$MemberName"
                            Write-Verbose "Process-ObjectInstance InvokeProperty=$String"
                            
                            Trap { Write-Verbose "Process-ObjectInstance Trapped Error"
                                   Continue
                                 }
                            Invoke-Expression $String
                            If ($ObjectProperty -NE $Null)
                            {
                                Write-Verbose "Process-ObjectInstance ObjectProperty.Type=$($ObjectProperty.GetType().FullName)"
#                                If ($mnuCaptureTypes.Checked)
#                                {
#                                    Add-PSTypeNames $ObjectProperty
#                                }
                                $ObjectPropertyType = Get-PropertyReturnType $ObjectProperty
                                Write-Verbose "Process-ObjectInstance ObjectPropertyType=$ObjectPropertyType"
                                Switch($ObjectPropertyType)
                                {
                                    "Boolean" 
                                    {
                                        Write-Verbose "Process-ObjectInstance Boolean"
                                        Process-BooleanProperty $ListView $MemberName $ObjectProperty
                                        Continue
                                    }
                                    "ValueType" 
                                    {
                                        Write-Verbose "Process-ObjectInstance ValueType"
                                        Process-ValueTypeProperty $ListView $MemberName $ObjectProperty
                                        Continue
                                    }
                                    "String" 
                                    {
                                        Write-Verbose "Process-ObjectInstance String"
                                        If ([string]::IsNullOrEmpty($ObjectProperty))
                                        {
                                            If ($ObjectProperty -EQ $Null)
                                            {
                                                Process-StringProperty $ListView $MemberName "NULL"
                                            }
                                            Else
                                            {
                                                Process-StringProperty $ListView $MemberName "[System.String]::EmptyString"
                                            }
                                        }
                                        Else
                                        {
                                            Process-StringProperty $ListView $MemberName $ObjectProperty
                                        }
                                        Continue
                                    }
                                    "Enum" 
                                    {
                                        Write-Verbose "Process-ObjectInstance Enum"
                                        Process-EnumProperty $ListView $MemberName $ObjectProperty
                                        Continue
                                    }
                                    "Struct" 
                                    {
                                        Write-Verbose "Process-ObjectInstance Struct"
                                        Process-StructProperty $TreeView $ListView $MemberName $ObjectProperty 
                                        Continue
                                    }
                                    "Object" 
                                    {
                                        Write-Verbose "Process-ObjectProperty Object"
                                        Process-ObjectProperty $TreeView $ListView $MemberName $ObjectProperty 
                                        Continue
                                    }
                                    "Array" 
                                    {
                                        Write-Verbose "Process-ObjectProperty Array"
                                        Process-ArrayProperty $TreeView $ListView $StatusBar $MemberName $ObjectProperty 
                                        Continue
                                    }
                                    "Collection" 
                                    {
                                        Write-Verbose "Process-ObjectInstance Collection"
                                        Process-CollectionProperty $TreeView $ListView $StatusBar $MemberName $ObjectProperty 
                                        Continue
                                    }
                                    "HashTable" 
                                    {
                                        Write-Verbose "Process-ObjectInstance HashTable"
                                        Process-HashTableProperty $TreeView $ListView $StatusBar $MemberName $ObjectProperty 
                                        Continue
                                    }
                                    "Dictionary" 
                                    {
                                        Write-Verbose "Process-ObjectInstance Dictionary"
                                        Process-DictionaryProperty $TreeView $ListView $StatusBar $MemberName $ObjectProperty 
                                        Continue
                                    }
                                    Default 
                                    {
                                        Write-Verbose "Process-ObjectInstance Unknown"
                                        Process-ObjectProperty $TreeView $ListView $MemberName $ObjectProperty 
                                        Continue
                                    }
                                }
                            }
                            Else
                            {
                                Write-Verbose "Process-ObjectInstance PropertyName=$MemberName Is Null"
                                If ($mnuNulls.Checked)
                                {
                                    Process-ValueTypeProperty $ListView $MemberName "Null"
                                }
                            }
                        }
                        Else
                        {
                            Write-Verbose "Process-ObjectInstance MemberName=$MemberName PropertyType not valid"
                        }
                    }
                    Else
                    {
                        Write-Verbose "Process-ObjectInstance MemberName=$MemberName Not a Property"
                        [String]$PropertyName=$Definition[1]
                        [String[]]$PropertyNameParts=$PropertyName.Split("=")
                        [String]$PropertyKey=$PropertyNameParts[0]
                        [String]$PropertyValue=$PropertyNameParts[1]
                        Write-Verbose "Process-ObjectInstance PropertyKey=$PropertyKey PropertyValue=$PropertyValue"
                        If($Script:IsPropertyValueType[$MemberReturnType])
                        {
                            Process-ValueTypeNoteProperty $ListView $PropertyKey $PropertyValue
                        }
                        Else
                        {
                            Write-Verbose "Process-ObjectInstance MemberTypeName=$MemberTypeName is not PropertyValueType"
                        }
                    }
                }
                Else
                {
                    Write-Verbose "Process-ObjectInstance MemberName=$MemberName not valid"
                }
            }
            Else
            {
                Write-Verbose "Process-ObjectInstance MemberType=$MemberType not valid"
            }
        }
        $StatusBar.Text = "$ObjectType"

    }
    Catch [System.Exception]
    {
        Write-Verbose "Process-ObjectInstance Catch"
        Write-Error $_.Exception.Message
    }
}

#Process An Array Instance
Function Process-ArrayInstance
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.TreeView]$TreeView,
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.StatusBar]$StatusBar,
        [Parameter(Mandatory=$true)] 
        [Object]$Array
    )
    Try
    {
        $ArrayType = $Array.GetType().FullName
        $ArrayCount = $Array.Count
        Write-Verbose "Process-ArrayInstance $ArrayType.Count=$ArrayCount"
        $Node = $TreeView.SelectedNode
        $Node.Nodes.Clear()
        Prepare-ListViewForArray $ListView
        [Int]$I=0
        ForEach($Object in $Array)
        {
            $StatusBar.Text = "$ArrayType ($($I+1) of $ArrayCount)"
            $ChildNode =Add-TreeNode $Node $Object
            Process-ValueTypeProperty $ListView "$($Node.Text)[$I]" (Get-PropertyFriendlyName $Object)
            $I++
        }
        $StatusBar.Text = "$ArrayType.Count=$ArrayCount"
    }
    Catch [System.Exception]
    {
        Write-Verbose "Process-ArrayInstance Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Process A Collection Instance
Function Process-CollectionInstance
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.TreeView]$TreeView,
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.StatusBar]$StatusBar,
        [Parameter(Mandatory=$true)] 
        [Object]$Collection
    )
    Try
    {
        $CollectionType = $Collection.GetType().FullName
        $CollectionCount = $Collection.Count
        Write-Verbose "Process-CollectionInstance $CollectionType.Count=$CollectionCount"
        $Node = $TreeView.SelectedNode
        $Node.Nodes.Clear()
        Prepare-ListViewForCollection $ListView
        [Int]$I=0
        ForEach($Object In $Collection)
        {
            $StatusBar.Text = "$CollectionType ($($I+1) of $CollectionCount)"
            $ChildNode =Add-TreeNode $Node $Object
            Process-ValueTypeProperty $ListView "$($Node.Text)[$I]" (Get-PropertyFriendlyName $Object)
            $I++
        }
        $StatusBar.Text = "$CollectionType.Count=$CollectionCount"
    }
    Catch [System.Exception]
    {
        Write-Verbose "Process-CollectionInstance Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Process A HashTable Instance
Function Process-HashTableInstance
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.TreeView]$TreeView,
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)] 
        [System.Windows.Forms.StatusBar]$StatusBar,
        [Parameter(Mandatory=$true)] 
        [Object]$HashTable
    )
    Try
    {
        $HashTableType=$HashTable.GetType().FullName
        $HashTableCount=$HashTable.Count
        Write-Verbose "Process-HashTableInstance $HashTableType.Count=$HashTableCount"
        $Node = $TreeView.SelectedNode
        $Node.Nodes.Clear()
        Prepare-ListViewForHashTable $ListView
        $Keys=$HashTable.Keys
        [Int]$I=0
        ForEach($Key In $Keys)
        {
            $StatusBar.Text = "$HashTableType ($($I+1) of $HashTableCount)"
            IF ($HashTable[$Key] -NE $Null)
            {
                IF ($HashTable[$Key].Value -NE $NULL)
                {
                   $ChildNode=Add-TreeNode $Node $HashTable[$Key].Value $Key
                   Process-ValueTypeProperty $ListView $Key (Get-PropertyFriendlyName $HashTable[$Key].Value)
                }
                Else
                {
                   $ChildNode=Add-TreeNode $Node $HashTable[$Key] $Key
                   Process-ValueTypeProperty $ListView $Key (Get-PropertyFriendlyName $HashTable[$Key])
                }
            }
            Else
            {
               $ChildNode=Add-TreeNode $Node $HashTable[$Key] $Key
               Process-ValueTypeProperty $ListView $Key ""
            }
            $I++
        }
        $StatusBar.Text = "$HashTableType.Count=$HashTableCount"
    }
    Catch [System.Exception]
    {
        Write-Verbose "Process-HashTableInstance Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Process A Dictionary Instance
Function Process-DictionaryInstance
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.TreeView]$TreeView,
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true)] 
        [System.Windows.Forms.StatusBar]$StatusBar,
        [Parameter(Mandatory=$true)] 
        [Object]$Dictionary
    )
    Try
    {
        $DictionaryType=$Dictionary.GetType().FullName
        $DictionaryCount=$Dictionary.Count
        Write-Verbose "Process-DictionaryInstance $DictionaryType.Count=$DictionaryCount"
        $Node = $TreeView.SelectedNode
        $Node.Nodes.Clear()
        Prepare-ListViewForDictionary $ListView
        $Keys=$Dictionary.Keys
        [Int]$I=0
        ForEach($Key In $Keys)
        {
            $StatusBar.Text = "$DictionaryType ($($I+1) of $DictionaryCount)"
            IF ($Dictionary[$Key] -NE $Null)
            {
                IF ($Dictionary[$Key].Value -NE $NULL)
                {
                   $ChildNode=Add-TreeNode $Node $Dictionary[$Key].Value $Key
                   Process-ValueTypeProperty $ListView $Key (Get-PropertyFriendlyName $Dictionary[$Key].Value)
                }
                Else
                {
                   $ChildNode=Add-TreeNode $Node $Dictionary[$Key] $Key
                   Process-ValueTypeProperty $ListView $Key (Get-PropertyFriendlyName $Dictionary[$Key])
                }
            }
            Else
            {
               $ChildNode=Add-TreeNode $Node $Dictionary[$Key] $Key
               Process-ValueTypeProperty $ListView $Key ""
            }
            $I++
        }
        $StatusBar.Text = "$DictionaryType.Count=$DictionaryCount"
    }
    Catch [System.Exception]
    {
        Write-Verbose "Process-DictionaryInstance Catch"
        Write-Verbose $_.Exception.Message
    }
}

#region Form
#region Form and Control Events

#Event Handler for the Powershell prompt execute button
Function ButtonExecute_Click
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True,
                Position=0)] 
    [System.Object] $sender
  )
    Try
    {
        Write-Verbose "ButtonExecute_Click"
        $TextBoxOutput.Text
        $Output = $ExecutionContext.InvokeCommand.InvokeScript($TextBoxPowerShell.Text)
        IF ($Output -NE "")
        {
            ForEach ($Line In $OutPut)
            {
                $TextBoxOutput.Text += "$Line `r`n"
            }
        }
    }
    Catch [System.Exception]
    {
        Write-Verbose "ButtonExecute_Click Catch"
        Write-Error $_.Exception.Message
    }
}

#Event Handler for the SplitContainer event SplitterMoved
Function SplitContainer_SplitterMoved
{
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True,
                Position=0)] 
    [System.Object] $sender,
    [parameter(Mandatory=$True,
                Position=1)] 
    [System.Windows.Forms.SplitterEventArgs] $e
  )
    Write-Verbose "SplitContainer_SplitterMoved"
    Form_Resize
}

#Event Handler for the TreeView event AfterSelect
Function TreeView_AfterSelect
{ 
  [CmdletBinding()] 
  param ( 
    [parameter(Mandatory=$True)] 
    [Object]$Sender, 
    [parameter(Mandatory=$True)] 
    [Object]$EventArg 
  ) 
    Try 
    { 
        Write-Verbose ""
        Write-Verbose "TreeView_AfterSelect Sender.Name=$($Sender.Name) EventArg.Node=$($EventArg.Node.Text)"
        $Sender.SelectedNode = $EventArg.Node 
        $TreeView=$Sender
        $ListView=$Sender.Tag
        $StatusBar=$ListView.Tag
        $Node=$Sender.SelectedNode
        $Object = $Node.Tag
        $Script:POEValues = ""
        $TextBoxValues.Text = $Script:POEValues
        If (Get-IsWMIObject $Object)
        {
            Write-Verbose "TreeView_AfterSelect WMIObject"
            Process-WMIObjectInstance $TreeView $ListView $StatusBar $Node
            $ObjectType="WMIObject"
        }
        Else
        {
            $ObjectType = Get-InstanceType $Object
            Write-Verbose "TreeView_AfterSelect ObjectType=$ObjectType"
            Switch($ObjectType)
            {
                "Boolean" 
                {
                    Write-Verbose "TreeView_AfterSelect Boolean"
                    Process-BooleanInstance $TreeView $ListView $StatusBar $Object
                    Continue
                }
                "ValueType" 
                {
                    Write-Verbose "TreeView_AfterSelect ValueType"
                    Process-ValueTypeInstance $TreeView $ListView $StatusBar $Object
                    Continue
                }
                "String" 
                {
                    Write-Verbose "TreeView_AfterSelect String"
                    If([System.String]::IsNullOrEmpty($Object))
                    {
                        If($Object -EQ $Null)
                        {
                            Process-StringInstance $TreeView $ListView $StatusBar "Null"
                        }
                        Else
                        {
                            Process-StringInstance $TreeView $ListView $StatusBar "[System.String]::EmptyString"
                        }
                    }
                    Else
                    {
                        Process-StringInstance $TreeView $ListView $StatusBar $Object
                    }
                    Continue
                }
                "Enum" 
                {
                    Write-Verbose "TreeView_AfterSelect Enum"
                    Process-EnumInstance $TreeView $ListView $StatusBar $Object
                    Continue
                }
                "Object" 
                {
                    Write-Verbose "TreeView_AfterSelect Object"
                    Process-ObjectInstance $TreeView $ListView $StatusBar $Object
                    Continue
                }
                "Array" 
                {
                    Write-Verbose "TreeView_AfterSelect Array"
                    Process-ArrayInstance $TreeView $ListView $StatusBar $Object
                    Continue
                }
                "Collection" 
                {
                    Write-Verbose "TreeView_AfterSelect Collection"
                    Process-CollectionInstance $TreeView $ListView $StatusBar $Object
                    Continue
                }
                "HashTable" 
                {
                    Write-Verbose "TreeView_AfterSelect HashTable"
                    Process-HashTableInstance $TreeView $ListView $StatusBar $Object
                    Continue
                }
                "Dictionary" 
                {
                    Write-Verbose "TreeView_AfterSelect Dictionary"
                    Process-DictionaryInstance $TreeView $ListView $StatusBar $Object
                    Continue
                }
                Default 
                {
                    Write-Verbose "TreeView_AfterSelect Unknown"
                    Process-ObjectInstance $TreeView $ListView $StatusBar $Object
                    Continue
                }
            }
            If ($Sender.Name -EQ "TreeViewInstance")
            {
                Write-Verbose "TreeView_AfterSelect Fill-ListViewClass"
                Fill-ListViewClass $ListViewClass $Object
                If ($ObjectType -EQ "WMIObject")
                {
                    Write-Verbose "TreeView_AfterSelect Get-PSObjectTextFromObject WMIObject"
                    $TextBoxPSObject.Text = Get-PSObjectTextFromObject $Node.Parent.Tag.Class $Object
                    $StatusBar.Text = $Node.Parent.Tag.Class+" - "+$Node.Parent.Tag.Description
                }
                ElseIf($ObjectType -EQ "PSObject")
                {
                    Write-Verbose "TreeView_AfterSelect Get-PSObjectTextFromObject PSObject"
                    $TextBoxPSObject.Text = Get-PSObjectTextFromObject $Object.GetType().Name $Object
                }
                Else
                {
                    Write-Verbose "TreeView_AfterSelect Get-PSObjectTextFromObject Object"
                    $TextBoxPSObject.Text = Get-PSObjectTextFromObject $Object.GetType().Name $Object
                    #$StatusBar.Text = $Object.GetType().FullName
                }
                $TextBoxValues.Text = $Script:POEValues
                Write-Verbose "TreeView_AfterSelect GetTypeNames"
                If ($Object -IS [System.Type])
                {
                    [String[]]$PSTypeNames = @("System.Type","System.Object")
                }
                ElseIf ($Object -IS [System.Reflection.Assembly])

                {
                    [String[]]$PSTypeNames = @("System.Reflection.Assembly","System.Object")
                }
                ElseIf ($Object -IS [System.Management.Automation.PSCustomObject])

                {
                    [String[]]$PSTypeNames = @("System.Management.Automation.PSCustomObject","System.Object")
                }
                Else
                {
                    [String[]]$PSTypeNames = $Object.PSTypeNames
                }
                $TreeViewInterface.Nodes.Clear()
                Clear-ListView $ListViewInterface
                For ($I=0;$I -LT $PSTypeNames.Count;$I++)
                {
                    Write-Verbose "TreeView_AfterSelect PSTypeName=$($PSTypeNames[$I])"
                    IF ($PSTypeNames[$I].Contains("#"))
                    {
                    }
                    Else
                    {
                        $PSTypeName =  $PSTypeNames[$I]
                        Trap {Continue}
                        $Type = $PSTypeName -As [System.Type]
                        If ($Type -NE $Null)
                        {
                            Add-TreeNode $TreeViewInterface $Type "[$($Type.FullName)]"
                        }
                        Else
                        {
                            IF ($I -EQ 0)
                            {
                                $Type=$Object.GetType()
                                Add-TreeNode $TreeViewInterface $Type "[$($Type.FullName)]"
                            }
                        }
                    }
                }
#                If ($mnuCaptureTypes.Checked)
#                {
#                    Add-PSTypeNames $Object
#                }
            }
            Else
            {
                #$StatusBar.Text = $Object.GetType().FullName
            }
        }
    } 
    Catch [System.Exception]
    {
        Write-Verbose "TreeView_AfterSelect Catch"
        Write-Error $_.Exception.Message
    }
} 

#Event Handler for the form event Load
Function Form_Load
{
  [CmdletBinding()] 
  param ( 
  )
    Write-Verbose "Form_Load"
    Get-PSObjectExplorerProfile
}

#Event Handler for the form event Resize
Function Form_Resize
{
  [CmdletBinding()] 
  param ( 
  )
    Write-Verbose "Form_Resize"
}

#endregion
#region Menu events

#Event Handler for the Exit Menu event Click
Function mnuExit_Click
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Verbose "mnuExit_Click"
        $Form.Close()
    } 
    Catch [System.Exception]
    {
        Write-Verbose "mnuExit_Click Catch"
        Write-Verbose $_.Exception.Message
    }
} 

#Event Handler for the View WMI Objects event Click
Function mnuWMIObjects_Click
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Verbose "mnuWMIObjects_Click"
        $mnuWMIObjects.Checked = ! $mnuWMIObjects.Checked
        IF ($mnuWMIObjects.Checked)
        {
           Add-WMITreeNodes $TreeViewInstance
        }
        Else
        {
           IF ($Script:WMIRootNode)
           {
               Remove-TreeNode $Script:WMIRootNode
               $Script:WMIClasses=$Null
           }
        }
    } 
    Catch [System.Exception]
    {
        Write-Verbose "mnuWMIObjects_Click Catch"
        Write-Verbose $_.Exception.Message
    }
} 

#Event Handler for the View Net Assemblies event Click
Function mnuNetAssemblies_Click
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Verbose "mnuNetAssemblies_Click"
        $mnuNetAssemblies.Checked = ! $mnuNetAssemblies.Checked
        IF ($mnuNetAssemblies.Checked)
        {
           $NetAssembliesNode = Add-NetAssembliesNode $TreeViewInstance
           $Script:POETreeNodes.Add("NetAssemblies",$NetAssembliesNode)
        }
        Else
        {
           $NetAssembliesNode = $Script:POETreeNodes["NetAssemblies"]
           IF ($NetAssembliesNode -NE $Null)
           {
               Remove-TreeNode $NetAssembliesNode
               $Script:POETreeNodes.Remove("NetAssemblies")
           }
        }
    } 
    Catch [System.Exception]
    {
        Write-Verbose "mnuWMIObjects_Click Catch"
        Write-Verbose $_.Exception.Message
    }
} 

#Event Handler for the View Net Classes event Click
Function mnuNetClasses_Click
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Verbose "mnuNetClasses_Click"
        $mnuNetClasses.Checked = ! $mnuNetClasses.Checked
        IF ($mnuNetClasses.Checked)
        {
           $NetClassesNode = Add-NetClassesNode $TreeViewInstance
           $Script:POETreeNodes.Add("NetClasses",$NetClassesNode)
           $TimerNetClasses.Enabled = $True
        }
        Else
        {
           $NetClassesNode = $Script:POETreeNodes["NetClasses"]
           IF ($NetClassesNode -NE $Null)
           {
               Remove-TreeNode $NetClassesNode
               $Script:POETreeNodes.Remove("NetClasses")
           }
        }
    } 
    Catch [System.Exception]
    {
        Write-Verbose "mnuNetClasses_Click Catch"
        Write-Verbose $_.Exception.Message
    }
} 

#Event Handler for the View PS Aliases event Click
Function mnuPSAliases_Click
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Verbose "mnuPSAliases_Click"
        $mnuPSAliases.Checked = ! $mnuPSAliases.Checked
        IF ($mnuPSAliases.Checked)
        {
           $PSAliasesNode = Add-PSAliasesNode $TreeViewInstance
           $Script:POETreeNodes.Add("PSAliases",$PSAliasesNode)
        }
        Else
        {
           $PSAliasesNode = $Script:POETreeNodes["PSAliases"]
           IF ($PSAliasesNode -NE $Null)
           {
               Remove-TreeNode $PSAliasesNode
               $Script:POETreeNodes.Remove("PSAliases")
           }
        }
    } 
    Catch [System.Exception]
    {
        Write-Verbose "mnuPSAliases_Click Catch"
        Write-Verbose $_.Exception.Message
    }
} 

#Event Handler for the View PS Commands event Click
Function mnuPSCommands_Click
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Verbose "mnuPSCommands_Click"
        $mnuPSCommands.Checked = ! $mnuPSCommands.Checked
        IF ($mnuPSCommands.Checked)
        {
           $PSCommandsNode = Add-PSCommandsNode $TreeViewInstance
           $Script:POETreeNodes.Add("PSCommands",$PSCommandsNode)
        }
        Else
        {
           $PSCommandsNode = $Script:POETreeNodes["PSCommands"]
           IF ($PSCommandsNode -NE $Null)
           {
               Remove-TreeNode $PSCommandsNode
               $Script:POETreeNodes.Remove("PSCommands")
           }
        }
    } 
    Catch [System.Exception]
    {
        Write-Verbose "mnuPSCommands_Click Catch"
        Write-Verbose $_.Exception.Message
    }
} 

#Event Handler for the View PS Drives event Click
Function mnuPSDrives_Click
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Verbose "mnuPSDrives_Click"
        $mnuPSDrives.Checked = ! $mnuPSDrives.Checked
        IF ($mnuPSDrives.Checked)
        {
           $PSDrivesNode = Add-PSDrivesNode $TreeViewInstance
           $Script:POETreeNodes.Add("PSDrives",$PSDrivesNode)
        }
        Else
        {
           $PSDrivesNode = $Script:POETreeNodes["PSDrives"]
           IF ($PSDrivesNode -NE $Null)
           {
               Remove-TreeNode $PSDrivesNode
               $Script:POETreeNodes.Remove("PSDrives")
           }
        }
    } 
    Catch [System.Exception]
    {
        Write-Verbose "mnuPSDrives_Click Catch"
        Write-Verbose $_.Exception.Message
    }
} 

#Event Handler for the View PS Modules event Click
Function mnuPSModules_Click
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Verbose "mnuPSModules_Click"
        $mnuPSModules.Checked = ! $mnuPSModules.Checked
        IF ($mnuPSModules.Checked)
        {
           $PSModulesNode = Add-PSModulesNode $TreeViewInstance
           $Script:POETreeNodes.Add("PSModules",$PSModulesNode)
        }
        Else
        {
           $PSModulesNode = $Script:POETreeNodes["PSModules"]
           IF ($PSModulesNode -NE $Null)
           {
               Remove-TreeNode $PSModulesNode
               $Script:POETreeNodes.Remove("PSModules")
           }
        }
    } 
    Catch [System.Exception]
    {
        Write-Verbose "mnuPSModules_Click Catch"
        Write-Verbose $_.Exception.Message
    }
} 

#Event Handler for the View PS Variables event Click
Function mnuPSVariables_Click
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Verbose "mnuPSVariables_Click"
        $mnuPSVariables.Checked = ! $mnuPSVariables.Checked
        IF ($mnuPSVariables.Checked)
        {
           $PSVariablesNode = Add-PSVariablesNode $TreeViewInstance
           $Script:POETreeNodes.Add("PSVariables",$PSVariablesNode)
        }
        Else
        {
           $PSVariablesNode = $Script:POETreeNodes["PSVariables"]
           IF ($PSVariablesNode -NE $Null)
           {
               Remove-TreeNode $PSVariablesNode
               $Script:POETreeNodes.Remove("PSVariables")
           }
        }
    } 
    Catch [System.Exception]
    {
        Write-Verbose "mnuPSVariables_Click Catch"
        Write-Verbose $_.Exception.Message
    }
} 

#Event Handler for the View WIN Features event Click
Function mnuWINFeature_Click
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Verbose "mnuWINFeature_Click"
        $mnuWINFeature.Checked = ! $mnuWINFeature.Checked
        IF ($mnuWINFeature.Checked)
        {
           $WINFeatureNode = Add-WINFeaturesNode $TreeViewInstance
           $Script:POETreeNodes.Add("WINFeatures",$WINFeatureNode)
        }
        Else
        {
           $WINFeatureNode = $Script:POETreeNodes["WINFeatures"]
           IF ($WINFeatureNode -NE $Null)
           {
               Remove-TreeNode $WINFeatureNode
               $Script:POETreeNodes.Remove("WINFeatures")
           }
        }
    } 
    Catch [System.Exception]
    {
        Write-Verbose "mnuWINFeature_Click Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Event Handler for the View WIN Processes event Click
Function mnuWINProcess_Click
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Verbose "mnuWINProcess_Click"
        $mnuWINProcess.Checked = ! $mnuWINProcess.Checked
        IF ($mnuWINProcess.Checked)
        {
           $WINProcessNode = Add-WINProcessesNode $TreeViewInstance
           $Script:POETreeNodes.Add("WINProcesses",$WINProcessNode)
        }
        Else
        {
           $WINProcessNode = $Script:POETreeNodes["WINProcesses"]
           IF ($WINProcessNode -NE $Null)
           {
               Remove-TreeNode $WINProcessNode
               $Script:POETreeNodes.Remove("WINProcesses")
           }
        }
    } 
    Catch [System.Exception]
    {
        Write-Verbose "mnuWINProcess_Click Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Event Handler for the View WIN Services event Click
Function mnuWINService_Click
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Verbose "mnuWINService_Click"
        $mnuWINService.Checked = ! $mnuWINService.Checked
        IF ($mnuWINService.Checked)
        {
           $WINServiceNode = Add-WINServicesNode $TreeViewInstance
           $Script:POETreeNodes.Add("WINServices",$WINServiceNode)
        }
        Else
        {
           $WINServiceNode = $Script:POETreeNodes["WINServices"]
           IF ($WINServiceNode -NE $Null)
           {
               Remove-TreeNode $WINServiceNode
               $Script:POETreeNodes.Remove("WINServices")
           }
        }
    } 
    Catch [System.Exception]
    {
        Write-Verbose "mnuWINService_Click Catch"
        Write-Verbose $_.Exception.Message
    }
}

#Event Handler for the View Test Cases event Click
Function mnuTestCases_Click
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Verbose "mnuTestCases_Click"
        $mnuTestCases.Checked = ! $mnuTestCases.Checked
        IF ($mnuTestCases.Checked)
        {
           $TestCasesNode = Add-TestCaseNodes $TreeViewInstance
           $Script:POETreeNodes.Add("POETestCases",$TestCasesNode)
        }
        Else
        {
           $TestCasesNode = $Script:POETreeNodes["POEtestCases"]
           IF ($TestCasesNode -NE $Null)
           {
               Remove-TreeNode $TestCasesNode
               $Script:POETreeNodes.Remove("POETestCases")
           }
        }
    } 
    Catch [System.Exception]
    {
        Write-Verbose "mnuTestCases_Click Catch"
        Write-Verbose $_.Exception.Message
    }
} 

#Event Handler for the Options Show Objects event Click
Function mnuObjects_Click
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Verbose "mnuObjects_Click"
        $mnuObjects.Checked = ! $mnuObjects.Checked
    } 
    Catch [System.Exception]
    {
        Write-Verbose "mnuObjects_Click Catch"
        Write-Verbose $_.Exception.Message
    }
} 

#Event Handler for the Options Show Structs event Click
Function mnuStructs_Click
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Verbose "mnuStructs_Click"
        $mnuStructs.Checked = ! $mnuStructs.Checked
    } 
    Catch [System.Exception]
    {
        Write-Verbose "mnuStructs_Click Catch"
        Write-Verbose $_.Exception.Message
    }
} 

#Event Handler for the Options Show Collections event Click
Function mnuCollections_Click
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Verbose "mnuCollections_Click"
        $mnuCollections.Checked = ! $mnuCollections.Checked
    } 
    Catch [System.Exception]
    {
        Write-Verbose "mnuCollections_Click Catch"
        Write-Verbose $_.Exception.Message
    }
} 

#Event Handler for the Options Show Nulls event Click
Function mnuNulls_Click
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Verbose "mnuNulls_Click"
        $mnuNulls.Checked = ! $mnuNulls.Checked
    } 
    Catch [System.Exception]
    {
        Write-Verbose "mnuNulls_Click Catch"
        Write-Verbose $_.Exception.Message
    }
} 

#Event Handler for the Options Show Empty Strings event Click
Function mnuEmptyStrings_Click
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Verbose "mnuEmptyStrings_Click"
        $mnuEmptyStrings.Checked = ! $mnuEmptyStrings.Checked
    } 
    Catch [System.Exception]
    {
        Write-Verbose "mnuEmptyStrings_Click Catch"
        Write-Verbose $_.Exception.Message
    }
} 

#Event Handler for the Help About event Click
Function mnuAbout_Click
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Verbose "mnuExit_Click"
        [System.Windows.Forms.MessageBox]::Show("PowerShell Object Explorer`n`nBy Brian Nadjiwon","PowerShell Object Explorer")
    } 
    Catch [System.Exception]
    {
        Write-Verbose "mnuExit_Click Catch"
        Write-Verbose $_.Exception.Message
    }
} 

Function TimerNetClasses_Tick
{
    [CmdletBinding()]
    param ()
    Try
    {
        Write-Debug "TimerNetClasses_Tick"
        $TimerNetClasses.Enabled=$False
        $NetClassIndex = $Script:POETreeNodes["NetClassIndex"]
        $NetAssembliesToProcess = $Script:POETreeNodes["NetAssembliesToProcess"]
        Add-SomeNetClasses $NetClassIndex
        $NetClassIndex++
        $Script:POETreeNodes["NetClassIndex"]=$NetClassIndex 
        $mnuStatus.Text="Loading Class $NetClassIndex"
        IF ($NetAssembliesToProcess.Count -GT 0)
        {
            $TimerNetClasses.Enabled = $True
        }
        Else
        {
            $mnuStatus.Text=""
            $Script:POETreeNodes.Remove("NetClassesList")
            $Script:POETreeNodes.Remove("NetClassIndex")
            $Script:POETreeNodes.Remove("NetClassesProcessed")
            $Script:POETreeNodes.Remove("NetAssemblyClasses")
            $Script:POETreeNodes.Remove("NetAssemblyMaxClasses")
            $Script:POETreeNodes.Remove("NetAssembliesToProcess")
        }
    }
    Catch [System.Exception]
    {
        Write-Verbose "mnuExit_Click Catch"
        Write-Verbose $_.Exception.Message
    }
}

#endregion

#Generates the form for PSObjectExplorer 
Function Generate-PSObjectExplorerForm
{
  [CmdletBinding()]
  param ()

Write-Verbose "Generate-Form"
$Form = New-Object System.Windows.Forms.Form
$MainMenu = New-Object System.Windows.Forms.MainMenu
$mnuFile = New-Object System.Windows.Forms.MenuItem
$mnuExit = New-Object System.Windows.Forms.MenuItem
$mnuView = New-Object System.Windows.Forms.MenuItem
$mnuWMIObjects = New-Object System.Windows.Forms.MenuItem
$mnuSeparatorV1 = New-Object System.Windows.Forms.MenuItem
$mnuNetAssemblies = New-Object System.Windows.Forms.MenuItem
$mnuNetClasses = New-Object System.Windows.Forms.MenuItem
$mnuSeparatorV2= New-Object System.Windows.Forms.MenuItem
$mnuPSAliases = New-Object System.Windows.Forms.MenuItem
$mnuPSCommands = New-Object System.Windows.Forms.MenuItem
$mnuPSDrives = New-Object System.Windows.Forms.MenuItem
$mnuPSModules = New-Object System.Windows.Forms.MenuItem
$mnuPSVariables = New-Object System.Windows.Forms.MenuItem
$mnuSeparatorV3= New-Object System.Windows.Forms.MenuItem
$mnuWINFeature = New-Object System.Windows.Forms.MenuItem
$mnuSeparatorV4= New-Object System.Windows.Forms.MenuItem
$mnuWINProcess = New-Object System.Windows.Forms.MenuItem
$mnuWINService = New-Object System.Windows.Forms.MenuItem
$mnuSeparatorV5= New-Object System.Windows.Forms.MenuItem
$mnuTestCases = New-Object System.Windows.Forms.MenuItem
$mnuOptions = New-Object System.Windows.Forms.MenuItem
$mnuObjects = New-Object System.Windows.Forms.MenuItem
$mnuStructs = New-Object System.Windows.Forms.MenuItem
$mnuSeparator4= New-Object System.Windows.Forms.MenuItem
$mnuCollections = New-Object System.Windows.Forms.MenuItem
$mnuSeparator5= New-Object System.Windows.Forms.MenuItem
$mnuNulls = New-Object System.Windows.Forms.MenuItem
$mnuEmptyStrings = New-Object System.Windows.Forms.MenuItem
$mnuSeparator6= New-Object System.Windows.Forms.MenuItem
$mnuHelp = New-Object System.Windows.Forms.MenuItem
$mnuAbout = New-Object System.Windows.Forms.MenuItem
$mnuStatus = New-Object System.Windows.Forms.MenuItem
$SplitContainerInstance = New-Object System.Windows.Forms.SplitContainer
$StatusBarInstance = New-Object System.Windows.Forms.StatusBar
$TreeViewInstance = New-Object System.Windows.Forms.TreeView
$TabControl = New-Object System.Windows.Forms.TabControl
$TabPageInstance = New-Object System.Windows.Forms.TabPage
$ListViewInstance = New-Object System.Windows.Forms.ListView
$TabPageClass = New-Object System.Windows.Forms.TabPage
$ListViewClass = New-Object System.Windows.Forms.ListView
$TabPageInterface = New-Object System.Windows.Forms.TabPage
$SplitContainerInterface = New-Object System.Windows.Forms.SplitContainer
$TreeViewInterface = New-Object System.Windows.Forms.TreeView
$ListViewInterface = New-Object System.Windows.Forms.ListView
$StatusBarInterface = New-Object System.Windows.Forms.StatusBar
$TabPagePSObject = New-Object System.Windows.Forms.TabPage
$TextBoxPSObject = New-Object System.Windows.Forms.TextBox
$TabPageValues = New-Object System.Windows.Forms.TabPage
$TextBoxValues = New-Object System.Windows.Forms.TextBox
$TabPagePowerShell = New-Object System.Windows.Forms.TabPage
$SplitContainerPowerShell = New-Object System.Windows.Forms.SplitContainer
$TextBoxPowerShell = New-Object System.Windows.Forms.TextBox
$ButtonExecute = New-Object System.Windows.Forms.Button
$TextBoxOutput = New-Object System.Windows.Forms.TextBox
$ButtonClear = New-Object System.Windows.Forms.Button
$TabPageWMIClasses = New-Object System.Windows.Forms.TabPage
$LabelComputers = New-Object System.Windows.Forms.Label
$TextBoxComputers = New-Object System.Windows.Forms.TextBox
$LabelFilter = New-Object System.Windows.Forms.Label
$TextBoxFilter = New-Object System.Windows.Forms.TextBox
$TimerNetClasses = New-Object System.Windows.Forms.Timer

Write-Verbose "Generate-Form Form"
$Form.Name = 'Form'
$Form.Text = 'Powershell Object Explorer'
$Form.DataBindings.DefaultDataSourceUpdateMode = 0
$Form.ClientSize = New-Object System.Drawing.Size(890,359)
$Form.StartPosition = 1
$Form.BackColor = [System.Drawing.Color]::FromArgb(255,185,209,234)

$Form.Add_Load({Form_Load})
$Form.Add_FormClosing({$TimerNetClasses.Enabled=$False})
$Form.Add_Resize({Form_Resize})

Write-Verbose "Generate-Form Menus"

$MainMenu.Name = "MainMenu"
$Form.Menu = $MainMenu

$mnuFile.Name = 'mnuFile'
$mnuFile.Text = '&File'
$MainMenu.MenuItems.Add($mnuFile) | Out-Null

$mnuExit.Name = 'mnuExit'
$mnuExit.Text = 'E&xit'
$mnuExit.Add_Click({mnuExit_Click})
$mnuFile.MenuItems.Add($mnuExit) | Out-Null

$mnuView.Name = 'mnuView'
$mnuView.Text = '&View'
$MainMenu.MenuItems.Add($mnuView) | Out-Null

$mnuWMIObjects.Name = 'mnuWMIObjects'
$mnuWMIObjects.Text = '&WMI Objects'
$mnuWMIObjects.Add_Click({mnuWMIObjects_Click})
$mnuView.MenuItems.Add($mnuWMIObjects) | Out-Null

$mnuSeparatorV1.Name = 'mnuSeparatorV1'
$mnuSeparatorV1.Text = '-'
$mnuView.MenuItems.Add($mnuSeparatorV1) | Out-Null

$mnuNetAssemblies.Name = 'mnuNetAssemblies'
$mnuNetAssemblies.Text = '.Net Assemblies'
$mnuNetAssemblies.Add_Click({mnuNetAssemblies_Click})
$mnuView.MenuItems.Add($mnuNetAssemblies) | Out-Null

$mnuNetClasses.Name = 'mnuNetClasses'
$mnuNetClasses.Text = '.Net Classes'
$mnuNetClasses.Add_Click({mnuNetClasses_Click})
$mnuView.MenuItems.Add($mnuNetClasses) | Out-Null

$mnuSeparatorV2.Name = 'mnuSeparatorV2'
$mnuSeparatorV2.Text = '-'
$mnuView.MenuItems.Add($mnuSeparatorV2) | Out-Null

$mnuPSAliases.Name = 'mnuPSAliases'
$mnuPSAliases.Text = 'PowerShell &Aliases'
$mnuPSAliases.Add_Click({mnuPSAliases_Click})
$mnuView.MenuItems.Add($mnuPSAliases) | Out-Null

$mnuPSCommands.Name = 'mnuPSCommands'
$mnuPSCommands.Text = 'PowerShell &Commands'
$mnuPSCommands.Add_Click({mnuPSCommands_Click})
$mnuView.MenuItems.Add($mnuPSCommands) | Out-Null

$mnuPSDrives.Name = 'mnuPSDrives'
$mnuPSDrives.Text = 'PowerShell &Drives'
$mnuPSDrives.Add_Click({mnuPSDrives_Click})
$mnuView.MenuItems.Add($mnuPSDrives) | Out-Null

$mnuPSModules.Name = 'mnuPSModules'
$mnuPSModules.Text = 'PowerShell &Modules'
$mnuPSModules.Add_Click({mnuPSModules_Click})
$mnuView.MenuItems.Add($mnuPSModules) | Out-Null

$mnuPSVariables.Name = 'mnuPSVariables'
$mnuPSVariables.Text = 'PowerShell &Variables'
$mnuPSVariables.Add_Click({mnuPSVariables_Click})
$mnuView.MenuItems.Add($mnuPSVariables) | Out-Null

$mnuSeparatorV3.Name = 'mnuSeparatorV3'
$mnuSeparatorV3.Text = '-'
$mnuView.MenuItems.Add($mnuSeparatorV3) | Out-Null

$mnuWINFeature.Name = 'mnuWINFeature'
$mnuWINFeature.Text = 'Windows &Features'
$mnuWINFeature.Add_Click({mnuWINFeature_Click})
$mnuView.MenuItems.Add($mnuWINFeature) | Out-Null

$mnuSeparatorV4.Name = 'mnuSeparatorV4'
$mnuSeparatorV4.Text = '-'
$mnuView.MenuItems.Add($mnuSeparatorV4) | Out-Null

$mnuWINProcess.Name = 'mnuWINProcess'
$mnuWINProcess.Text = 'Windows &Processes'
$mnuWINProcess.Add_Click({mnuWINProcess_Click})
$mnuView.MenuItems.Add($mnuWINProcess) | Out-Null

$mnuWINService.Name = 'mnuWINService'
$mnuWINService.Text = 'Windows &Services'
$mnuWINService.Add_Click({mnuWINService_Click})
$mnuView.MenuItems.Add($mnuWINService) | Out-Null

$mnuSeparatorV5.Name = 'mnuSeparatorV5'
$mnuSeparatorV5.Text = '-'
$mnuView.MenuItems.Add($mnuSeparatorV5) | Out-Null

$mnuTestCases.Name = 'mnuTestCases'
$mnuTestCases.Text = 'Test Cases'
$mnuTestCases.Add_Click({mnuTestCases_Click})
$mnuView.MenuItems.Add($mnuTestCases) | Out-Null

$mnuOptions.Name = 'mnuOptions'
$mnuOptions.Text = '&Options'
$MainMenu.MenuItems.Add($mnuOptions) | Out-Null

$mnuObjects.Name = 'mnuObjects'
$mnuObjects.Text = '&Show Objects'
$mnuObjects.Add_Click({mnuObjects_Click})
$mnuOptions.MenuItems.Add($mnuObjects) | Out-Null

$mnuStructs.Name = 'mnuStructs'
$mnuStructs.Text = 'Show St&ructs'
$mnuStructs.Add_Click({mnuStructs_Click})
$mnuOptions.MenuItems.Add($mnuStructs) | Out-Null

$mnuSeparator4.Name = 'mnuSeparator4'
$mnuSeparator4.Text = '-'
$mnuOptions.MenuItems.Add($mnuSeparator4) | Out-Null

$mnuCollections.Name = 'mnuCollections'
$mnuCollections.Text = 'Show &Collections'
$mnuCollections.Add_Click({mnuCollections_Click})
$mnuOptions.MenuItems.Add($mnuCollections) | Out-Null

$mnuSeparator5.Name = 'mnuSeparator5'
$mnuSeparator5.Text = '-'
$mnuOptions.MenuItems.Add($mnuSeparator5) | Out-Null

$mnuNulls.Name = 'mnuNulls'
$mnuNulls.Text = 'Show &Nulls'
$mnuNulls.Add_Click({mnuNulls_Click})
$mnuOptions.MenuItems.Add($mnuNulls) | Out-Null

$mnuEmptyStrings.Name = 'mnuEmptyStrings'
$mnuEmptyStrings.Text = 'Show &Empty Strings'
$mnuEmptyStrings.Add_Click({mnuEmptyStrings_Click})
$mnuOptions.MenuItems.Add($mnuEmptyStrings) | Out-Null

$mnuHelp.Name = 'mnuHelp'
$mnuHelp.Text = '&Help'
$MainMenu.MenuItems.Add($mnuHelp) | Out-Null

$mnuAbout.Name = 'mnuAbout'
$mnuAbout.Text = '&About'
$mnuAbout.Add_Click({mnuAbout_Click})
$mnuHelp.MenuItems.Add($mnuAbout) | Out-Null

$mnuStatus.Name = 'mnuStatus'
$mnuStatus.Text = ''
$MainMenu.MenuItems.Add($mnuStatus) | Out-Null

Write-Verbose "Generate-Form Computer SplitContainer"

$SplitContainerInstance.Dock = [System.Windows.Forms.DockStyle]::Fill
$SplitContainerInstance.Location = New-Object System.Drawing.Point(0, 0)
$SplitContainerInstance.TabIndex = 0
$SplitContainerInstance.Name = "SplitContainer"
$SplitContainerInstance.Text = "SplitContainer"
$SplitContainerInstance.Panel1.Controls.Add($TreeViewInstance)
$SplitContainerInstance.Panel2.Controls.Add($TabControl)

$SplitContainerInstance.Add_SplitterMoved({SplitContainer_SplitterMoved $SplitContainerInstance $_})

$Form.Controls.Add($SplitContainerInstance)

Write-Verbose "Generate-Form StatusBarInstance"

$StatusBarInstance.Name = 'StatusBarInstance'
$StatusBarInstance.DataBindings.DefaultDataSourceUpdateMode = 0
$StatusBarInstance.TabIndex = 8
$StatusBarInstance.Size = New-Object System.Drawing.Size(428,22)
$StatusBarInstance.Location = New-Object System.Drawing.Point(0,337)
$StatusBarInstance.Text = 'Ready'

$Form.Controls.Add($StatusBarInstance)

#$Form.Controls.Add($TextBoxFilter)

Write-Verbose "Generate-Form TreeViewInstance"

$TreeViewInstance.Name = "TreeViewInstance"
$TreeViewInstance.TabIndex = 0
$TreeViewInstance.Anchor = 15
$TreeViewInstance.Dock = [System.Windows.Forms.DockStyle]::Fill
$TreeViewInstance.HideSelection = $False
$TreeViewInstance.Tag = $ListViewInstance

$TreeViewInstance.Add_AfterSelect({TreeView_AfterSelect -Sender $TreeViewInstance -EventArg $_}) 

Write-Verbose "Generate-Form TabControl"

$TabControl.Name = "TabControl"
$TabControl.TabIndex = 9
$TabControl.Anchor = 15
$TabControl.Dock = [System.Windows.Forms.DockStyle]::Fill

#$Form.Controls.Add($TabControl)

Write-Verbose "Generate-Form TabPage Instance"

$TabPageInstance.Name = "TabPageInstance"
$TabPageInstance.Text = "Instance"
$TabPageInstance.TabIndex = 0
$TabPageInstance.Dock = [System.Windows.Forms.DockStyle]::Fill

$TabControl.Controls.Add($TabPageInstance)

Write-Verbose "Generate-Form ListViewInstance"

$ListViewInstance.Name = "ListViewInstance"
$ListViewInstance.TabIndex = 1
$ListViewInstance.Dock = [System.Windows.Forms.DockStyle]::Fill
$ListViewInstance.Tag = $StatusBarInstance


$TabPageInstance.Controls.Add($ListViewInstance)

Write-Verbose "Generate-Form TabPage Class"

$TabPageClass.Name = "TabPageClass"
$TabPageClass.Text = "Class"
$TabPageClass.TabIndex = 0
$TabPageClass.Anchor = 15
$TabPageClass.Dock = [System.Windows.Forms.DockStyle]::Fill

$TabControl.Controls.Add($TabPageClass)

Write-Verbose "Generate-Form ListViewClass"

$ListViewClass.Name = "ListViewClass"
$ListViewClass.TabIndex = 11
$ListViewClass.Dock = [System.Windows.Forms.DockStyle]::Fill

$TabPageClass.Controls.Add($ListViewClass)

Write-Verbose "Generate-Form TabPage Interface"

$TabPageInterface.Name = "TabPageInterface"
$TabPageInterface.Text = "Interface"
$TabPageInterface.TabIndex = 0
$TabPageInterface.Anchor = 15
$TabPageInterface.Dock = [System.Windows.Forms.DockStyle]::Fill

$TabControl.Controls.Add($TabPageInterface)

Write-Verbose "Generate-Form SplitContainerInterface"

$SplitContainerInterface.Name = "SplitContainerInterface"
$SplitContainerInterface.Text = "SplitContainerInterface"
$SplitContainerInterface.Dock = [System.Windows.Forms.DockStyle]::Fill
#$SplitContainerInterface.SplitterDistance = 211
$SplitContainerInterface.TabIndex = 0

$SplitContainerInterface.Panel1.Controls.Add($TreeViewInterface)
$SplitContainerInterface.Panel2.Controls.Add($ListViewInterface)

$SplitContainerInterface.Add_SplitterMoved({SplitContainer_SplitterMoved $SplitContainerInterface $_})

$TabPageInterface.Controls.Add($SplitContainerInterface)

$StatusBarInterface.Name = 'StatusBarInterface'
$StatusBarInterface.DataBindings.DefaultDataSourceUpdateMode = 0
$StatusBarInterface.TabIndex = 8
$StatusBarInterface.Size = New-Object System.Drawing.Size(428,22)
$StatusBarInterface.Location = New-Object System.Drawing.Point(0,337)
$StatusBarInterface.Text = 'StatusBarTabControl'

$TabPageInterface.Controls.Add($StatusBarInterface)


Write-Verbose "Generate-Form TreeViewInstance"

$TreeViewInterface.Name = "TreeViewInterface"
$TreeViewInterface.TabIndex = 0
$TreeViewInterface.Dock = [System.Windows.Forms.DockStyle]::Fill
$TreeViewInterface.HideSelection = $False
$TreeViewInterface.Tag = $ListViewInterface

$TreeViewInterface.Add_AfterSelect({TreeView_AfterSelect -Sender $TreeViewInterface -EventArg $_}) 

Write-Verbose "Generate-Form ListViewInterface"

$ListViewInterface.Name = "ListViewInterface"
$ListViewInterface.TabIndex = 11
$ListViewInterface.Dock = [System.Windows.Forms.DockStyle]::Fill
$ListViewInterface.Tag = $StatusBarInterface


Write-Verbose "Generate-Form TabPage PSObject"

$TabPagePSObject.Name = "TabPagePSObject"
$TabPagePSObject.Text = "PSObject"
$TabPagePSObject.TabIndex = 0
$TabPagePSObject.Anchor = 15
$TabPagePSObject.Dock = [System.Windows.Forms.DockStyle]::Fill

$TabControl.Controls.Add($TabPagePSObject)

Write-Verbose "Generate-Form txtPSObject"

$TextBoxPSObject.Text = ''
$TextBoxPSObject.Name = 'TextBoxPSObject'
$TextBoxPSObject.TabIndex = 15
$TextBoxPSObject.MultiLine = $True
$TextBoxPSObject.WordWrap = $False
$TextBoxPSObject.ScrollBars = [System.Windows.Forms.ScrollBars]::Both
$TextBoxPSObject.Dock = [System.Windows.Forms.DockStyle]::Fill

$TabPagePSObject.Controls.Add($TextBoxPSObject)

Write-Verbose "Generate-Form TabPage Values"

$TabPageValues.Name = "TabPageValues"
$TabPageValues.Text = "Values"
$TabPageValues.TabIndex = 0
$TabPageValues.Anchor = 15
$TabPageValues.Dock = [System.Windows.Forms.DockStyle]::Fill

$TabControl.Controls.Add($TabPageValues)

Write-Verbose "Generate-Form txtValues"

$TextBoxValues.Text = ''
$TextBoxValues.Name = 'TextBoxValues'
$TextBoxValues.TabIndex = 15
$TextBoxValues.MultiLine = $True
$TextBoxValues.WordWrap = $False
$TextBoxValues.ScrollBars = [System.Windows.Forms.ScrollBars]::Both
$TextBoxValues.Dock = [System.Windows.Forms.DockStyle]::Fill

$TabPageValues.Controls.Add($TextBoxValues)

Write-Verbose "Generate-Form TabPage PowerShell"

$TabPagePowerShell.Name = "TabPagePowerShell"
$TabPagePowerShell.Text = "PowerShell"
$TabPagePowerShell.TabIndex = 0
$TabPagePowerShell.Anchor = 15
$TabPagePowerShell.Dock = [System.Windows.Forms.DockStyle]::Fill

$TabControl.Controls.Add($TabPagePowerShell)

Write-Verbose "Generate-Form SplitContainerPowerShell"

$SplitContainerPowerShell.Name = "SplitContainerPowerShell"
$SplitContainerPowerShell.Text = "SplitContainerPowerShell"
$SplitContainerPowerShell.Dock = [System.Windows.Forms.DockStyle]::Fill
#$SplitContainerPowerShell.SplitterDistance = 211
$SplitContainerPowerShell.Orientation = [System.Windows.Forms.Orientation]::Horizontal

$SplitContainerPowerShell.Panel1.Controls.Add($TextboxPowerShell)
$SplitContainerPowerShell.Panel1.Controls.Add($ButtonExecute)
$SplitContainerPowerShell.Panel2.Controls.Add($TextboxOutput)
$SplitContainerPowerShell.Panel2.Controls.Add($ButtonClear)

$SplitContainerPowerShell.Add_SplitterMoved({SplitContainer_SplitterMoved $SplitContainerPowerShell $_})

$TabPagePowerShell.Controls.Add($SplitContainerPowerShell)

Write-Verbose "Generate-Form txtPowerShell"

$TextBoxPowerShell.Text = ''
$TextBoxPowerShell.Name = 'TextBoxPowerShell'
$TextBoxPowerShell.TabIndex = 15
$TextBoxPowerShell.MultiLine = $True
$TextBoxPowerShell.WordWrap = $False
$TextBoxPowerShell.ScrollBars = [System.Windows.Forms.ScrollBars]::Both
$TextBoxPowerShell.Dock = [System.Windows.Forms.DockStyle]::Fill

Write-Verbose "Generate-Form ButtonExecute"

$ButtonExecute.Enabled = $True
$ButtonExecute.Name = "ButtonExecute"
$ButtonExecute.Location = New-Object System.Drawing.Point(40,10)
$ButtonExecute.Size = New-Object System.Drawing.Size(75, 23)
$ButtonExecute.TabIndex = 0
$ButtonExecute.Text = "Execute"
$ButtonExecute.UseVisualStyleBackColor = $True
$ButtonExecute.Dock = [System.Windows.Forms.DockStyle]::Right
#$ButtonExecute.Add_Click({ButtonExecute_Click $ButtonExecute})
$ButtonExecute.Add_Click({
    Try
    {
        Write-Verbose "ButtonExecute_Click"
        $TextBoxOutput.Text
        #$Output = $ExecutionContext.InvokeCommand.InvokeScript($TextBoxPowerShell.Text,$False,$Null,$Null)
        $Output = $ExecutionContext.InvokeCommand.InvokeScript($TextBoxPowerShell.Text)
        IF ($Output -NE "")
        {
            ForEach ($Line In $OutPut)
            {
                $TextBoxOutput.Text += "$Line `r`n"
            }
        }
    }
    Catch [System.Exception]
    {
        Write-Verbose "ButtonExecute_Click Catch"
        Write-Error $_.Exception.Message
    }
})

Write-Verbose "Generate-Form txtOutput"

$TextBoxOutput.Text = ''
$TextBoxOutput.Name = 'TextBoxOutput'
$TextBoxOutput.TabIndex = 15
$TextBoxOutput.MultiLine = $True
$TextBoxOutput.WordWrap = $False
$TextBoxOutput.ScrollBars = [System.Windows.Forms.ScrollBars]::Both
$TextBoxOutput.Dock = [System.Windows.Forms.DockStyle]::Fill

Write-Verbose "Generate-Form ButtonClear"

$ButtonClear.Enabled = $True
$ButtonClear.Name = "ButtonClear"
$ButtonClear.Location = New-Object System.Drawing.Point(40,10)
$ButtonClear.Size = New-Object System.Drawing.Size(75, 23)
$ButtonClear.TabIndex = 0
$ButtonClear.Text = "Clear"
$ButtonClear.UseVisualStyleBackColor = $True
$ButtonClear.Dock = [System.Windows.Forms.DockStyle]::Right
$ButtonClear.Add_Click({$TextBoxOutput.Text = ""})

Write-Verbose "Generate-Form TabPage WMIClasses"

$TabPageWMIClasses.Name = "TabPageWMIClasses"
$TabPageWMIClasses.Text = "WMI Classes"
$TabPageWMIClasses.TabIndex = 0
$TabPageWMIClasses.Anchor = 15
$TabPageWMIClasses.Dock = [System.Windows.Forms.DockStyle]::Fill
$TabControl.Controls.Add($TabPageWMIClasses)

Write-Verbose "Generate-Form LabelComputers"

$LabelComputers.Text = 'Computer'
$LabelComputers.Name = 'LabelComputers'
$LabelComputers.TabIndex = 12
$LabelComputers.Size = New-Object System.Drawing.Size(60,20)
$LabelComputers.Location = New-Object System.Drawing.Point(1,25)
$LabelComputers.DataBindings.DefaultDataSourceUpdateMode = 0

$TabPageWMIClasses.Controls.Add($LabelComputers)

Write-Verbose "Generate-Form TextBoxComputers"

$TextBoxComputers.Text = 'Localhost'
$TextBoxComputers.Name = 'TextBoxComputerss'
$TextBoxComputers.TabIndex = 13
$TextBoxComputers.Size = New-Object System.Drawing.Size(306,20)
$TextBoxComputers.Location = New-Object System.Drawing.Point(61,20)
$TextBoxComputers.DataBindings.DefaultDataSourceUpdateMode = 0

$TabPageWMIClasses.Controls.Add($TextBoxComputers)

Write-Verbose "Generate-Form LabelFilter"

$LabelFilter.Text = 'Filter'
$LabelFilter.Name = 'LabelFilter'
$LabelFilter.TabIndex = 14
$LabelFilter.Size = New-Object System.Drawing.Size(60,20)
$LabelFilter.Location = New-Object System.Drawing.Point(1,50)
$LabelFilter.DataBindings.DefaultDataSourceUpdateMode = 0

$TabPageWMIClasses.Controls.Add($LabelFilter)

Write-Verbose "Generate-Form TextBoxFilter"

$TextBoxFilter.Text = ''
$TextBoxFilter.Name = 'TextBoxFilter'
$TextBoxFilter.TabIndex = 15
$TextBoxFilter.Size = New-Object System.Drawing.Size(306,20)
$TextBoxFilter.Location = New-Object System.Drawing.Point(61,45)
$TextBoxFilter.DataBindings.DefaultDataSourceUpdateMode = 0

$TabPageWMIClasses.Controls.Add($TextBoxFilter)

#$TimerNetClasses.Name = "TimerNetClasses"
$TimerNetClasses.Interval=100
$TimerNetClasses.Add_Tick({TimerNetClasses_Tick})

#Show the Form
$Form.ShowDialog()| Out-Null
} 

#endregion

# VerbosePreference= SilentlyContinue is the default
#$VerbosePreference="SilentlyContinue"

# VerbosePreference= Continue will show verbose statements (useful for debugging)
#$VerbosePreference="Continue"

# DebugPreference= SilentlyContinue is the default
#$DebugPreference="SilentlyContinue"

# DebugPreference= Continue will show verbose statements (useful for debugging)
#$DebugPreference="Continue"

#CLS
#$Error.Clear()

Generate-PSObjectExplorerForm 

