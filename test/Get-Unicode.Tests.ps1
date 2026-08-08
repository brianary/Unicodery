<#
.SYNOPSIS
Tests returning the (UTF-16) .NET string for a given Unicode codepoint, which may be a surrogate pair.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Get-Unicode' -Tag Get-Unicode,Get,Unicode {
	Context 'Returns the (UTF-16) .NET string for a given Unicode codepoint, which may be a surrogate pair.' {
		It "Given codepoint '<Codepoint>', returns '<Result>'" -TestCases @(
			@{ Codepoint = 0x1F5A7; Result = '🖧' }
			@{ Codepoint = 0x2F; Result = '/' }
			@{ Codepoint = 0x2023; Result = '‣' }
			@{ Codepoint = 0x2020; Result = '†' }
			@{ Codepoint = 0x2015; Result = '―' }
			@{ Codepoint = 0x2031; Result = '‱' }
		) {
			Param([int]$Codepoint, [string]$Result)
			Get-Unicode $Codepoint |Should -BeExactly $Result -Because 'the positional parameter should work'
			$Codepoint |Get-Unicode |Should -BeExactly $Result -Because 'the pipeline should work'
			$suffix = "$([char]0xFE0F)" # VS16
			Get-Unicode $Codepoint -AsEmoji |Should -BeExactly "$Result$suffix" -Because 'the positional parameter should work, as emoji'
			$Codepoint |Get-Unicode -AsEmoji |Should -BeExactly "$Result$suffix" -Because 'the pipeline should work, as emoji'
			$suffix = "$([char]0xFE0E)" # VS15
			Get-Unicode $Codepoint -AsText |Should -BeExactly "$Result$suffix" -Because 'the positional parameter should work, as text'
			$Codepoint |Get-Unicode -AsText |Should -BeExactly "$Result$suffix" -Because 'the pipeline should work, as text'
		}
	}

}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
