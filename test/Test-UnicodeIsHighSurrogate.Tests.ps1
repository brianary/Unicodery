<#
.SYNOPSIS
Tests True if the character is a high surrogate.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Test-UnicodeIsHighSurrogate' -Tag Test-UnicodeIsHighSurrogate,Test,UnicodeIsHighSurrogate,IsHighSurrogate,Surrogate {
	Context 'True if the character is a surrogate.' {
		It "Returns false for '<InputCharacter>'" -TestCases @(
			[char[]]@(0xD000..0xD7FF)+[char[]]@(0xDC00..0xDFFF) |ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsHighSurrogate $InputCharacter |Should -BeFalse -Because 'parameter should work'
			$InputCharacter |Test-UnicodeIsHighSurrogate |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputCharacter>'" -TestCases @(
			[char[]]@(0xD800..0xDBFF) |ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsHighSurrogate $InputCharacter |Should -BeTrue -Because 'parameter should work'
			$InputCharacter |Test-UnicodeIsHighSurrogate |Should -BeTrue -Because 'pipline should work'
		}
	}
	Context 'True if the entire string matches the regular expression \p{Cs}\z.' {
		It "Returns false for '<InputString>'" -TestCases @(
			@{ InputString = '.' }
			@{ InputString = ' x' }
			@{ InputString = 'x' }
		) {
			Param([string]$InputString)
			Test-UnicodeIsHighSurrogate -InputString $InputString |Should -BeFalse -Because 'parameter should work'
			$InputString |Test-UnicodeIsHighSurrogate |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputString>'" -TestCases @(
			@{ InputString = "`u{D800}`u{D800}`u{D800}" }
			@{ InputString = "`u{D800}`u{D801}`u{D802}" }
		) {
			Param([string]$InputString)
			Test-UnicodeIsHighSurrogate -InputString $InputString |Should -BeTrue -Because 'parameter should work'
			$InputString |Test-UnicodeIsHighSurrogate |Should -BeTrue -Because 'pipline should work'
		}
	}
	Context 'Always false for a rune, which cannot store a surrogate codepoint or an incomplete glyph.' {
		It "Returns false for '<InputRune>'" -TestCases @(
			[text.rune[]]@(0..0xFFF) |ForEach-Object {@{ InputRune = $_ }}
		) {
			Param([text.rune]$InputRune)
			Test-UnicodeIsHighSurrogate -InputRune $InputRune |Should -BeFalse -Because 'parameter should work'
			$InputRune |Test-UnicodeIsHighSurrogate |Should -BeFalse -Because 'pipline should work'
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
