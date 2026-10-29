<#
.SYNOPSIS
Returns the current (cached) Unicode character data.

.OUTPUTS
System.Management.Automation.PSCustomObject for each character entry with these properties:
* BidirectionalCategory
* Category
* CombiningClass
* Comment
* DecimalDigitValue
* DecompositionMapping
* DigitValue
* Lower
* Mirrored
* Name
* NumericValue
* OldName
* Title
* Upper
* Value

.FUNCTIONALITY
Unicode

.LINK
https://www.unicode.org/L2/L1999/UnicodeData.html

.EXAMPLE
Get-UnicodeData |Export-Csv data/UnicodeData.csv

Saves the current Unicode data as a CSV file.
#>

[CmdletBinding()][OutputType([pscustomobject])] Param(
# The source location of the latest Unicode data.
[uri] $Url = 'https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt',
# The local filename to use.
[string] $DataFile = ($Url.Segments[-1])
)
Import-Csv (Get-CachePath UnicodeData.txt) -Delimiter ';' -Header Value,Name,Category,
	CombiningClass,BidirectionalCategory,DecompositionMapping,DecimalDigitValue,DigitValue,
	NumericValue,Mirrored,OldName,Comment,Upper,Lower,Title
