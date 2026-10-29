<#
.SYNOPSIS
Update a single file in the local cache from a URL.
#>

[CmdletBinding()] Param(
# The source URL to cache.
[Parameter(Position=0,Mandatory=$true)][uri] $Url,
# The local cachefile filename to use.
[Parameter(Position=1)][string] $Filename = $Url.Segments[-1]
)
$cachedir = $IsWindows ? (Join-Path $env:LOCALAPPDATA Unicodery) :
	$IsLinux ? '/var/cache/Unicodery' : "$env:temp/Unicodery"
if(!(Test-Path $cachedir -Type Container)) {New-Item $cachedir -Type Directory}
$cachefile = Join-Path $cachedir $Filename
if(!(Test-Path $cachefile -Type Leaf))
{
	$http = Invoke-WebRequest -Uri $Url -OutFile $cachefile -PassThru
	Write-Debug "Downloaded $Url to $cachefile"
	[datetime] $lastmod ="$($http.Headers['Last-Modified'])"
	(Get-Item $cachefile).LastWriteTime = $lastmod
	Write-Debug "Last modified date of $cachefile is $lastmod"
}
else
{
	if((Get-Date).AddDays(-1) -lt (Get-Item $cachefile).CreationTime)
	{
		Write-Debug ("Cache file $cachefile was recently downloaded at " +
			"$((Get-Item $cachefile).CreationTime)")
		return
	}
	$http = Invoke-WebRequest $Url -Method Head
	[datetime] $lastmod = "$($http.Headers['Last-Modified'])"
	if((Get-Item $cachefile).LastWriteTime -lt $lastmod)
	{
		Invoke-WebRequest $Url -OutFile $cachefile
		Write-Debug "Updated $Url to $cachefile"
		(Get-Item $cachefile).LastWriteTime = $lastmod
		Write-Debug "Last modified date of $cachefile is $lastmod"
	}
	else
	{
		Write-Debug "Cache file $cachefile was up-to-date"
	}
}
