<#
.SYNOPSIS
True if the input is punctuation content.

.INPUTS
System.String or System.Character to check whether the input is punctuation content.

.OUTPUTS
System.Boolean indicating the input is punctuation content.

.FUNCTIONALITY
Unicode

.LINK
https://learn.microsoft.com/dotnet/standard/base-types/regular-expression-language-quick-reference

.EXAMPLE
Test-UnicodeIsSymbol A

False
#>

[CmdletBinding()][OutputType([bool])] Param(
# A string to test as being fully punctuation content.
[Parameter(ParameterSetName='String',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputString,
# A character to check as being punctuation content.
[Parameter(ParameterSetName='Character',Position=0,Mandatory=$true,ValueFromPipeline=$true)][char] $InputCharacter,
# A rune to check as being punctuation content.
[Parameter(ParameterSetName='Rune',Position=0,Mandatory=$true,ValueFromPipeline=$true)][text.rune] $InputRune
)
Process
{
	switch($PSCmdlet.ParameterSetName)
	{
		Character {return [char]::IsPunctuation($InputCharacter)}
		String {return $InputString -match '\A\p{P}+\z'}
		Rune {return $InputRune -match '\p{P}'}
	}
}
