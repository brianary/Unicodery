<#
.SYNOPSIS
Tests True if the input is valid in a Windows path.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
[char[]] $posixPortable = @('A'..'Z')+@('a'..'z')+[char[]]'0123456798._-'
[char[]] $invalidChars = @(0..0x1F)+[char[]]",;:?`"[]*/\+<=>|`u{7F}"
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Test-UnicodeIsUserName' -Tag Test-UnicodeIsUserName,Test,UnicodeIsUserName {
	Context 'True if the input is valid in a filename' {
		It "Should be false for invalid character '<InputCharacter>'" -TestCases @(
	        $invalidChars |
				ForEach-Object {@{ InputCharacter = [char]$_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsUserName $InputCharacter |Should -BeFalse -Because 'the parameter should work'
			$InputCharacter |Test-UnicodeIsUserName |Should -BeFalse -Because 'the pipeline should work'
		}
		It "Should be true for valid character '<InputCharacter>'" -TestCases @(
			([char]::MinValue)..([char]0xFF) |
	        	Where-Object {$invalidChars -notcontains $_} |
				ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsUserName $InputCharacter |Should -BeTrue -Because 'the parameter should work'
			$InputCharacter |Test-UnicodeIsUserName |Should -BeTrue -Because 'the pipeline should work'
		}
		It "Should be false for invalid string '<InputString>'" -TestCases @(
			@{ InputString = 'A/B/C' }
			@{ InputString = '*\|/*' }
			@{ InputString = '<INPUT>' }
		) {
			Param([string]$InputString)
			Test-UnicodeIsUserName $InputString |Should -BeFalse -Because 'the pipeline should work'
			$InputString |Test-UnicodeIsUserName |Should -BeFalse -Because 'the pipeline should work'
		}
		It "Should be true for valid string '<InputString>'" -TestCases @(
			@{ InputString = 'username' }
		) {
			Param([string]$InputString)
			Test-UnicodeIsUserName $InputString |Should -BeTrue -Because 'the pipeline should work'
			$InputString |Test-UnicodeIsUserName |Should -BeTrue -Because 'the pipeline should work'
		}
	}
	Context 'True if the input is valid in a POSIX portable filename' {
		It "Should be false for invalid character '<InputCharacter>'" -TestCases @(
			([char]::MinValue)..([char]0xFF) |
	        	Where-Object {$posixPortable -notcontains $_} |
				ForEach-Object {@{ InputCharacter = $_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsUserName $InputCharacter -PosixPortable |Should -BeFalse -Because 'the parameter should work'
			$InputCharacter |Test-UnicodeIsUserName -PosixPortable |Should -BeFalse -Because 'the pipeline should work'
		}
		It "Should be true for valid character '<InputCharacter>'" -TestCases @(
	        $posixPortable |
				ForEach-Object {@{ InputCharacter = [char]$_ }}
		) {
			Param([char]$InputCharacter)
			Test-UnicodeIsUserName $InputCharacter -PosixPortable |Should -BeTrue -Because 'the parameter should work'
			$InputCharacter |Test-UnicodeIsUserName -PosixPortable |Should -BeTrue -Because 'the pipeline should work'
		}
		It "Should be false for invalid string '<InputString>'" -TestCases @(
			@('A/B/C','-rf','one two','.','..','NONE') |ForEach-Object {@{ InputString = $_ }}
		) {
			Param([string]$InputString)
			Test-UnicodeIsUserName $InputString -PosixPortable |Should -BeFalse -Because 'the pipeline should work'
			$InputString |Test-UnicodeIsUserName -PosixPortable |Should -BeFalse -Because 'the pipeline should work'
		}
		It "Should be true for valid string '<InputString>'" -TestCases @(
			@{ InputString = 'username' }
		) {
			Param([string]$InputString)
			Test-UnicodeIsUserName $InputString -PosixPortable |Should -BeTrue -Because 'the pipeline should work'
			$InputString |Test-UnicodeIsUserName -PosixPortable |Should -BeTrue -Because 'the pipeline should work'
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
