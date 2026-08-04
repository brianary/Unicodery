<#
.SYNOPSIS
Tests importing characters by name as constants into the current scope.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Import-CharConstants' -Tag Import-CharConstants,Import,CharConstants {
	Context 'Imports characters by name as constants into the current scope' {
		It "Should import various characters by name" {
			function Trace-NameCall
			{
				[CmdletBinding()] Param()
				Import-CharConstants NL :UP: HYPHEN-MINUS 'EN DASH' '&mdash;' '&copy;'
				$NL |Should -BeExactly ([Environment]::NewLine) -Because 'NL should be a platform-specific newline'
				$UP |Should -BeExactly '🆙'
				$HYPHEN_MINUS |Should -BeExactly '-'
				$EN_DASH |Should -BeExactly '–'
				$mdash |Should -BeExactly '—'
				$copy |Should -BeExactly '©'
			}
			Trace-NameCall
		}
		It "Should import various characters by alias" {
			function Trace-AliasCall
			{
				[CmdletBinding()] Param()
				Import-CharConstants -Alias @{ eol = 'NL' ; timer = 'timer clock'; redx = ':x:'; mm = 'square mm' } -Private
				$eol |Should -BeExactly ([Environment]::NewLine) -Because 'NL should be a platform-specific newline'
				$timer |Should -BeExactly '⏲'
				$redx |Should -BeExactly '❌'
				$mm |Should -BeExactly '㎜'
				function Trace-NestedCall
				{
					[CmdletBinding()] Param()
					Get-Variable eol -ErrorAction Ignore |Should -BeNullOrEmpty
				}
				#Trace-NestedCall
			}
			Trace-AliasCall
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
