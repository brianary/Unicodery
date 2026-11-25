<#
.SYNOPSIS
Tests Returns the Windows password category of characters.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Get-UnicodePasswordCategory' -Tag Get-UnicodePasswordCategory,Get,UnicodePasswordCategory,PasswordCategory {
	Context 'Provides the category for a character.' {
		It "Returns '<Result>' for '<InputCharacter>'" -TestCases @(
			@{ InputCharacter = 'A'; Result = 'Uppercase' }
			@{ InputCharacter = 'Z'; Result = 'Uppercase' }
			@{ InputCharacter = 'Ⲷ'; Result = 'Uppercase' }
			@{ InputCharacter = 'ℋ'; Result = 'Uppercase' }
			@{ InputCharacter = 'Ⰰ'; Result = 'Uppercase' }
			@{ InputCharacter = '0'; Result = 'Digit' }
			@{ InputCharacter = '³'; Result = 'Digit' }
			@{ InputCharacter = 'a'; Result = 'Lowercase' }
			@{ InputCharacter = 'z'; Result = 'Lowercase' }
			@{ InputCharacter = 'ⲿ'; Result = 'Lowercase' }
			@{ InputCharacter = 'ƻ'; Result = 'Caseless' }
			@{ InputCharacter = 'ↂ'; Result = 'Caseless' }
			@{ InputCharacter = '%'; Result = 'Special' }
			@{ InputCharacter = '$'; Result = 'Special' }
			@{ InputCharacter = ' '; Result = 'Special' }
			@{ InputCharacter = '*'; Result = 'Special' }
			@{ InputCharacter = '_'; Result = 'Special' }
		) {
			Param([char]$InputCharacter,[string]$Result)
			Get-UnicodePasswordCategory $InputCharacter |Should -BeExactly $Result -Because 'parameter should work'
			$InputCharacter |Get-UnicodePasswordCategory |Should -BeExactly $Result -Because 'pipline should work'
		}
	}
	Context 'Provides the category for each character in the string.' {
		It "Returns '<Result>' for '<InputString>'" -TestCases @(
			@{ InputString = 'P@ss'; Result = @('Uppercase','Special','Lowercase','Lowercase') }
		) {
			Param([string]$InputString,[string[]]$Result)
			Get-UnicodePasswordCategory -InputString $InputString |Should -BeExactly $Result -Because 'parameter should work'
			$InputString |Get-UnicodePasswordCategory |Should -BeExactly $Result -Because 'pipline should work'
		}
	}
	Context 'Provides the category for a rune.' {
		It "Returns false for '<InputRune>'" -TestCases @(
			@{ InputRune = [char]'A'; Result = 'Uppercase' }
			@{ InputRune = [char]'Z'; Result = 'Uppercase' }
			@{ InputRune = [char]'Ⲷ'; Result = 'Uppercase' }
			@{ InputRune = [char]'ℋ'; Result = 'Uppercase' }
			@{ InputRune = [char]'Ⰰ'; Result = 'Uppercase' }
			@{ InputRune = [char]'0'; Result = 'Digit' }
			@{ InputRune = [char]'³'; Result = 'Digit' }
			@{ InputRune = [char]'a'; Result = 'Lowercase' }
			@{ InputRune = [char]'z'; Result = 'Lowercase' }
			@{ InputRune = [char]'ⲿ'; Result = 'Lowercase' }
			@{ InputRune = [char]'ƻ'; Result = 'Caseless' }
			@{ InputRune = [char]'ↂ'; Result = 'Caseless' }
			@{ InputRune = [char]'%'; Result = 'Special' }
			@{ InputRune = [char]'$'; Result = 'Special' }
			@{ InputRune = [char]' '; Result = 'Special' }
			@{ InputRune = [char]'*'; Result = 'Special' }
			@{ InputRune = [char]'_'; Result = 'Special' }
			@{ InputRune = [text.rune]0x1F9E9; Result = 'None' }
			@{ InputRune = [text.rune]0x1F600; Result = 'None' }
		) {
			Param([text.rune]$InputRune)
			Get-UnicodePasswordCategory -InputRune $InputRune |Should -BeExactly $Result -Because 'parameter should work'
			$InputRune |Get-UnicodePasswordCategory |Should -BeExactly $Result -Because 'pipline should work'
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
