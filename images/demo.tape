# VHS https://github.com/charmbracelet/vhs
Output demo.gif
Hide
Set Shell pwsh
Type "Import-Module ../src/.publish/Unicodery.psd1"
Enter
Type "Clear-Host"
Enter
Show
Type "Get-UnicodeByName CAT"
Enter
Sleep 1s
Type "Get-UnicodeByName :star:"
Enter
Sleep 1s
Type "Get-UnicodeByName '&hellip;'"
Enter
Sleep 1s
Type "Get-UnicodeName ~"
Enter
Sleep 1s
Type "Get-UnicodeName 0x2615"
Enter
Sleep 1s
Type "Get-Unicode 0x1F6DE |Format-Hex"
Enter
Sleep 1s
Type "Get-CharacterDetails -CodePoint 0x2620 |Select-Object Is* |Format-List"
Enter
Sleep 2s
Type "Get-CharacterDetails -CodePoint 0x2620 |Select-Object -ExcludeProperty Is* |Format-List"
Enter
Sleep 5s
