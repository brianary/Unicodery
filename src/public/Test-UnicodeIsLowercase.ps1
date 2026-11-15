<#
.SYNOPSIS
True if the input is an lowercase letter.

.INPUTS
System.String or System.Character to check whether the input is an lowercase letter.

.OUTPUTS
System.Boolean indicating the input is an lowercase letter.

.FUNCTIONALITY
Unicode

.LINK
https://learn.microsoft.com/dotnet/standard/base-types/regular-expression-language-quick-reference

.EXAMPLE
Test-UnicodeIsLowercase A

False
#>

[CmdletBinding()][OutputType([bool])] Param(
# A string to test as being fully an lowercase letter.
[Parameter(ParameterSetName='String',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputString,
# A character to check as being an lowercase letter.
[Parameter(ParameterSetName='Character',Position=0,Mandatory=$true,ValueFromPipeline=$true)][char] $InputCharacter,
# A rune to check as being an lowercase letter.
[Parameter(ParameterSetName='Rune',Position=0,Mandatory=$true,ValueFromPipeline=$true)][text.rune] $InputRune
)
Process
{
	switch($PSCmdlet.ParameterSetName)
	{
		Character {return [char]::IsLower($InputCharacter)}
		String {return $InputString -cmatch '\A\p{Ll}+\z'}
		Rune {return $InputRune -cmatch '\p{Ll}'}
	}
}
