<#
.SYNOPSIS
True if the input is whitespace.

.INPUTS
System.String or System.Character to check whether the input is whitespace.

.OUTPUTS
System.Boolean indicating the input is whitespace.

.FUNCTIONALITY
Unicode

.LINK
https://learn.microsoft.com/dotnet/standard/base-types/regular-expression-language-quick-reference

.EXAMPLE
Test-UnicodeIsWhiteSpace A

False
#>

[CmdletBinding()][OutputType([bool])] Param(
# A string to test as being fully whitespace.
[Parameter(ParameterSetName='String',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputString,
# A character to check as being whitespace.
[Parameter(ParameterSetName='Character',Position=0,Mandatory=$true,ValueFromPipeline=$true)][char] $InputCharacter,
# A rune to check as being whitespace.
[Parameter(ParameterSetName='Rune',Position=0,Mandatory=$true,ValueFromPipeline=$true)][text.rune] $InputRune
)
Process
{
	switch($PSCmdlet.ParameterSetName)
	{
		Character {return [char]::IsWhiteSpace($InputCharacter)}
		String {return $InputString -match '\A\s+\z'}
		Rune {return $InputRune -match '\s'}
	}
}
