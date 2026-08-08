<#
.SYNOPSIS
Tests returning characters based on Unicode code point name, GitHub short code, or HTML entity.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Get-UnicodeByName' -Tag Get-UnicodeByName,Get,UnicodeByName {
	Context 'Returns characters based on Unicode code point name, GitHub short code, or HTML entity.' {
		It "Given the name '<Name>', returns '<Result>'" -TestCases @(
			@{ Name = 'hyphen-minus'; Result = '-' }
			@{ Name = 'slash'; Result = '/' }
			@{ Name = ':zero:'; Result = '0️⃣' }
			@{ Name = '&amp;'; Result = '&' }
			@{ Name = 'HT'; Result = "`t" }
			@{ Name = 'FLOWER PUNCTUATION MARK'; Result = '⁕' }
			@{ Name = 'waning_gibbous_moon_symbol'; Result = '🌖' }
		) {
			Param([string]$Name, [string]$Result)
			Get-UnicodeByName $Name |Should -BeExactly $Result -Because 'the positional parameter should work'
			$Name |Get-UnicodeByName |Should -BeExactly $Result -Because 'the pipeline should work'
			$suffix = "$([char]0xFE0F)" # VS16
			Get-UnicodeByName $Name -AsEmoji |Should -BeExactly "$Result$suffix" -Because 'the positional parameter should work, as emoji'
			$Name |Get-UnicodeByName -AsEmoji |Should -BeExactly "$Result$suffix" -Because 'the pipeline should work, as emoji'
			$suffix = "$([char]0xFE0E)" # VS15
			Get-UnicodeByName $Name -AsText |Should -BeExactly "$Result$suffix" -Because 'the positional parameter should work, as text'
			$Name |Get-UnicodeByName -AsText |Should -BeExactly "$Result$suffix" -Because 'the pipeline should work, as text'
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
