<#
.SYNOPSIS
Updates the UnicodeByName data files.
#>

[CmdletBinding()] Param()
Begin
{
	function Save-UnicodeData
	{
		[CmdletBinding()][OutputType([datetime])] Param()
		Write-Verbose "Saving Unicode database to '$(Get-CachePath UnicodeByName.txt)'"
		$UnicodeData = Update-CacheItem https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt UnicodeData.txt
		return (Get-Item $UnicodeData).LastWriteTime
	}

	function Save-UnicodeName
	{
		[CmdletBinding()] Param(
		[Parameter(Position=0,Mandatory=$true)][string] $UnicodeName
		)
		Write-Verbose "Saving Unicode code-to-names lookup to '$UnicodeName'"
		$controlNames = Get-Content (Join-Path $PSScriptRoot UnicodeName.cc.txt) |ConvertFrom-StringData
		Get-UnicodeData |
			ForEach-Object {
				$_.Name -eq '<control>' ?
					($_.Value,$controlNames[$_.Value] -join '=') :
					($_.Value,$_.Name -join '=')
			} |Out-File $UnicodeName -Encoding utf8
	}

	function Save-UnicodeByName
	{
		[CmdletBinding()] Param(
		[Parameter(Position=0,Mandatory=$true)][string] $UnicodeByName
		)
		Write-Verbose "Saving Unicode name-to-codes lookup to '$UnicodeByName'"
		$conflictingOldNames = '0007','01B7','0292','0404','0406','0454','0456','10D0','10D1','10D2','10D3','10D4',
			'10D5','10D6','10D7','10D8','10D9','10DA','10DB','10DC','10DD','10DE','10DF','10E0','10E1','10E2','10E3',
			'10E4','10E5','10E6','10E7','10E8','10E9','10EA','10EB','10EC','10ED','10EE','10EF','10F0','10F1','10F2',
			'10F3','10F4','10F5','2016','314A','314B','314D','3209','320A','320C','3269','326A','326C','33B7','FFBA',
			'FFBB','FFBD'
		Copy-Item -Path (Join-Path $PSScriptRoot UnicodeByName.cc.txt) -Destination $UnicodeByName
		"# https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt" |Out-File $UnicodeByName -Append
		Get-UnicodeData |
			ForEach-Object {
				if($_.OldName -and $_.Value -notin $conflictingOldNames){$_.OldName+'='+$_.Value}
				if($_.Name -ne '<control>'){$_.Name+'='+$_.Value}
			} |Out-File $UnicodeByName -Append
	}

	function Save-UnicodeByNameGitHub
	{
		[CmdletBinding()] Param()
		$GitHubEmojis = Update-CacheItem https://api.github.com/emojis GitHub-emojis.json
		$UnicodeByNameGitHub = Get-CachePath UnicodeByName.github.txt
		if(!(Test-Path $UnicodeByNameGitHub -Type Leaf) -or
			(Get-Item $GitHubEmojis).LastWriteTime -gt (Get-Item $UnicodeByNameGitHub).LastWriteTime)
		{
			(Get-Content $GitHubEmojis -Raw |ConvertFrom-Json).PSObject.Properties |
				Where-Object {$_.Value -notlike "*/$($_.Name).png[?]v8"} |
				ForEach-Object {':'+$_.Name+':='+(((([uri]$_.Value).Segments[-1]) -replace '\.png\z').ToUpper() -replace '-',',')} |
				Out-File $UnicodeByNameGitHub -Encoding utf8
			Write-Verbose 'GitHub emoji cache was updated.'
		}
	}

	function Save-UnicodeCache
	{
		[CmdletBinding()] Param()
		$LastCache = Get-CachePath LastCache
		if(!(Test-Path $LastCache -Type Leaf))
		{
			New-Item $LastCache -Type File |Out-Null
			(Get-Item $LastCache).LastWriteTime = (Get-Date).AddYears(-1)
		}
		if((Get-Date).AddDays(-1) -lt (Get-Item $LastCache).LastWriteTime) {return}
		$UnicodeDataLastMod = Save-UnicodeData

		$UnicodeName = Get-CachePath UnicodeName.txt
		if(!(Test-Path $UnicodeName -Type Leaf) -or
			(Get-Item $UnicodeName).LastWriteTime -lt $UnicodeDataLastMod)
		{
			Save-UnicodeName $UnicodeName
		}

		$UnicodeByName = Get-CachePath UnicodeByName.txt
		if(!(Test-Path $UnicodeByName -Type Leaf) -or
			(Get-Item $UnicodeByName).LastWriteTime -lt $UnicodeDataLastMod)
		{
			Save-UnicodeByName $UnicodeByName
		}

		$UnicodeByNameHtml = Update-CacheItem https://html.spec.whatwg.org/entities.json UnicodeByName.html.json
		Write-Verbose "Saved HTML entity name lookup to '$UnicodeByNameHtml'"

		Save-UnicodeByNameGitHub

		New-Item $LastCache -Type File -Force |Out-Null
	}
}
Process
{
	Save-UnicodeCache
}
