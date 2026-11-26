<#
.SYNOPSIS
Returns the Unicode block detail for the input.

.INPUTS
System.String or System.Character to return the Unicode block for.

.OUTPUTS
System.Management.Automation.PSObject with these properties:
* RangeFrom: The start of the block's range.
* RangeTo: The end of the block's range.
* BlockName: The name of the block.
* BlockMatch: The \p{Is*} character class that will match codepoints from the block.
* BlockId: The shortened name of the block, suitable for use as an identifier.

.FUNCTIONALITY
Unicode

.LINK
https://www.unicode.org/Public/UCD/latest/ucd/Blocks.txt

.EXAMPLE
Get-UnicodeBlock A

RangeFrom  : 0
RangeTo    : 127
BlockName  : Basic Latin
BlockMatch : \p{IsBasicLatin}
BlockId    : BasicLatin
#>

[CmdletBinding()][OutputType([pscustomobject])] Param(
# A string to return the blocks for.
[Parameter(ParameterSetName='String',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputString,
# A character to return the block for.
[Parameter(ParameterSetName='Character',Position=0,Mandatory=$true,ValueFromPipeline=$true)][char] $InputCharacter,
# A rune to return the block for.
[Parameter(ParameterSetName='Rune',Position=0,Mandatory=$true,ValueFromPipeline=$true)][text.rune] $InputRune
)
Begin
{
	Update-UnicodeCache
	$data = Import-Csv (Get-CachePath BlockNames.csv)
	$data |ForEach-Object {$_.RangeFrom = [int]$_.RangeFrom; $_.RangeTo = [int]$_.RangeTo}
}
Process
{
	switch($PSCmdlet.ParameterSetName)
	{
		String
		{
			return $InputString.EnumerateRunes() |Get-UnicodeBlock
		}
		Character
		{
			return $data |
				Where-Object RangeTo -ge ([int]$InputCharacter) |
				Select-Object -First 1
		}
		Rune
		{
			return $data |
				Where-Object RangeTo -ge $InputRune.Value |
				Select-Object -First 1
		}
	}
}
