<#
.SYNOPSIS
True if the input is symbol content.

.INPUTS
System.String or System.Character to check whether the input is symbol content.

.OUTPUTS
System.Boolean indicating the input is symbol content.

.FUNCTIONALITY
Unicode

.LINK
https://learn.microsoft.com/dotnet/standard/base-types/regular-expression-language-quick-reference

.EXAMPLE
Test-UnicodeIsSymbol A

False
#>

[CmdletBinding()][OutputType([bool])] Param(
# A string to test as being fully symbol content.
[Parameter(ParameterSetName='String',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputString,
# A character to check as being symbol content.
[Parameter(ParameterSetName='Character',Position=0,Mandatory=$true,ValueFromPipeline=$true)][char] $InputCharacter,
# A rune to check as being symbol content.
[Parameter(ParameterSetName='Rune',Position=0,Mandatory=$true,ValueFromPipeline=$true)][text.rune] $InputRune
)
Process
{
	switch($PSCmdlet.ParameterSetName)
	{
		Character {return [char]::IsSymbol($InputCharacter)}
		String {return $InputString -match '\A\p{S}+\z'}
		Rune {return $InputRune -match '\p{S}'}
	}
}
