<#
.SYNOPSIS
True if the input is of letters or numbers.

.INPUTS
System.String or System.Character to check whether the input is alphanumeric or underscore.

.OUTPUTS
System.Boolean indicating the input is of letters or numbers.

.FUNCTIONALITY
Unicode

.LINK
https://learn.microsoft.com/dotnet/standard/base-types/regular-expression-language-quick-reference

.EXAMPLE
Test-UnicodeIsWord A

True
#>

[CmdletBinding()][OutputType([bool])] Param(
# A string to test as being alphanumeric.
[Parameter(ParameterSetName='String',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputString,
# A character to check as being alphanumeric.
[Parameter(ParameterSetName='Character',Position=0,Mandatory=$true,ValueFromPipeline=$true)][char] $InputCharacter,
# A rune to check as being alphanumeric.
[Parameter(ParameterSetName='Rune',Position=0,Mandatory=$true,ValueFromPipeline=$true)][text.rune] $InputRune
)
Process
{
	switch($PSCmdlet.ParameterSetName)
	{
		Character {return [char]::IsLetterOrDigit($InputCharacter)}
		String {return $InputString -match '\A\w+\z' -and $InputString -notlike '*_*'}
		Rune {return "$InputRune" -ne '_' -and $InputRune -match '\w'}
	}
}
