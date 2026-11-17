<#
.SYNOPSIS
Tests True if the character matches the regular expression \p{P}.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Test-UnicodeIsPunctuation' -Tag Test-UnicodeIsPunctuation,Test,UnicodeIsPunctuation,IsPunctuation {
	Context 'True if the character matches the regular expression \p{P}.' {
		It "Returns false for '<InputCharacter>'" -TestCases @(
			[char[]]@(0..0xFF) |Where-Object {$_ -match '\P{P}'} |ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsPunctuation $InputCharacter |Should -BeFalse -Because 'parameter should work'
			$InputCharacter |Test-UnicodeIsPunctuation |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputCharacter>'" -TestCases @(
			[char[]]@(0..0xFF) |Where-Object {$_ -match '\p{P}'} |ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsPunctuation $InputCharacter |Should -BeTrue -Because 'parameter should work'
			$InputCharacter |Test-UnicodeIsPunctuation |Should -BeTrue -Because 'pipline should work'
		}
	}
	Context 'True if the entire string matches the regular expression \p{P}.' {
		It "Returns false for '<InputString>'" -TestCases @(
			@{ InputString = 'X' }
			@{ InputString = ' x' }
			@{ InputString = 'x' }
		) {
			Param([string]$InputString)
			Test-UnicodeIsPunctuation -InputString $InputString |Should -BeFalse -Because 'parameter should work'
			$InputString |Test-UnicodeIsPunctuation |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputString>'" -TestCases @(
			@{ InputString = "." }
			@{ InputString = "--" }
			@{ InputString = "," }
			@{ InputString = "[-](.)" }
		) {
			Param([string]$InputString)
			Test-UnicodeIsPunctuation -InputString $InputString |Should -BeTrue -Because 'parameter should work'
			$InputString |Test-UnicodeIsPunctuation |Should -BeTrue -Because 'pipline should work'
		}
	}
	Context 'True if the rune matches the regular expression \p{P}.' {
		It "Returns false for '<InputRune>'" -TestCases @(
			[text.rune[]]@(0..0xFFF) |Where-Object {$_ -match '\P{P}'} |ForEach-Object {@{ InputRune = $_ }}
		) {
			Param([text.rune]$InputRune)
			Test-UnicodeIsPunctuation -InputRune $InputRune |Should -BeFalse -Because 'parameter should work'
			$InputRune |Test-UnicodeIsPunctuation |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputRune>'" -TestCases @(
			[text.rune[]]@(0..0xFFF) |Where-Object {$_ -match '\p{P}'} |ForEach-Object {@{ InputRune = $_ }}
		) {
			Param([text.rune]$InputRune)
			Test-UnicodeIsPunctuation -InputRune $InputRune |Should -BeTrue -Because 'parameter should work'
			$InputRune |Test-UnicodeIsPunctuation |Should -BeTrue -Because 'pipline should work'
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
