<#
.SYNOPSIS
Tests Returns characters based on Unicode code point name, GitHub short code, or HTML entity.
#>

return #TODO: Write test.
if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Get-UnicodeByName' -Tag Get-UnicodeByName,Get,UnicodeByName {
	Context 'Returns characters based on Unicode code point name, GitHub short code, or HTML entity.' -Tag Example {
		It "EXAMPLE 1" -Skip {
			Get-UnicodeByName hyphen-minus |Should -BeExactly @"
-
"@
		}
		It "EXAMPLE 2" -Skip {
			Get-UnicodeByName slash |Should -BeExactly @"
/
"@
		}
		It "EXAMPLE 3" -Skip {
			Get-UnicodeByName :zero: |Should -BeExactly @"
[0]
"@
		}
		It "EXAMPLE 4" -Skip {
			Get-UnicodeByName '&amp;' |Should -BeExactly @"
&
"@
		}
		It "EXAMPLE 5" -Skip {
			Get-UnicodeByName BEL |Should -BeExactly @"
(beeps)
"@
		}
	}
	Context 'Name' -Tag Name {
		It "test" -Skip {
			1 |Should -Be 1
		}
	}
	Context 'Update' -Tag Update {
		It "test" -Skip {
			1 |Should -Be 1
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
