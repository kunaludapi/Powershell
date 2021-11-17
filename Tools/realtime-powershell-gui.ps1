#Initialize the GUI
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

#real time data Auto update form
function UpdateProcCount($Label)
{
    $Label.Text = "Number of processes running on my computer: " + (Get-Process | measure).Count
}

$Form = New-Object System.Windows.Forms.Form
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000
$timer.Add_Tick({UpdateProcCount $Label})
$timer.Enabled = $True
$Form.Text = "Sample Form"
$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Number of process executed on my computer"
$Label.AutoSize = $True
$Form.Controls.Add($Label)
$Form.ShowDialog()
