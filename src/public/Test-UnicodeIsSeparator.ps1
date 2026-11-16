<#
.SYNOPSIS
True if the input is separator content.

.INPUTS
System.String or System.Character to check whether the input is separator content.

.OUTPUTS
System.Boolean indicating the input is separator content.

.FUNCTIONALITY
Unicode

.LINK
https://learn.microsoft.com/dotnet/standard/base-types/regular-expression-language-quick-reference

.EXAMPLE
Test-UnicodeIsSeparator A

False
#>

[CmdletBinding()][OutputType([bool])] Param(
# A string to test as being fully separator content.
[Parameter(ParameterSetName='String',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputString,
# A character to check as being separator content.
[Parameter(ParameterSetName='Character',Position=0,Mandatory=$true,ValueFromPipeline=$true)][char] $InputCharacter,
# A rune to check as being separator content.
[Parameter(ParameterSetName='Rune',Position=0,Mandatory=$true,ValueFromPipeline=$true)][text.rune] $InputRune
)
Process
{
	switch($PSCmdlet.ParameterSetName)
	{
		Character {return [char]::IsSeparator($InputCharacter)}
		String {return $InputString -match '\A\p{Z}+\z'}
		Rune {return $InputRune -match '\p{Z}'}
	}
}
