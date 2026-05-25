<#
.SYNOPSIS
Tests conversion of a scope level to account for another call stack level.
#>

if((Test-Path .changes -Type Leaf) -and
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |
		Where-Object {$_.StartsWith("$(($MyInvocation.MyCommand.Name -split '\.',2)[0]).")})) {return}
Set-StrictMode -Version Latest
$module = Join-Path ($PSScriptRoot |Split-Path) src .publish *.psd1 |Get-Item
Import-Module $module -Force
InModuleScope ModernConveniences {
	Describe 'Add-ScopeLevel' -Tag Add-ScopeLevel,Add,ScopeLevel {
		Context 'Convert a scope level to account for another call stack level' {
			It 'Should calculate local scope (internal to module)' {
				Add-ScopeLevel Local -Internal |Should -BeExactly '1' -Because 'local is zero scope'
			}
			It 'Should calculate local scope (external to module)' {
				Add-ScopeLevel Local |Should -BeExactly '2' -Because 'local is zero scope'
			}
			It 'Should calculate a numeric scope (internal to module)' {
				1..8 |ForEach-Object {Add-ScopeLevel $_ -Internal |Should -BeExactly "$($_+1)"}
			}
			It 'Should calculate a numeric scope (external to module)' {
				1..8 |ForEach-Object {Add-ScopeLevel $_ |Should -BeExactly "$($_+2)"}
			}
			It 'Should calulate global scope (internal to module)' {
				Add-ScopeLevel Global -Internal |Should -BeExactly Global -Because 'global is the top scope'
			}
			It 'Should calulate global scope (external to module)' {
				Add-ScopeLevel Global |Should -BeExactly Global -Because 'global is the top scope'
			}
		}
	}
}
Remove-Module $module.BaseName -Force
