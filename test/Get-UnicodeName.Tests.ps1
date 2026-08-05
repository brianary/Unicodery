<#
.SYNOPSIS
Tests returning the name of a Unicode code point.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Get-UnicodeName' -Tag Get-UnicodeName,Get,UnicodeName {
	Context 'Returns the name of a Unicode code point.' {
		It "Given code point number '<CodePoint>' should return '<Result>'" -TestCases @(
			@{ CodePoint = 32; Result = 'SPACE' }
			@{ CodePoint = 0x1F570; Result = 'MANTELPIECE CLOCK' }
			@{ CodePoint = 0x1F33F; Result = 'HERB' }
		) {
			Param([int]$CodePoint,[string]$Result)
			Get-UnicodeName -CodePoint $CodePoint |Should -BeExactly $Result
		}
		It "Given character '<Character>' should return '<Result>'" -TestCases @(
			@{ Character = ' '; Result = 'SPACE' }
			@{ Character = '-'; Result = 'HYPHEN-MINUS' }
			@{ Character = 'A'; Result = 'LATIN CAPITAL LETTER A' }
		) {
			Param([string]$Character,[string]$Result)
			Get-UnicodeName -Character $Character |Should -BeExactly $Result
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
