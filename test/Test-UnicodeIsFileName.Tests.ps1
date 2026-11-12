<#
.SYNOPSIS
Tests True if the input is valid in a Windows path.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
[char[]] $posixPortable = @('A'..'Z')+@('a'..'z')+@('0'..'9')+@('.','_','-')
[char[]] $invalidChars = @(0..0x1F)+[char[]]"`"*/:<>?\|`u{7F}"
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Test-UnicodeIsFileName' -Tag Test-UnicodeIsFileName,Test,UnicodeIsFileName {
	Context 'True if the input is valid in a filename' {
		It "Should be false for invalid character '<InputCharacter>'" -TestCases @(
	        $invalidChars |
				ForEach-Object {@{ InputCharacter = [char]$_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsFileName $InputCharacter |Should -BeFalse -Because 'the parameter should work'
			$InputCharacter |Test-UnicodeIsFileName |Should -BeFalse -Because 'the pipeline should work'
		}
		It "Should be true for valid character '<InputCharacter>'" -TestCases @(
			([char]::MinValue)..([char]0xFF) |
	        	Where-Object {$invalidChars -notcontains $_} |
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
	Context 'True if the input is valid in a POSIX portable filename' {
		It "Should be false for invalid character '<InputCharacter>'" -TestCases @(
			([char]::MinValue)..([char]0xFF) |
	        	Where-Object {$posixPortable -notcontains $_} |
				ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsFileName $InputCharacter -PosixPortable |Should -BeFalse -Because 'the parameter should work'
			$InputCharacter |Test-UnicodeIsFileName -PosixPortable |Should -BeFalse -Because 'the pipeline should work'
		}
		It "Should be true for valid character '<InputCharacter>'" -TestCases @(
	        $posixPortable |
				ForEach-Object {@{ InputCharacter = [char]$_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsFileName $InputCharacter -PosixPortable |Should -BeTrue -Because 'the parameter should work'
			$InputCharacter |Test-UnicodeIsFileName -PosixPortable |Should -BeTrue -Because 'the pipeline should work'
		}
		It "Should be false for invalid string '<InputString>'" -TestCases @(
			@('A/B/C','-rf','one two','.','..','CON','PRN','AUX','NUL')+@(0..9 |ForEach-Object {"COM$_","LPT$_"}) |
				ForEach-Object {@{ InputString = $_ }}
		) {
			Param([string]$InputString)
			Test-UnicodeIsFileName $InputString -PosixPortable |Should -BeFalse -Because 'the pipeline should work'
			$InputString |Test-UnicodeIsFileName -PosixPortable |Should -BeFalse -Because 'the pipeline should work'
		}
		It "Should be true for valid string '<InputString>'" -TestCases @(
			Get-ChildItem -Recurse -File |ForEach-Object {@{ InputString = $_.Name }}
		) {
			Param([string]$InputString)
			Test-UnicodeIsFileName $InputString -PosixPortable |Should -BeTrue -Because 'the pipeline should work'
			$InputString |Test-UnicodeIsFileName -PosixPortable |Should -BeTrue -Because 'the pipeline should work'
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
