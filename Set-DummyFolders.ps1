# This creates some test data under C:\a (make sure this is not
# a directory you care about, because this will remove it if it
# exists). This test data contains a directory that is hidden
# that should be removed as well as a file that is hidden in a
# directory that should not be removed.
Remove-Item -Force -Path C:\a -Recurse
New-Item -Force -Path C:\a\b\c\d -ItemType Directory > $null
$hiddenFolder = Get-Item -Force -LiteralPath C:\a\b\c
$hiddenFolder.Attributes = $hiddenFolder.Attributes -bor [System.IO.FileAttributes]::Hidden
New-Item -Force -Path C:\a\b\e -ItemType Directory > $null
New-Item -Force -Path C:\a\f -ItemType Directory > $null
New-Item -Force -Path C:\a\f\g -ItemType Directory > $null
New-Item -Force -Path C:\a\f\h -ItemType Directory > $null
Out-File -Force -FilePath C:\a\f\test.txt -InputObject 'Dummy file'
Out-File -Force -FilePath C:\a\f\h\hidden.txt -InputObject 'Hidden file'
$hiddenFile = Get-Item -Force -LiteralPath C:\a\f\h\hidden.txt
$hiddenFile.Attributes = $hiddenFile.Attributes -bor [System.IO.FileAttributes]::Hidden
