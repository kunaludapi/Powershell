
[CmdletBinding(SupportsShouldProcess=$True,
    ConfirmImpact='Medium',
    HelpURI='http://vcloud-lab.com')]
Param
(
    [parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
    [string]$ServicesNames,
    [parameter(Position=1, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
    [string]$ServicesCount,
    [parameter(Position=2, Mandatory=$true, ValueFromPipeline=$true)]
    [string]$LegendLabel
)

$Chart = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.min.js"></script>
  <script src="JSScripts/Chart.min.js"></script>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <link rel="stylesheet" href="JSScripts/bootstrap.min.css">
  <title>Doughnut Chart</title>
</head>
<body>
  <div class="container">
    <canvas id="myChart" Width="409" Height="276"></canvas>
  </div>

  <script>
  var data = {
    labels: [$ServicesNames],
    datasets: [{
        label: `"$LegendLabel`",
        backgroundColor: [
          "rgba(0,191,255,0.6)", 
          "rgba(255,64,0,0.6)",
        ],
        hoverBackgroundColor: [
          "rgba(0,191,255, 1)", 
          "rgba(255, 64, 0, 1)",
        ],
		pointHoverRadius: 5,
        strokeColor: "#f26b5f",
        pointColor: "#f26b5f",		
		//borderColor: "rgba(75,192,192,1)",
        data: [$ServicesCount],
        hoverBorderWidth:3,
        hoverBorderColor:'#000',
		showLine: false
    }]
};

var ctx = document.getElementById("myChart");
var myChart = new Chart(ctx, {
    type: 'doughnut',
    data: data,
	responsive: true,
    options: {
	    legend: {
           display: false
        },
        tooltips: {
           enabled: true,
		   mode: 'single'

        },
        scales: {
            yAxes: [{
                ticks: {
					display: false,
					fontColor: 'white',
                },
                gridLines: {
					display:false,
					drawBorder: false,
                }
            }],
            xAxes: [{
                // Change here
            	barPercentage: 1,
				ticks:{
					fontColor: 'white',
				},
				gridLines: {
					display:false,
					drawBorder: false,
                }
            }]
        }
    }
});

console.log(myChart);
</script>
  
</body>
</html>



"@

$Chart | Out-File -FilePath $Global:AllChartsPath\HtmlCharts\Doughnut.html
#Invoke-Expression C:\temp\test.html