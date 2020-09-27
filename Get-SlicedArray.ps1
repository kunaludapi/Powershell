$numbers = 1..100
$groupOf = 20

for ($i = 0; $i -le 100; $i+= $groupOf)
{
    if ($numbers.count -eq $i)
    {
        break
    }        
    $group = $i + $groupOf
    $numbers[$i..$group] -join ', ' 
    $i++
}



$numbers = 1..100
$groupOf = 9

$result = New-Object System.Collections.ArrayList

for ($i = 0; $i -le 100; $i+= $groupOf)
{
    if ($numbers.count -eq $i)
    {
        break
    }
    $group = $i + $groupOf   
    [void]$result.add($numbers[$i..$group])
    $i++
}

$result[3]