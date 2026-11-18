<#
.SYNOPSIS
True if the input is of letters.

.INPUTS
System.String or System.Character to check whether the input is a letter.

.OUTPUTS
System.Boolean indicating the input is of letters.

.FUNCTIONALITY
Unicode

.LINK
https://learn.microsoft.com/dotnet/standard/base-types/regular-expression-language-quick-reference

.EXAMPLE
Test-UnicodeIsWord A

True
#>

[CmdletBinding()][OutputType([bool])] Param(
# A string to test as being of letters.
[Parameter(ParameterSetName='String',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputString,
# A character to check as being of letters.
[Parameter(ParameterSetName='Character',Position=0,Mandatory=$true,ValueFromPipeline=$true)][char] $InputCharacter,
# A rune to check as being of letters.
[Parameter(ParameterSetName='Rune',Position=0,Mandatory=$true,ValueFromPipeline=$true)][text.rune] $InputRune
)
Process
{
	switch($PSCmdlet.ParameterSetName)
	{
		Character {return $InputCharacter -match '\p{L}'}
		String {return $InputString -match '\A\p{L}+\z'}
		Rune {return $InputRune -match '\p{L}'}
	}
}
