<#
.SYNOPSIS
Tests True if the input is valid in a Windows path.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
[char[]] $Script:invalidChars = @(0..0x1F)+@('"', '*', '/', ':', '<', '>', '?', '\', '|',0x7F)
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Test-UnicodeIsFileName' -Tag Test-UnicodeIsFileName,Test,UnicodeIsFileName {
	Context 'True if the input is valid in a filename' {
		It "Should be false for invalid character '<InputCharacter>'" -TestCases @(
	        $Script:invalidChars |
				ForEach-Object {@{ InputCharacter = [char]$_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsFileName $InputCharacter |Should -BeFalse -Because 'the parameter should work'
			$InputCharacter |Test-UnicodeIsFileName |Should -BeFalse -Because 'the pipeline should work'
		}
		It "Should be true for valid character '<InputCharacter>'" -TestCases @(
			([char]::MinValue)..([char]0xFF) |
	        	Where-Object {$Script:invalidChars -notcontains $_} |
				ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsFileName $InputCharacter |Should -BeTrue -Because 'the parameter should work'
			$InputCharacter |Test-UnicodeIsFileName |Should -BeTrue -Because 'the pipeline should work'
		}
		It "Should be false for invalid string '<InputString>'" -TestCases @(
			@{ InputString = 'A/B/C' }
			@{ InputString = '*\|/*' }
			@{ InputString = '<INPUT>' }
		) {
			Param([string]$InputString)
			Test-UnicodeIsFileName $InputString |Should -BeFalse -Because 'the pipeline should work'
			$InputString |Test-UnicodeIsFileName |Should -BeFalse -Because 'the pipeline should work'
		}
		It "Should be true for valid string '<InputString>'" -TestCases @(
			Get-ChildItem -Recurse -File |ForEach-Object {@{ InputString = $_.Name }}
		) {
			Param([string]$InputString)
			Test-UnicodeIsFileName $InputString |Should -BeTrue -Because 'the pipeline should work'
			$InputString |Test-UnicodeIsFileName |Should -BeTrue -Because 'the pipeline should work'
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
