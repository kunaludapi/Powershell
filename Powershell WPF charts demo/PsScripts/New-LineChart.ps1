
[CmdletBinding(SupportsShouldProcess=$True,
    ConfirmImpact='Medium',
    HelpURI='http://vcloud-lab.com')]
Param
(
    [parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
    [string]$TopCpuNames,
    [parameter(Position=1, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
    [string]$TopCpuUsage,
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
  <title>Line Chart</title>
</head>
<body>
  <div class="container">
    <canvas id="myChart"></canvas>
  </div>

  <script>
    let myChart = document.getElementById('myChart').getContext('2d');
    Chart.defaults.global.defaultFontSize = 12;
    Chart.defaults.global.defaultFontColor = '#777';

    let massPopChart = new Chart(myChart, {
      type:'line', 
      data:{
        labels:[$TopCpuNames],
        datasets:[{
          label: `"$LegendLabel`" ,
          data:[$TopCpuUsage],
          backgroundColor:'rgba(0,191,255, 0.6)',
		  hoverBackgroundColor: 'rgba(255,165,0, 0.6)',
          borderWidth:1,
          borderColor:'#777',
          hoverBorderWidth:3,
          hoverBorderColor:'#000',
		  fontsize:10,
        }]
      },
      options:{
        title:{
          display:false,
          fontSize:8
        },
        legend:{
          display:false,
          position:'bottom',
		  labels:{
            fontColor:'Gray',
			fontSize:12,
          }
        },
        layout:{
          padding:{
            left:0,
            right:0,
            bottom:0,
            top:0
          }
        },
        tooltips:{
          enabled:true,
		  titleFontSize:10
        },
		
        scales: {
            yAxes: [{
                ticks: {
                    beginAtZero: false,
					display: true, //label show\hide
					fontSize:10,
                },
                gridLines: {
					display:true,
					drawBorder: true,
                }
            }],
            xAxes: [{
                // Change here
            	barPercentage: 1,
				ticks:{
					fontSize: 12, 
					display: true, //label show\hide
				},
				gridLines: {
                    //color: "rgba(0, 0, 0, 0)",
					//lineWidth: 0
					display:true, 
					drawBorder: true,
                }
            }]
        }		
      }
    });
  </script>
</body>
</html>
"@

$Chart | Out-File -FilePath $Global:AllChartsPath\HtmlCharts\Line.html
#Invoke-Expression C:\temp\test.html