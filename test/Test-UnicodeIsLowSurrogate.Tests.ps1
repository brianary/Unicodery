<#
.SYNOPSIS
Tests True if the character is a low surrogate.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Test-UnicodeIsLowSurrogate' -Tag Test-UnicodeIsLowSurrogate,Test,UnicodeIsLowSurrogate,IsLowSurrogate,Surrogate {
	Context 'True if the character is a surrogate.' {
		It "Returns false for '<InputCharacter>'" -TestCases @(
			[char[]]@(0xD000..0xDBFF) |ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsLowSurrogate $InputCharacter |Should -BeFalse -Because 'parameter should work'
			$InputCharacter |Test-UnicodeIsLowSurrogate |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputCharacter>'" -TestCases @(
			[char[]]@(0xDC00..0xDFFF) |ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsLowSurrogate $InputCharacter |Should -BeTrue -Because 'parameter should work'
			$InputCharacter |Test-UnicodeIsLowSurrogate |Should -BeTrue -Because 'pipline should work'
		}
	}
	Context 'True if the entire string matches the regular expression \p{Cs}\z.' {
		It "Returns false for '<InputString>'" -TestCases @(
			@{ InputString = '.' }
			@{ InputString = ' x' }
			@{ InputString = 'x' }
		) {
			Param([string]$InputString)
			Test-UnicodeIsLowSurrogate -InputString $InputString |Should -BeFalse -Because 'parameter should work'
			$InputString |Test-UnicodeIsLowSurrogate |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputString>'" -TestCases @(
			@{ InputString = "`u{DC00}`u{DC00}`u{DC00}" }
			@{ InputString = "`u{DC00}`u{DC02}`u{DC02}" }
		) {
			Param([string]$InputString)
			Test-UnicodeIsLowSurrogate -InputString $InputString |Should -BeTrue -Because 'parameter should work'
			$InputString |Test-UnicodeIsLowSurrogate |Should -BeTrue -Because 'pipline should work'
		}
	}
	Context 'Always false for a rune, which cannot store a surrogate codepoint or an incomplete glyph.' {
		It "Returns false for '<InputRune>'" -TestCases @(
			[text.rune[]]@(0..0xFFF) |ForEach-Object {@{ InputRune = $_ }}
		) {
			Param([text.rune]$InputRune)
			Test-UnicodeIsLowSurrogate -InputRune $InputRune |Should -BeFalse -Because 'parameter should work'
			$InputRune |Test-UnicodeIsLowSurrogate |Should -BeFalse -Because 'pipline should work'
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
