# Manejo de facturas y sus correspondientes directorios
<#
El script debe ejecutarse desde la carpeta principal de las facturas, donde se encuentren también los directorios 
"gastos", "cobros" y las carpetas anuales
#>

$year = Get-Date -Format "yyyy"
$month = (Get-Date -Format "MM") - 1
if ($month -eq 12) {
	$year = $year - 1
}
$month = Get-Date -Month $month -UFormat %B
Compress-Archive -Path "cobros","gastos" -DestinationPath "facturas-$month.zip"
Get-ChildItem -Path "cobros" | Move-Item -Destination "$year\cobros" -Force
Get-ChildItem -Path "gastos" | Move-Item -Destination "$year\gastos" -Force