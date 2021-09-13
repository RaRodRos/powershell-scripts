<#
.SYNOPSIS
    Recursively removal of empty folders.

.DESCRIPTION
    The script only passes one time for each folder and deletes all those that are empty (even the hidden ones).

.PARAMETER ArgPath
    The target folder (it will be deleted too if it's empty).

.NOTES
	.old-version
		do {
			$emptyFolders = Get-ChildItem -Recurse -Directory | Where-Object {(Get-ChildItem $_.fullName).count -eq 0}
			$emptyFolders | Foreach-Object {Remove-Item $_}
		} while ($emptyFolders -gt 0)
#>

param (
	$ArgPath
)

if (!(Test-Path $ArgPath)) {
	Throw "$ArgPath doesn't exist!"
}
$deleteEmptyFolders = {
	param (
		$ArgPath
	)
	
	foreach ($childDirectory in Get-ChildItem -Force -LiteralPath $ArgPath -Directory) {
		& $deleteEmptyFolders -ArgPath $childDirectory.FullName
	}
	$currentFolder = Get-ChildItem -Force -LiteralPath $ArgPath
	if (!$currentFolder) {
		Write-Verbose "Removing empty folder at path '${Path}'." -Verbose
		Remove-Item -Force -LiteralPath $ArgPath
	}
}

& $deleteEmptyFolders -ArgPath $ArgPath