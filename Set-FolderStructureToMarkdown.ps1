#####
# Create a markdown file containing the structure of the folder
#####

param(
	[string]$Path = $PSScriptRoot,
	[string]$fileName = "folders"
)
if (!(Test-Path $Path -PathType Container)) {throw "Wrong directory path"}

function Get-FolderStructureToMarkdown ([string]$Path, [int]$Level) {
	foreach ($childDirectory in Get-ChildItem -Force -LiteralPath $Path -Directory | Sort-Object -Property BaseName -Descending) {
		$childFolders = Get-FolderStructureToMarkdown -Path $childDirectory.FullName -Level ($Level + 1)
	}

	$folderName = Split-Path -Path $Path -Leaf

	switch ($Level) {
		2 { $folderName = "1. $folderName"; Break }
		1 { $folderName = "`r`n## $folderName`r`n"; Break }
		0 { $folderName = "# $folderName"; Break }
		{$_ -ge 3} { $folderName = "$('   ' * ($Level - 2))- $folderName"; Break }
	}

	return $folderName + "`r`n" + $childFolders
}

Get-FolderStructureToMarkdown -Path $Path > "$(Join-Path -Path $Path -ChildPath $fileName).md"