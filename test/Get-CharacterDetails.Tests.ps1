<#
.SYNOPSIS
Tests returning filterable categorical information about characters in the Unicode Basic Multilingual Plane.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Get-CharacterDetails' -Tag Get-CharacterDetails,Get,CharacterDetails {
	Context 'Returns filterable categorical information about characters in the Unicode Basic Multilingual Plane.' {
		It "Returns detail about the ASCII code block" {
			$ascii = Get-CharacterDetails ASCII
			$ascii |Should -HaveCount 128
			$ascii |Select-Object -Unique -ExpandProperty UnicodeBlock |Should -BeExactly BasicLatin
			$ascii
		}
		It "Filters the GeneralPunctuation block to two symbol characters" {
			Get-CharacterDetails GeneralPunctuation -IsSymbol |Should -HaveCount 2
		}
		It "Filters the ASCII block to one non-letter, non-digit word character" {
			$char = Get-CharacterDetails ASCII -IsWord -NotLetter -NotDigit
			$char |Should -HaveCount 1
			$char.Character |Should -BeExactly _
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
