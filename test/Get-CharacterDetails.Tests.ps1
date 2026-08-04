<#
.SYNOPSIS
Tests Returns filterable categorical information about characters in the Unicode Basic Multilingual Plane.
#>

return #TODO: Write test.
if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Get-CharacterDetails' -Tag Get-CharacterDetails,Get,CharacterDetails {
	Context 'Returns filterable categorical information about characters in the Unicode Basic Multilingual Plane.' -Tag Example {
		It "EXAMPLE 1" -Skip {
			Get-CharacterDetails ASCII |Out-GridView |Should -BeExactly @"
Learn everything about 7-bit ASCII, the first 128 characters in the Unicode standard.
"@
		}
		It "EXAMPLE 2" -Skip {
			Get-CharacterDetails GeneralPunctuation -IsSymbol |Should -BeExactly @"
Returns the two characters in the GeneralPunctuation block categorized as symbols.
"@
		}
		It "EXAMPLE 3" -Skip {
			Get-CharacterDetails ASCII -IsWord -NotLetter -NotDigit |Should -BeExactly @"
Character           : _
Value               : 95
CodePoint           : U+005F
UnicodeBlock        : BasicLatin
MatchesBlock        : True
UnicodeCategory     : ConnectorPunctuation
CategoryClasses     : {Pc, P}
XmlEncode           : _
HtmlAttributeEncode : _
UrlEncode           : _
HttpUrlEncode       : _
UrlEncodeUnicode    : _
EscapeDataString    : _
EscapeUriString     : _
UrlPathEncode       : _
IsControl           : False
IsDigit             : False
IsHighSurrogate     : False
IsLegalUserName     : True
IsLegalFileName     : True
IsLetter            : False
IsLetterOrDigit     : False
IsLower             : False
IsLowSurrogate      : False
IsMark              : False
IsNumber            : False
IsPunctuation       : True
IsSeparator         : False
IsSurrogate         : False
IsSymbol            : False
IsUpper             : False
IsWhiteSpace        : False
IsWord              : True
"@
		}
	}
	Context 'Block' -Tag Block {
		It "test" -Skip {
			1 |Should -Be 1
		}
	}
	Context 'Char' -Tag Char {
		It "test" -Skip {
			1 |Should -Be 1
		}
	}
	Context 'Value' -Tag Value {
		It "test" -Skip {
			1 |Should -Be 1
		}
	}
	Context 'Range' -Tag Range {
		It "test" -Skip {
			1 |Should -Be 1
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
