<#
.SYNOPSIS
True if the input is valid in a filename.

.INPUTS
System.String or System.Character to check whether the input is valid for a filename.

.OUTPUTS
System.Boolean indicating the input is valid for a filename.

.FUNCTIONALITY
Unicode

.LINK
https://msdn.microsoft.com/library/system.io.path.getinvalidfilenamechars.aspx

.LINK
https://en.wikipedia.org/wiki/Portable_character_set#Portable_filename_character_set

.EXAMPLE
Test-UnicodeIsFileName '>'

False

.EXAMPLE
'README.md' |Test-UnicodeIsFileName

True
#>

[CmdletBinding()][OutputType([bool])] Param(
# A string to check for all characters' validity for filenames.
[Parameter(ParameterSetName='String',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputString,
# A character to check as valid for filename use.
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
	[char[]] $posixPortableChars = @('A'..'Z')+@('a'..'z')+@('0'..'9')+@('.','_','-')
    [char[]] $invalidFileNameChars = $CurrentPlatformOnly ?
		([IO.Path]::GetInvalidFileNameChars()) :
        @(0..0x1F)+[char[]]"`"*/:<>?\|`u{7F}"
	[regex] $badFileMatch = ($CurrentPlatformOnly -and !$IsWindows) ? '\A-' : '\A-|\.\z'
	[string[]] $badFilenames = ($CurrentPlatformOnly -and !$IsWindows) ? @('.','..') :
		@('.','..','CON','PRN','AUX','NUL')+@(0..9 |ForEach-Object {"COM$_","LPT$_"})
}
Process
{
	if($PosixPortable)
	{
		switch($PSCmdlet.ParameterSetName)
		{
			String
			{
				return $InputString -notin $badFilenames -and
					$InputString -notmatch $badFileMatch -and
					$InputString -match $posixMatch
			}
			Character {return $InputCharacter -in $posixPortableChars}
		}
	}
	switch($PSCmdlet.ParameterSetName)
	{
		String
		{
			return $InputString -notin $badFilenames -and
				$InputString -notmatch $badFileMatch -and
				$InputString.IndexOfAny($invalidFileNameChars) -eq -1
		}
		Character {return $InputCharacter -notin $invalidFileNameChars}
	}
}
