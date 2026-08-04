<#
.SYNOPSIS
Tests Returns the (UTF-16) .NET string for a given Unicode codepoint, which may be a surrogate pair.
#>

return #TODO: Write test.
if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Get-Unicode' -Tag Get-Unicode,Get,Unicode {
	Context 'Returns the (UTF-16) .NET string for a given Unicode codepoint, which may be a surrogate pair.' -Tag Example {
		It "EXAMPLE 1" -Skip {
			"$(Get-Unicode 0x1F5A7) Network" |Should -BeExactly @"
<three networked computers> Network
"@
		}
	}

}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
