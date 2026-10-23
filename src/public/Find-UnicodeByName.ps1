<#
.SYNOPSIS
Search Unicode code point names.

.FUNCTIONALITY
Unicode

.EXAMPLE
Find-UnicodeByName PAREN

Character Codepoint Name
--------- --------- ----
(         0028      LEFT PARENTHESIS
)         0029      RIGHT PARENTHESIS
...
#>

[CmdletBinding()] Param(
# The string to search for.
[Parameter(Position=0,Mandatory=$true)][string] $Query
)
Begin
{
	function Find-UnicodeName
	{
		[CmdletBinding()] Param(
		[Parameter(Position=0,Mandatory=$true)][string] $Query
		)
		if($Query -replace '`.' -notmatch '[*?[]') {$Query = "*$Query*"}
		return Get-UnicodeData |
			Where-Object Name -like $Query |
			Select-Object @{n='Character';e={"$([text.rune][convert]::ToInt32($_.Value,16))"}},
				@{n='Codepoint';e={$_.Value}},Name
	}

	function Find-Name
	{
		[CmdletBinding()] Param(
		[Parameter(Position=0,Mandatory=$true)][string] $Query
		)
		return Find-UnicodeName $Query
	}
}
Process
{
	Find-Name $Query
}
