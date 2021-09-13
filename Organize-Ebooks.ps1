#####
# Organize ebook files with similar names in folders and give them the same title
#####

# Checks if there are a valid path passed as argument
# Specifies a path to one or more locations.

param (
	[string]$Path = $PSScriptRoot,
	# if $Multi is $true, the program will search IN the folders contained INSIDE $Path
	[bool]$Multi = $False
)
if (!(Test-Path $Path -PathType Container)) {throw "Wrong directory path"}

# Get title from metadata using exiftool
function Get-MetaTitle ($File, $DeleteChars) {
	if ($title = & exiftool -t -q -q -title $file.FullName) {
		if (!$deleteChars) {
			$deleteChars = "[$([Regex]::Escape(-join [System.Io.Path]::GetInvalidFileNameChars()))]"
		}
		return ($title.Replace("Title","") -Replace $deleteChars,"").Trim()
	}
}
# Remove empty folders
function deleteEmptyFolders ([string]$ArgPath) {
	foreach ($childDirectory in Get-ChildItem -Force -LiteralPath $ArgPath -Directory) {
		deleteEmptyFolders($childDirectory.FullName)
	}
	$currentFolder = Get-ChildItem -Force -LiteralPath $ArgPath
	if (!$currentFolder) {
		Write-Verbose "Removing empty folder at path '${ArgPath}'." -Verbose
		Remove-Item -Force -LiteralPath $ArgPath
	}
}

Set-Variable -Name illegalChars -Value ([string]"[$([Regex]::Escape(-join [System.Io.Path]::GetInvalidFileNameChars()))]") -Option Constant
if ($Multi) {
	$bundles = Get-ChildItem -LiteralPath $Path -Directory
}
else {
	$bundles = @(Get-Item -LiteralPath $Path)
}
$count = $bundles.Count

for ($i = 0; $i -lt $count; $i++) {
	# Arraylist with all ebook files in the target path
	Write-Verbose "Ordering bundle $($i+1) of $count ($($bundles[$i].Name))" -Verbose
	[System.Collections.ArrayList]$unfilteredFiles = 
		Get-ChildItem -Path $bundles[$i] -File -Recurse |
		Where-Object -Property Extension -Match "pdf|epub|mobi" |
		Sort-Object -Property {$_.baseName.Length}
	
	while ($unfilteredFiles.Count -gt 0) {
		# Take the last file, save it's name and remove it from $unfilteredFiles
		$sameBookFiles = [System.Collections.ArrayList]@()
		$targetFolder = $bundles[$i]
		$sameBookFiles.Add($unfilteredFiles[0])
		$unfilteredFiles.RemoveAt(0)
		
		# Compare the name of the rest of files with the current's one, add them to $sameBookFiles
		# and remove them from $unfilteredFiles
		for ($j = $unfilteredFiles.Count - 1; $j -ge 0; $j--) {
			if ($unfilteredFiles[$j].BaseName -match $sameBookFiles[0].BaseName) {
				$sameBookFiles.add($unfilteredFiles[$j])
				$unfilteredFiles.RemoveAt($j)
			}
		}

		# Rename files
		Write-Verbose "`n`tRenaming $($sameBookFiles[0].BaseName)" -Verbose
		foreach ($currentFile in $sameBookFiles) {
			$realTitle = Get-MetaTitle -File $currentFile -DeleteChars $illegalChars
			if ($realTitle) {
				for ($j = 0; $j -lt $sameBookFiles.Count; $j++) {
					if ($realTitle -ne $sameBookFiles[$j].BaseName) {
						$sameBookFiles[$j] = Rename-Item -PassThru -LiteralPath $sameBookFiles[$j] -NewName ($realTitle + $sameBookFiles[$j].Extension)
					}
				}
				break
			}
		}
		
		# Move the files to its corresponding folder
		if ($sameBookFiles.Count -gt 1) {
			[string]$targetFolder = Join-Path -Path $targetFolder -ChildPath $realTitle
			if (!(Test-Path $targetFolder)) {
				New-Item -Path $targetFolder -ItemType Directory
			}
		}
		Write-Verbose "`n`tMoving $($sameBookFiles[0].BaseName)" -Verbose
		foreach ($file in $sameBookFiles) {
			Move-Item -Path $file -Destination $targetFolder
		}
	}
}

deleteEmptyFolders($Path)