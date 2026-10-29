<#
.SYNOPSIS
Update a single file in the local cache from a URL.
#>

[CmdletBinding()][OutputType([string])] Param(
# The source URL to cache.
[Parameter(Position=0,Mandatory=$true)][uri] $Url,
# The local cachefile filename to use.
[Parameter(Position=1)][string] $Filename = $Url.Segments[-1]
)
$cachefile = Get-CachePath $Filename
if(!(Test-Path $cachefile -Type Leaf))
{
	$http = Invoke-WebRequest -Uri $Url -OutFile $cachefile -PassThru
	Write-Verbose "Downloaded $Url to '$cachefile'"
	[datetime] $lastmod ="$($http.Headers['Last-Modified'] ?? [datetime]::Today)"
	(Get-Item $cachefile).LastWriteTime = $lastmod
	Write-Verbose "Last modified date of '$cachefile' is $lastmod"
	return $cachefile
}
Write-Verbose "Cache file '$cachefile' was last updated $((Get-Item $cachefile).LastWriteTime)"
if((Get-Date).AddHours(-1) -lt (Get-Item $cachefile).LastAccessTime)
{
	Write-Verbose ("Cache file '$cachefile' was recently accessed at " +
		"$((Get-Item $cachefile).LastAccessTime)")
	return $cachefile
}
$http = Invoke-WebRequest $Url -Method Head
[datetime] $lastmod = "$($http.Headers['Last-Modified'] ?? [datetime]::Today)"
if($lastmod -le (Get-Item $cachefile).LastWriteTime)
{
	Write-Verbose "Cache file '$cachefile' was up-to-date"
	return $cachefile
}
Invoke-WebRequest $Url -OutFile $cachefile
Write-Verbose "Updated $Url to '$cachefile'"
(Get-Item $cachefile).LastWriteTime = $lastmod
Write-Verbose "Last modified date of '$cachefile' is $lastmod"
return $cachefile
