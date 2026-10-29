<#
.SYNOPSIS
Get the platform-appropriate cache folder.
#>

[CmdletBinding()][OutputType([string])] Param(
# The local filename to use within the cache.
[Parameter(Position=0)][string] $Filename = ''
)
$cachedir = ($IsWindows ? (Join-Path $env:LOCALAPPDATA Unicodery) :
	$IsLinux ? '~/.cache/unicodery' : "$env:temp/Unicodery")
if(!(Test-Path $cachedir -Type Container)) {New-Item $cachedir -Type Directory |Out-Null}
return Join-Path $cachedir $Filename
