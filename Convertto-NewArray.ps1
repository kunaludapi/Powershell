#requires -version 4
<#
.SYNOPSIS
    Convert range of numbers into another range of numbers maintaining ratio.
.DESCRIPTION
    Convert range of numbers into another range of numbers maintaining ratio using Maths arithmetic formula. 
.PARAMETER OldArray
    Prompts you for old numbers array list or range default value is from 1 to 50.
.PARAMETER NewArray
    Prompts you for New numbers array list or range default value is from 100 to 200.
.PARAMETER RoundNew
    This is a switch how do you want your new array list rounding or without rounding numbers
.INPUTS
    list of numbers in [int[]]
.OUTPUTS
    Output is on console directly with oldarray and newarray list.
.NOTES
  Version:        1.0
  Author:         Kunal Udapi
  Creation Date:  27 September 2020
  Purpose/Change: New script written for some other project where charts are involved for data science.
.EXAMPLE 1
    PS C:\>Convertto-NewArray.ps1

    This command convert number of range from 1 to 50 to 100 to 200.
.Example 2
    PS C:\>.\Convertto-NewArray.ps1 -OldArray 10, 20, 30, 40 -NewArray 1,4,7 -RoundNew

    Here how the number you can use, Withe RoundNew parameter result is rounded to whole integer.
.EXAMPLE 3
    PS C:\>.\Convertto-NewArray.ps1 -OldArray (1..10) -NewArray (55..60)

    This is another example you can take use number array information.
#>

[CmdletBinding(SupportsShouldProcess=$True,
    ConfirmImpact='Medium',
    HelpURI='http://vcloud-lab.com')]
Param
(
    [parameter(Position=0, ValueFromPipelineByPropertyName=$true)]
    [alias('Old')]
    [int[]]$OldArray = 1..50,
    [parameter(Position=1, ValueFromPipelineByPropertyName=$true)]
    [alias('New')]
    [int[]]$NewArray = 100..200,
    [switch]$RoundNew
)

begin {
    $measureOld = $OldArray | Measure-Object -Minimum -Maximum
    $oldArrayMin = $measureOld.Minimum
    $oldArrayMax = $measureOld.Maximum

    $measureNew = $NewArray | Measure-Object -Minimum -Maximum
    $newArrayMin = $measureNew.Minimum
    $newArrayMax = $measureNew.Maximum

    $oldRangeNumber = $oldArrayMax - $oldArrayMin
    $newRangeNumber = $newArrayMax - $newArrayMin
}

process {
    if ($RoundNew.IsPresent -eq $false) {

            foreach ($number in $OldArray) 
            {
                if (($number -eq 0) -or ($number -eq $oldArrayMin))
                {
                    [pscustomobject]@{
                        OldValue = $number
                        NewValue = $newArrayMin
                    }
                }
                else
                {
                    [pscustomobject]@{
                        OldValue = $number
                        NewValue = (($number - $oldArrayMin) * $newRangeNumber / $oldRangeNumber) + $newArrayMin
                    }

                }
            }
    }
    else {
        foreach ($number in $OldArray) 
        {
            if (($number -eq 0) -or ($number -eq $oldArrayMin))
            {
                [pscustomobject]@{
                    OldValue = $number
                    NewValue = $newArrayMin
                }
            }
            else
            {
                [pscustomobject]@{
                    OldValue = $number
                    NewValue = (($number - $oldArrayMin) * $newRangeNumber / $oldRangeNumber) + $newArrayMin
                }

            }
        }
    }
}

end {
}