<#
.SYNOPSIS
Tests True if the character matches the regular expression \w.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Test-UnicodeIsSurrogate' -Tag Test-UnicodeIsSurrogate,Test,UnicodeIsSurrogate,IsSurrogate,Surrogate {
	Context 'True if the character is a surrogate.' {
		It "Returns false for '<InputCharacter>'" -TestCases @(
			[char[]]@(0..0xFF) |ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsSurrogate $InputCharacter |Should -BeFalse -Because 'parameter should work'
			$InputCharacter |Test-UnicodeIsSurrogate |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputCharacter>'" -TestCases @(
			[char[]]"😏🤨🥸🐅🐈𓃠" |ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsSurrogate $InputCharacter |Should -BeTrue -Because 'parameter should work'
			$InputCharacter |Test-UnicodeIsSurrogate |Should -BeTrue -Because 'pipline should work'
		}
	}
	Context 'True if the entire string matches the regular expression \p{Cs}\z.' {
		It "Returns false for '<InputString>'" -TestCases @(
			@{ InputString = '.' }
			@{ InputString = ' x' }
			@{ InputString = 'x' }
		) {
			Param([string]$InputString)
			Test-UnicodeIsSurrogate -InputString $InputString |Should -BeFalse -Because 'parameter should work'
			$InputString |Test-UnicodeIsSurrogate |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputString>'" -TestCases @(
			@{ InputString = "😏🤨" }
			@{ InputString = "🥸" }
			@{ InputString = "🐅🐈" }
			@{ InputString = "𓃠" }
		) {
			Param([string]$InputString)
			Test-UnicodeIsSurrogate -InputString $InputString |Should -BeTrue -Because 'parameter should work'
			$InputString |Test-UnicodeIsSurrogate |Should -BeTrue -Because 'pipline should work'
		}
	}
	Context 'True if the rune is outside the BMP.' {
		It "Returns false for '<InputRune>'" -TestCases @(
			[text.rune[]]@(0..0xFFF) |ForEach-Object {@{ InputRune = $_ }}
		) {
			Param([text.rune]$InputRune)
			Test-UnicodeIsSurrogate -InputRune $InputRune |Should -BeFalse -Because 'parameter should work'
			$InputRune |Test-UnicodeIsSurrogate |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputRune>'" -TestCases @(
			[text.rune[]]@(0x10000..0x10FFF) |ForEach-Object {@{ InputRune = $_ }}
		) {
			Param([text.rune]$InputRune)
			Test-UnicodeIsSurrogate -InputRune $InputRune |Should -BeTrue -Because 'parameter should work'
			$InputRune |Test-UnicodeIsSurrogate |Should -BeTrue -Because 'pipline should work'
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
