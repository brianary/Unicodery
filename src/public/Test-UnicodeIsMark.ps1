<#
.SYNOPSIS
True if the input is mark content.

.INPUTS
System.String or System.Character to check whether the input is mark content.

.OUTPUTS
System.Boolean indicating the input is mark content.

.FUNCTIONALITY
Unicode

.LINK
https://learn.microsoft.com/dotnet/standard/base-types/regular-expression-language-quick-reference

.EXAMPLE
Test-UnicodeIsSymbol A

False
#>

[CmdletBinding()][OutputType([bool])] Param(
# A string to test as being fully mark content.
[Parameter(ParameterSetName='String',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputString,
# A character to check as being mark content.
[Parameter(ParameterSetName='Character',Position=0,Mandatory=$true,ValueFromPipeline=$true)][char] $InputCharacter,
# A rune to check as being mark content.
[Parameter(ParameterSetName='Rune',Position=0,Mandatory=$true,ValueFromPipeline=$true)][text.rune] $InputRune
)
Process
{
	switch($PSCmdlet.ParameterSetName)
	{
		Character {return $InputCharacter -match '\p{M}'}
		String {return $InputString -match '\A\p{M}+\z'}
		Rune {return $InputRune -match '\p{M}'}
	}
}
