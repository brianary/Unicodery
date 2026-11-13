<#
.SYNOPSIS
True if the input is valid in a username.

.INPUTS
System.String or System.Character to check whether the input is valid for a username.

.OUTPUTS
System.Boolean indicating the input is valid for a username.

.FUNCTIONALITY
Unicode

.LINK
https://www.rfc-editor.org/rfc/rfc2253.html

.LINK
https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_437

.LINK
https://learn.microsoft.com/previous-versions/windows/it-pro/windows-2000-server/bb726984(v=technet.10)#:~:text=Rules%20for%20Logon%20Names

.LINK
https://learn.microsoft.com/archive/technet-wiki/11216.active-directory-requirements-for-creating-objects#objects-with-samaccountname-attribute

.LINK
https://learn.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-autologon-username#values

.LINK
https://en.wikipedia.org/wiki/User_(computing)#Username_format

.EXAMPLE
Test-UnicodeIsUserName '>'

False

.EXAMPLE
'sample.username' |Test-UnicodeIsUserName

True
#>

[CmdletBinding()][OutputType([bool])] Param(
# A string to check for all characters' validity for usernames.
[Parameter(ParameterSetName='String',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputString,
# A character to check as valid for username use.
[Parameter(ParameterSetName='Character',Position=0,Mandatory=$true,ValueFromPipeline=$true)][char] $InputCharacter,
# Indicates that only characters invalid for the current platform should be excluded by default,
# otherwise invalid characters from any platform will be excluded by default (unless overridden).
[switch] $CurrentPlatformOnly,
# A dramatically simplified character set that works with any POSIX-compliant system.
[switch] $PosixPortable
)
Begin
{
	[regex] $posixMatch = '\A[-A-Za-z0-9_.]+\z'
	[char[]] $posixPortableChars = @('A'..'Z')+@('a'..'z')+[char[]]'0123456798._-'
    [char[]] $invalidUserNameChars = !$CurrentPlatformOnly ? @(0..0x1F)+[char[]]",;:?`"[]*/\+<=>|`u{7F}" :
		$IsWindows ? @(0..0x1F)+[char[]]",;:?`"[]*/\+<=>|" :
		$IsLinux ? @(0..0x20)+[char[]]":/" :
		@(0..0x1F)+[char[]]",;:?`"[]*/\+<=>|"
	[regex] $goodUserMatch = !$CurrentPlatformOnly ? '\A(?=[^-].{0,19}\z).*[^ .]' :
		$IsWindows ? '\A(?=.{1,20}\z).*[^ .]' :
		$IsLinux ? '\A[^-].{0,31}\z' :
		'\A(?=[^-].{0,19}\z).*[^ .]'
	[regex] $badUserMatch = ($CurrentPlatformOnly -and !$IsWindows) ? '\A[- ]' : '\A-|[. ]\z'
	[string[]] $badUsernames = ($CurrentPlatformOnly -and !$IsWindows) ? @('.','..') : @('.','..','NONE')
}
Process
{
	if($PosixPortable)
	{
		switch($PSCmdlet.ParameterSetName)
		{
			String
			{
				Write-Debug "'$InputString' -notin @($(($badUsernames |ForEach-Object {"'$_'"}) -join ',')) ? $($InputString -notin $badUsernames)"
				Write-Debug "'$InputString' -notmatch '$badUserMatch' ? $($InputString -notmatch $badUserMatch)"
				Write-Debug "'$InputString' -match '$goodUserMatch' ? $($InputString -match $goodUserMatch)"
				Write-Debug "'$InputString' -match '$posixMatch' ? $($InputString -match $posixMatch)"
				return $InputString -notin $badUsernames -and
					$InputString -notmatch $badUserMatch -and
					$InputString -match $goodUserMatch -and
					$InputString -match $posixMatch
			}
			Character {return $InputCharacter -in $posixPortableChars}
		}
	}
	switch($PSCmdlet.ParameterSetName)
	{
		String
		{
			Write-Debug "'$InputString' -notin @($(($badUsernames |ForEach-Object {"'$_'"}) -join ',')) ? $($InputString -notin $badUsernames)"
			Write-Debug "'$InputString' -notmatch '$badUserMatch' ? $($InputString -notmatch $badUserMatch)"
			Write-Debug "'$InputString' -match '$goodUserMatch' ? $($InputString -match $goodUserMatch)"
			Write-Debug "'$InputString' -containsAny @($invalidUserNameChars) ? $($InputString.IndexOfAny($invalidUserNameChars) -eq -1)"
			return $InputString -notin $badUsernames -and
				$InputString -notmatch $badUserMatch -and
				$InputString -match $goodUserMatch -and
				$InputString.IndexOfAny($invalidUserNameChars) -eq -1
		}
		Character {return $InputCharacter -notin $invalidUserNameChars}
	}
}
