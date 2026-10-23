<#
.SYNOPSIS
Tests Search Unicode code point names.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Find-UnicodeByName' -Tag Find-UnicodeByName,Find,UnicodeByName {
	Context 'Search Unicode code point names' {
		It "Find some characters starting with PAREN" {
			$left, $right, $null = Find-UnicodeByName PAREN
			$left.Character |Should -BeExactly '('
			$left.Codepoint |Should -BeExactly '0028'
			$left.Name |Should -BeExactly 'LEFT PARENTHESIS'
			$right.Character |Should -BeExactly ')'
			$right.Codepoint |Should -BeExactly '0029'
			$right.Name |Should -BeExactly 'RIGHT PARENTHESIS'
		}
	}

}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
