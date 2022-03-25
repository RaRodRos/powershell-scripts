# Usefull Scripts and modules from Powershellgallery

$scripts = @(
	@{
		# Validation of file and folder names
		Name = "Remove-InvalidFileNameChars"
	}
)

$modules = @(
	@{
		# Conversion of Powershell 5 scripts to EXE files
		Name = "ps2exe"
	}
)

foreach ($script in $scripts) {
	Install-Script @script
}

foreach ($module in $modules) {
	Install-Module @module
}