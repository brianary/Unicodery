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
[switch] $CurrentPlatformOnly
)
Begin
{
    [char[]] $invalidFileNameChars = $CurrentPlatformOnly ?
		([IO.Path]::GetInvalidFileNameChars()) :
        @(0..0x1F)+@('"', '*', '/', ':', '<', '>', '?', '\', '|',0x7F)
}
Process
{
	switch($PSCmdlet.ParameterSetName)
	{
		String {return $InputString.IndexOfAny($invalidFileNameChars) -eq -1}
		Character {return $invalidFileNameChars -notcontains $InputCharacter}
	}
}
