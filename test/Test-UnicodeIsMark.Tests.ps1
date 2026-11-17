<#
.SYNOPSIS
Tests True if the character matches the regular expression \p{M}.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Test-UnicodeIsMark' -Tag Test-UnicodeIsMark,Test,UnicodeIsMark,IsMark {
	Context 'True if the character matches the regular expression \p{M}.' {
		It "Returns false for '<InputCharacter>'" -TestCases @(
			[char[]]@(0x2000..0x2600) |Where-Object {$_ -match '\P{M}'} |ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsMark $InputCharacter |Should -BeFalse -Because 'parameter should work'
			$InputCharacter |Test-UnicodeIsMark |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputCharacter>'" -TestCases @(
			[char[]]@(0x2000..0x2600) |Where-Object {$_ -match '\p{M}'} |ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsMark $InputCharacter |Should -BeTrue -Because 'parameter should work'
			$InputCharacter |Test-UnicodeIsMark |Should -BeTrue -Because 'pipline should work'
		}
	}
	Context 'True if the entire string matches the regular expression \p{M}.' {
		It "Returns false for '<InputString>'" -TestCases @(
			@{ InputString = 'X' }
			@{ InputString = ' x' }
			@{ InputString = 'x' }
		) {
			Param([string]$InputString)
			Test-UnicodeIsMark -InputString $InputString |Should -BeFalse -Because 'parameter should work'
			$InputString |Test-UnicodeIsMark |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputString>'" -TestCases @(
			@{ InputString = "҈" }
			@{ InputString = "꙱" }
			@{ InputString = "̃" }
			@{ InputString = "⃠" }
			@{ InputString = "⃣" }
		) {
			Param([string]$InputString)
			Test-UnicodeIsMark -InputString $InputString |Should -BeTrue -Because 'parameter should work'
			$InputString |Test-UnicodeIsMark |Should -BeTrue -Because 'pipline should work'
		}
	}
	Context 'True if the rune matches the regular expression \p{M}.' {
		It "Returns false for '<InputRune>'" -TestCases @(
			[text.rune[]]@(0x2000..0x2600) |Where-Object {$_ -match '\P{M}'} |ForEach-Object {@{ InputRune = $_ }}
		) {
			Param([text.rune]$InputRune)
			Test-UnicodeIsMark -InputRune $InputRune |Should -BeFalse -Because 'parameter should work'
			$InputRune |Test-UnicodeIsMark |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputRune>'" -TestCases @(
			[text.rune[]]@(0x2000..0x2600) |Where-Object {$_ -match '\p{M}'} |ForEach-Object {@{ InputRune = $_ }}
		) {
			Param([text.rune]$InputRune)
			Test-UnicodeIsMark -InputRune $InputRune |Should -BeTrue -Because 'parameter should work'
			$InputRune |Test-UnicodeIsMark |Should -BeTrue -Because 'pipline should work'
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
