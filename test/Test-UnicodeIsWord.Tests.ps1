<#
.SYNOPSIS
Tests True if the character matches the regular expression \w.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Test-UnicodeIsWord' -Tag Test-UnicodeIsWord,Test,UnicodeIsWord {
	Context 'True if the character matches the regular expression \w.' {
		It "Returns false for '<InputCharacter>'" -TestCases @(
			[char[]]@(0..0xFF) |Where-Object {$_ -match '\W'} |ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsWord $InputCharacter |Should -BeFalse -Because 'parameter should work'
			$InputCharacter |Test-UnicodeIsWord |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputCharacter>'" -TestCases @(
			[char[]]@(0..0xFF) |Where-Object {$_ -match '\w'} |ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsWord $InputCharacter |Should -BeTrue -Because 'parameter should work'
			$InputCharacter |Test-UnicodeIsWord |Should -BeTrue -Because 'pipline should work'
		}
	}
	Context 'True if the entire string matches the regular expression \w.' {
		It "Returns false for '<InputString>'" -TestCases @(
			@{ InputString = 'not word' }
		) {
			Param([string]$InputString)
			Test-UnicodeIsWord -InputString $InputString |Should -BeFalse -Because 'parameter should work'
			$InputString |Test-UnicodeIsWord |Should -BeFalse -Because 'pipline should work'
		}
		It "Returns true for '<InputString>'" -TestCases @(
			@{ InputString = 'word' }
		) {
			Param([string]$InputString)
			Test-UnicodeIsWord -InputString $InputString |Should -BeTrue -Because 'parameter should work'
			$InputString |Test-UnicodeIsWord |Should -BeTrue -Because 'pipline should work'
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
