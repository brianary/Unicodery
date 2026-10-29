<#
.SYNOPSIS
Returns characters based on Unicode code point name, GitHub short code, or HTML entity.

.INPUTS
System.String of a character name.

.OUTPUTS
System.String of the character(s) referenced by name.

.FUNCTIONALITY
Unicode

.LINK
https://www.unicode.org/Public/UCD/latest/ucd/NameAliases.txt

.LINK
https://html.spec.whatwg.org/multipage/named-characters.html

.EXAMPLE
Get-UnicodeByName hyphen-minus

-

.EXAMPLE
Get-UnicodeByName slash

/

.EXAMPLE
Get-UnicodeByName :zero:

[0]

.EXAMPLE
Get-UnicodeByName '&amp;'

&

.EXAMPLE
Get-UnicodeByName BEL

(beeps)
#>

[CmdletBinding()][OutputType([string])] Param(
# The name or alias of a Unicode character.
[Parameter(ParameterSetName='Name',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $Name,
<#
Appends a U+FE0F VARIATION SELECTOR-16 suffix to the character, which suggests an emoji presentation
for characters that support both a simple text presentation as well as a color emoji-style one.
#>
[switch] $AsEmoji,
<#
Appends a U+FE0E VARIATION SELECTOR-15 suffix to the character, which suggests a textual presentation
(non-emoji) for characters that support both a simple text presentation as well as a color emoji-style one.
#>
[Alias('NotEmoji','AsPlainText')][switch] $AsText
)
Begin
{
	Update-UnicodeCache
	$basename = Get-CachePath UnicodeByName
	$cc = ConvertFrom-StringData (Get-Content (Join-Path $PSScriptRoot UnicodeByName.cc.txt) -Raw)
	$codepoint = ConvertFrom-StringData (Get-Content "$basename.txt" -Raw)
	$html = Get-Content "$basename.html.json" -Raw |ConvertFrom-Json -AsHashtable
	$github = ConvertFrom-StringData (Get-Content "$basename.github.txt" -Raw)
	filter ConvertTo-Char
	{
		Param(
		[Parameter(Position=0)][AllowNull()][string] $Suffix,
		[Parameter(ValueFromPipeline=$true,Mandatory=$true)][string] $Value
		)
		return ((($Value -split '\W+') |
			ForEach-Object {[char]::ConvertFromUtf32([convert]::ToInt32($_,16))}) -join '') + $Suffix
	}
}
Process
{
	$spName = $Name.Replace('_',' ')
	$suffix = $AsEmoji ? "$([char]0xFE0F)" : $AsText ? "$([char]0xFE0E)" : $null
	if($cc.ContainsKey($spName)) {return $cc[$spName] |ConvertTo-Char $suffix}
	elseif($github.ContainsKey($Name)) {return $github[$Name] |ConvertTo-Char $suffix}
	elseif($html.ContainsKey($spName)) {return ($html[$spName].characters -join '') + $suffix}
	elseif($codepoint.ContainsKey($spName)) {return $codepoint[$spName] |ConvertTo-Char $suffix}
	else {throw "Unable to locate character by name '$Name'"}
}
