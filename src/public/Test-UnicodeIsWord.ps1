<#
.SYNOPSIS
True if the input is alphanumeric or underscore.

.INPUTS
System.String or System.Character to check whether the input is alphanumeric or underscore.

.OUTPUTS
System.Boolean indicating the input is alphanumeric or underscore.

.FUNCTIONALITY
Unicode

.LINK
https://learn.microsoft.com/dotnet/standard/base-types/regular-expression-language-quick-reference

.EXAMPLE
Test-UnicodeIsWord A

True
#>

[CmdletBinding()][OutputType([bool])] Param(
# A string to test as being fully alphanumeric (including underscore).
[Parameter(ParameterSetName='String',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputString,
# A character to check as being alphanumeric (including underscore).
[Parameter(ParameterSetName='Character',Position=0,Mandatory=$true,ValueFromPipeline=$true)][char] $InputCharacter,
# A rune to check as being alphanumeric (including underscore).
[Parameter(ParameterSetName='Rune',Position=0,Mandatory=$true,ValueFromPipeline=$true)][text.rune] $InputRune
)
Process
{
	switch($PSCmdlet.ParameterSetName)
	{
		Character {return $InputCharacter -match '\w'}
		String {return $InputString -match '\A\w+\z'}
		Rune {return $InputRune -match '\w'}
	}
}
