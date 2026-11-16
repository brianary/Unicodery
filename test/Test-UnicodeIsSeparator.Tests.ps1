<#
.SYNOPSIS
Tests True if the character matches the regular expression \p{Z}.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Test-UnicodeIsSeparator' -Tag Test-UnicodeIsSeparator,Test,UnicodeIsSeparator,IsSeparator {
	Context 'True if the character matches the regular expression \p{Z}.' {
		It "Returns false for '<InputCharacter>'" -TestCases @(
			[char[]]@(0..0xFF) |Where-Object {$_ -match '\P{Z}'} |ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsSeparator $InputCharacter |Should -BeFalse -Because 'parameter should work'
			$InputCharacter |Test-UnicodeIsSeparator |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputCharacter>'" -TestCases @(
			[char[]]@(0..0xFF) |Where-Object {$_ -match '\p{Z}'} |ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsSeparator $InputCharacter |Should -BeTrue -Because 'parameter should work'
			$InputCharacter |Test-UnicodeIsSeparator |Should -BeTrue -Because 'pipline should work'
		}
	}
	Context 'True if the entire string matches the regular expression \p{Z}.' {
		It "Returns false for '<InputString>'" -TestCases @(
			@{ InputString = ".," }
			@{ InputString = "-" }
			@{ InputString = "`t`n" }
			@{ InputString = "`t `n" }
		) {
			Param([string]$InputString)
			Test-UnicodeIsSeparator -InputString $InputString |Should -BeFalse -Because 'parameter should work'
			$InputString |Test-UnicodeIsSeparator |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputString>'" -TestCases @(
			@{ InputString = "$([char]0xA0)" }
			@{ InputString = ' ' }
		) {
			Param([string]$InputString)
			Test-UnicodeIsSeparator -InputString $InputString |Should -BeTrue -Because 'parameter should work'
			$InputString |Test-UnicodeIsSeparator |Should -BeTrue -Because 'pipline should work'
		}
	}
	Context 'True if the rune matches the regular expression \p{Z}.' {
		It "Returns false for '<InputRune>'" -TestCases @(
			[text.rune[]]@(0..0xFFF) |Where-Object {$_ -match '\P{Z}'} |ForEach-Object {@{ InputRune = $_ }}
		) {
			Param([text.rune]$InputRune)
			Test-UnicodeIsSeparator -InputRune $InputRune |Should -BeFalse -Because 'parameter should work'
			$InputRune |Test-UnicodeIsSeparator |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputRune>'" -TestCases @(
			[text.rune[]]@(0..0xFFF) |Where-Object {$_ -match '\p{Z}'} |ForEach-Object {@{ InputRune = $_ }}
		) {
			Param([text.rune]$InputRune)
			Test-UnicodeIsSeparator -InputRune $InputRune |Should -BeTrue -Because 'parameter should work'
			$InputRune |Test-UnicodeIsSeparator |Should -BeTrue -Because 'pipline should work'
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
