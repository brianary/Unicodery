# see https://docs.microsoft.com/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest
# and https://docs.microsoft.com/powershell/module/microsoft.powershell.core/new-modulemanifest
@{
RootModule = 'Unicodery.psm1'
ModuleVersion = '0.0.0.0' # placeholder to be overridden
CompatiblePSEditions = @('Core')
GUID = '623460be-e45c-473a-967b-47a7c05e12a7'
Author = 'Brian Lalonde'
CompanyName = 'Unknown'
Copyright = 'Copyright © 2026 Brian Lalonde'
Description = ' Commands to send structured log events to a Seq server.'
PowerShellVersion = '7.0'
# RequiredModules = ,'Microsoft.PowerShell.Utility'
FunctionsToExport = @('*') # '*'
CmdletsToExport = @() # '*'
VariablesToExport = @() # '*'
# AliasesToExport = @()
FileList = @('Unicodery.psd1','Unicodery.psm1')
PrivateData = @{
	PSData = @{
		Tags = @('Unicode', 'Character')
		LicenseUri = 'https://github.com/brianary/Unicodery/blob/master/LICENSE'
		ProjectUri = 'https://github.com/brianary/Unicodery/'
		IconUri = 'http://webcoder.info/images/Unicodery.svg'
		# ReleaseNotes = ''
		# PS7: A list of external modules that this module is dependent upon.
		# ExternalModuleDependencies = ,'Microsoft.PowerShell.Utility'
	}
}
}
