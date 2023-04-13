<# ToDo
- add example parameter to execute print-jarl.ps1
- add -scriptPath parameter and make possible to take .lnk files
- add -noElevated parameter
- add -executionpolicy parameter
- add -exit parameter
- add -command parameter to execute before the online script
- add -new parameter to initialize the script in a new powershell window
- add -pwsh5 to execute the script in powershell 5
#>

if (!($script = $args[0])) {
	$script = 'https://raw.githubusercontent.com/RaRodRos/junk/master/print-jarl.ps1'
}
$script = [Scriptblock]::Create((New-Object System.Net.WebClient).DownloadString($script))
Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -NoExit -Command $script" -Verb RunAs
