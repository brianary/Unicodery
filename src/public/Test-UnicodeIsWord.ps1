<#
.SYNOPSIS
True if the character matches the regular expression \w.

.INPUTS
System.String or System.Character to check whether the input is valid for a username.

.OUTPUTS
System.Boolean indicating the input is valid for a username.

.FUNCTIONALITY
Unicode

.LINK
https://learn.microsoft.com/dotnet/standard/base-types/regular-expression-language-quick-reference

.EXAMPLE
Test-UnicodeIsWord A

True
#>

[CmdletBinding()][OutputType([bool])] Param(
# A string to check for all characters' validity for usernames.
[Parameter(ParameterSetName='String',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputString,
# A character to check as valid for username use.
[Parameter(ParameterSetName='Character',Position=0,Mandatory=$true,ValueFromPipeline=$true)][char] $InputCharacter
)
Process
{
	switch($PSCmdlet.ParameterSetName)
	{
		Character {return $InputCharacter -match '\w'}
		String {return $InputString -match '\A\w+\z'}
	}
}
