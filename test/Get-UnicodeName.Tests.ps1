<#
.SYNOPSIS
Tests Returns the name of a Unicode code point.
#>

return #TODO: Write test.
if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Get-UnicodeName' -Tag Get-UnicodeName,Get,UnicodeName {
	Context 'Returns the name of a Unicode code point.' -Tag Example {
		It "EXAMPLE 1" -Skip {
			Get-UnicodeName 32 |Should -BeExactly @"
SPACE
"@
		}
	}
	Context 'CodePoint' -Tag CodePoint {
		It "test" -Skip {
			1 |Should -Be 1
		}
	}
	Context 'Character' -Tag Character {
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
