<#
.SYNOPSIS
Convert a scope level to account for another call stack level.

.DESCRIPTION
For scripts that need to get or set a variable of a specific scope so that it disappears at
the end of a block/function/script, or so that it persists globally, this calculates the
additional call level added by that script.

.INPUTS
System.String containing the desired level.

.OUTPUTS
System.String containing the calculated level (Global or an integer).

.LINK
Stop-ThrowError

.LINK
Get-PSCallStack

.LINK
about_Scopes

.FUNCTIONALITY
PowerShell

.EXAMPLE
Add-ScopeLevel Local

1

.EXAMPLE
Add-ScopeLevel 3

4

.EXAMPLE
Add-ScopeLevel Global

Global
#>

[CmdletBinding()][OutputType([string])] Param(
# The requested scope from the caller of the caller of this script.
# Global, Local, Private, Script, or a positive integer.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $Scope,
# The scope will be used within the module, rather than the module's caller.
[switch] $Internal
)
Process
{
	$offset = $Internal ? 1 : 2
	if($Scope -match '\A\d+\z') {return "$($offset+[int]$Scope)"}
	switch($Scope)
	{
		Global  {return 'Global'}
		# the module scope seems to implicitly add a level
		Local   {return "$offset"}
		Private {return "$offset"}
		Script
		{
			$stack = Get-PSCallStack
			for($i = $offset+1; $i -lt $stack.Length; $i++)
			{
				if($stack[$i].Command -and $stack[$i].FunctionName -like '<ScriptBlock>*') {return "$($offset+$i-2)"}
			}
			Stop-ThrowError 'Unable to find Script scope' -Argument Scope
		}
	}
}
