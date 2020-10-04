$rawdata = @'
    </table>
        <thead>
            <tr>
                <th>First name</th>
                <th>Last name</th>
                <th>Position</th>
                <th>Office</th>
                <th>Age</th>
                <th>Start date</th>
                <th>Salary</th>
                <th>Extn.</th>
                <th>E-mail</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Tiger</td>
                <td>Nixon</td>
                <td>System Architect</td>
                <td>Edinburgh</td>
                <td>61</td>
                <td>2011/04/25</td>
                <td>$320,800</td>
                <td>5421</td>
                <td>t.nixon@datatables.net</td>
            </tr>
            <tr>
                <td>Garrett</td>
                <td>Winters</td>
                <td>Accountant</td>
                <td>Tokyo</td>
                <td>63</td>
                <td>2011/07/25</td>
                <td>$170,750</td>
                <td>8422</td>
                <td>g.winters@datatables.net</td>
            </tr>
            <tr>
                <td>Ashton</td>
                <td>Cox</td>
                <td>Junior Technical Author</td>
                <td>San Francisco</td>
                <td>66</td>
                <td>2009/01/12</td>
                <td>$86,000</td>
                <td>1562</td>
                <td>a.cox@datatables.net</td>
            </tr>
            <tr>
                <td>Cedric</td>
                <td>Kelly</td>
                <td>Senior Javascript Developer</td>
                <td>Edinburgh</td>
                <td>22</td>
                <td>2012/03/29</td>
                <td>$433,060</td>
                <td>6224</td>
                <td>c.kelly@datatables.net</td>
            </tr>
            <tr>
                <td>Airi</td>
                <td>Satou</td>
                <td>Accountant</td>
                <td>Tokyo</td>
                <td>33</td>
                <td>2008/11/28</td>
                <td>$162,700</td>
                <td>5407</td>
                <td>a.satou@datatables.net</td>
            </tr>
        </tbody>
    </table>
'@

$th = $rawdata -split "`r`n"| where-object {$_ -match '<th>'}
$td = $rawdata -split "`r`n"| where-object {$_ -match '<td>'}

$thead = (($th -replace '<th>', '') -replace '</th>', '').trim()
$tdata = (($td -replace '<td>', '') -replace '</td>', '').trim()

$groupOf = 
$result = New-Object System.Collections.ArrayList
for ($i = 0; $i -le $tdata.count; $i+= ($thead.count - 1))
{
    if ($tdata.count -eq $i)
    {
        break
    }        
        
    $group9 = $i + ($thead.count - 1)
    #"{0} {1}" -f $i, $group9

    [void]$result.Add($tdata[$i..$group9])
    #$result = @($tdata[$i..$group9]) #-join ', '
    $i++
}

$finalResult = @()
foreach ($data in $result)
{
    $finalResult += [pscustomobject]@{
        $thead[0] = $data[0]
        $thead[1] = $data[1]
        $thead[2] = $data[2]
        $thead[3] = $data[3]
        $thead[4] = $data[4]
        $thead[5] = $data[5]
        $thead[6] = $data[6]
        $thead[7] = $data[7]
        $thead[8] = $data[8]
    }
}
$finalResult | ft -Auto

#$finalResult | ConvertTo-Json | Out-File c:\temp\database.json
#$finalResult | Export-Csv c:\temp\database.csv -NoTypeInformation

####################################################################################
####################################################################################

#Open website
$webSite = Invoke-WebRequest -Uri https://datatables.net/

#Find table in the website
$tableHeader = $webSite.AllElements | Where-Object {$_.tagname -eq 'th'}
$tableData = $webSite.AllElements | Where-Object {$_.tagname -eq 'td'}

#Table header and data
$thead = $tableHeader.innerText[0..(($tableHeader.innerText.count/2) - 1)]
$tdata = $tableData.innerText

#Break table data into smaller chuck of data.
$dataResult = New-Object System.Collections.ArrayList
for ($i = 0; $i -le $tdata.count; $i+= ($thead.count - 1))
{
    if ($tdata.count -eq $i)
    {
        break
    }        
    $group = $i + ($thead.count - 1)
    [void]$dataResult.Add($tdata[$i..$group])
    $i++
}

#Html data into powershell table format
$finalResult = @()
foreach ($data in $dataResult)
{
    $newObject = New-Object psobject
    for ($i = 0; $i -le ($thead.count - 1); $i++) {
        $newObject | Add-Member -Name $thead[$i] -MemberType NoteProperty -value $data[$i]
    }
    $finalResult += $newObject
}
$finalResult | ft -AutoSize