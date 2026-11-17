<#
.SYNOPSIS
True if the input is numeric.

.INPUTS
System.String or System.Character to check whether the input is numeric.

.OUTPUTS
System.Boolean indicating the input is numeric.

.FUNCTIONALITY
Unicode

.LINK
https://learn.microsoft.com/dotnet/standard/base-types/regular-expression-language-quick-reference

.EXAMPLE
Test-UnicodeIsSymbol A

False
#>

[CmdletBinding()][OutputType([bool])] Param(
# A string to test as being fully numeric.
[Parameter(ParameterSetName='String',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputString,
# A character to check as being numeric.
[Parameter(ParameterSetName='Character',Position=0,Mandatory=$true,ValueFromPipeline=$true)][char] $InputCharacter,
# A rune to check as being numeric.
[Parameter(ParameterSetName='Rune',Position=0,Mandatory=$true,ValueFromPipeline=$true)][text.rune] $InputRune
)
Process
{
	switch($PSCmdlet.ParameterSetName)
	{
		Character {return [char]::IsNumber($InputCharacter)}
		String {return $InputString -match '\A\p{N}+\z'}
		Rune {return $InputRune -match '\p{N}'}
	}
}
