<#
.SYNOPSIS
True if the input is an uppercase letter.

.INPUTS
System.String or System.Character to check whether the input is an uppercase letter.

.OUTPUTS
System.Boolean indicating the input is an uppercase letter.

.FUNCTIONALITY
Unicode

.LINK
https://learn.microsoft.com/dotnet/standard/base-types/regular-expression-language-quick-reference

.EXAMPLE
Test-UnicodeIsUppercase A

True
#>

[CmdletBinding()][OutputType([bool])] Param(
# A string to test as being fully an uppercase letter.
[Parameter(ParameterSetName='String',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputString,
# A character to check as being an uppercase letter.
[Parameter(ParameterSetName='Character',Position=0,Mandatory=$true,ValueFromPipeline=$true)][char] $InputCharacter,
# A rune to check as being an uppercase letter.
[Parameter(ParameterSetName='Rune',Position=0,Mandatory=$true,ValueFromPipeline=$true)][text.rune] $InputRune
)
Process
{
	switch($PSCmdlet.ParameterSetName)
	{
		Character {return [char]::IsUpper($InputCharacter)}
		String {return $InputString -cmatch '\A\p{Lu}+\z'}
		Rune {return $InputRune -cmatch '\p{Lu}'}
	}
}
