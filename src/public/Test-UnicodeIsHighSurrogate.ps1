<#
.SYNOPSIS
True if the input is made up of UTF-16 high surrogates (U+D800-U+DBFF).

.INPUTS
System.String or System.Character to check whether the input is made up of UTF-16 high surrogates.

.OUTPUTS
System.Boolean indicating the input is made up of UTF-16 high surrogates.

.FUNCTIONALITY
Unicode

.LINK
https://learn.microsoft.com/dotnet/standard/base-types/regular-expression-language-quick-reference

.EXAMPLE
Test-UnicodeIsHighSurrogate A

False
#>

[CmdletBinding()][OutputType([bool])] Param(
# A string to test as being fully made up of UTF-16 high surrogates.
[Parameter(ParameterSetName='String',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputString,
# A character to check as being made up of UTF-16 high surrogates.
[Parameter(ParameterSetName='Character',Position=0,Mandatory=$true,ValueFromPipeline=$true)][char] $InputCharacter,
# A rune to check as being made up of UTF-16 high surrogates.
[Parameter(ParameterSetName='Rune',Position=0,Mandatory=$true,ValueFromPipeline=$true)][text.rune] $InputRune
)
Process
{
	switch($PSCmdlet.ParameterSetName)
	{
		Character {return [char]::IsHighSurrogate($InputCharacter)}
		String {return $InputString -match '\A[\uD800-\uDBFF]+\z'}
		Rune {return $false}
	}
}
