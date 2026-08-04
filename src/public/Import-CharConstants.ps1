<#
.SYNOPSIS
Imports characters by name as constants into the current scope.

.INPUTS
System.String containing a character name.

.FUNCTIONALITY
Unicode

.LINK
Get-UnicodeByName

.EXAMPLE
Import-CharConstants NL :UP: HYPHEN-MINUS 'EN DASH' '&mdash;' '&copy;'

Creates constants in the context of the current script for the named characters.
#>

[CmdletBinding()] Param(
# The control code abbreviation, Unicode name, HTML entity, or GitHub name of the character to create a constant for.
# "NL" will use the newline appropriate to the environment.
[Parameter(ParameterSetName='UseNames',Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromRemainingArguments=$true)][string[]] $CharacterName,
# A dictionary that maps character variable name aliases to control code abbreviations, Unicode names, HTML entities,
# or GitHub names of characters.
[Parameter(ParameterSetName='UseAliases',Mandatory=$true)][hashtable] $Alias,
# Specifies to create the variables within the global scope.
[switch] $Global,
# Indicates that created variables should be hidden from child scopes.
[switch] $Private,
<#
Appends a U+FE0F VARIATION SELECTOR-16 suffix to the character, which suggests an emoji presentation
for characters that support both a simple text presentation as well as a color emoji-style one.
#>
[switch] $AsEmoji,
# The SessionState object to use to import the variables.
[Management.Automation.SessionState] $SessionState =
	$ExecutionContext.SessionState.Module.GetVariableFromCallersModule('PSCmdlet')?.Value?.SessionState
)
Process
{
    filter New-CharacterVariable
    {
        [CmdletBinding()][OutputType([psvariable])] Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)][Alias('Key')][string] $Alias,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)][Alias('Value')][string] $CharacterName,
		[switch] $SimplifyName
        )
		$name = $SimplifyName ? $Alias.Trim(@('&',':',';')).Replace([char]' ',[char]'_').Replace([char]'-',[char]'_') : $Alias
        $char = $CharacterName -eq 'NL' ? [Environment]::NewLine : (Get-UnicodeByName -Name $CharacterName -AsEmoji:$AsEmoji)
		if($Global)
		{
			$existing = Get-Variable -Name $name -Scope Global -ErrorAction Ignore
			if($existing -and ($existing.Options -eq 'Constant') -and ($existing.Value -eq $char)) {return}
		}
		else
		{
			$existing = $SessionState.PSVariable.Get($name)
			if($existing -and ($existing.Options -eq 'Constant') -and ($existing.Value -eq $char)) {return}
		}
		return New-Object psvariable $name,$char,'Constant'
    }

	if(!$SessionState) {Write-Warning 'SessionState not found. Unable to import character constants.'; return}
	$globalopts = $Private ? @{Scope='Global';Option='Constant';Visibility='Private'} : @{Scope='Global';Option='Constant'}
	switch($PSCmdlet.ParameterSetName)
	{
		UseNames
		{
			foreach($var in $CharacterName |New-CharacterVariable -SimplifyName)
			{
				if($Global) {Set-Variable -Name $var.Name -Value $var.Value @globalopts}
				else {$SessionState.PSVariable.Set($var)}
			}
		}
		UseAliases
		{
			foreach($var in $Alias.GetEnumerator() |New-CharacterVariable)
			{
				if($Global) {Set-Variable -Name $var.Name -Value $var.Value @globalopts}
				else {$SessionState.PSVariable.Set($var)}
			}
		}
	}
}
