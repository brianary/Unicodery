<#
.SYNOPSIS
Tests True if the character matches the regular expression \d.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Test-UnicodeIsDigit' -Tag Test-UnicodeIsDigit,Test,UnicodeIsDigit,IsDigit {
	Context 'True if the character matches the regular expression \d.' {
		It "Returns false for '<InputCharacter>'" -TestCases @(
			[char[]]@(0..0xFF) |Where-Object {$_ -match '\D'} |ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsDigit $InputCharacter |Should -BeFalse -Because 'parameter should work'
			$InputCharacter |Test-UnicodeIsDigit |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputCharacter>'" -TestCases @(
			[char[]]@(0..0xFF) |Where-Object {$_ -match '\d'} |ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsDigit $InputCharacter |Should -BeTrue -Because 'parameter should work'
			$InputCharacter |Test-UnicodeIsDigit |Should -BeTrue -Because 'pipline should work'
		}
	}
	Context 'True if the entire string matches the regular expression \d.' {
		It "Returns false for '<InputString>'" -TestCases @(
			@{ InputString = 'not a number' }
			@{ InputString = 'NaN' }
		) {
			Param([string]$InputString)
			Test-UnicodeIsDigit -InputString $InputString |Should -BeFalse -Because 'parameter should work'
			$InputString |Test-UnicodeIsDigit |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputString>'" -TestCases @(
			@{ InputString = '00000' }
			@{ InputString = '98589' }
		) {
			Param([string]$InputString)
			Test-UnicodeIsDigit -InputString $InputString |Should -BeTrue -Because 'parameter should work'
			$InputString |Test-UnicodeIsDigit |Should -BeTrue -Because 'pipline should work'
		}
	}
	Context 'True if the rune matches the regular expression \d.' {
		It "Returns false for '<InputRune>'" -TestCases @(
			[text.rune[]]@(0..0xFFF) |Where-Object {$_ -match '\D'} |ForEach-Object {@{ InputRune = $_ }}
		) {
			Param([text.rune]$InputRune)
			Test-UnicodeIsDigit -InputRune $InputRune |Should -BeFalse -Because 'parameter should work'
			$InputRune |Test-UnicodeIsDigit |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputRune>'" -TestCases @(
			[text.rune[]]@(0..0xFFF) |Where-Object {$_ -match '\d'} |ForEach-Object {@{ InputRune = $_ }}
		) {
			Param([text.rune]$InputRune)
			Test-UnicodeIsDigit -InputRune $InputRune |Should -BeTrue -Because 'parameter should work'
			$InputRune |Test-UnicodeIsDigit |Should -BeTrue -Because 'pipline should work'
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
