@{
RootModule = 'JdpKeepass'
ModuleVersion = '1.0'
GUID = '9fd63fe8-a55d-4b0e-b9f0-f1aee9a68a40'
Author = 'jdp'
CompanyName = 'JDP'
Copyright = '(c) 2017 JDP. All rights reserved.'
Description = 'Module for managing passwords in Keepass files.'
PowerShellVersion = '4.0'
# PowerShellHostName = ''
# PowerShellHostVersion = ''
DotNetFrameworkVersion = '4.0'
CLRVersion = '4.0'
# ProcessorArchitecture = 'None'
# RequiredModules = @()
# RequiredAssemblies = @()
# ScriptsToProcess = @()
# TypesToProcess = @()
FormatsToProcess = @(
    'JdpKeepass.Example.Format.ps1xml'
)
# NestedModules = @()
FunctionsToExport = '*'
CmdletsToExport = '*'
VariablesToExport = '*'
AliasesToExport = '*'
# ModuleList = @()
FileList = @(
    'JdpKeepass.psd1',
	'JdpKeepass.psm1',
	'JdpKeepass.Example.Format.ps1xml'
)
PrivateData = @{

    PSData = @{
        Tags = @(
		    'powershell'
		)
        # LicenseUri = 'https://github.com/USER/REPOSITORY/blob/master/LICENSE.txt'
        # ProjectUri = 'https://github.com/USER/REPOSITORY'
        # IconUri = ''
        # ReleaseNotes = ''
    }
}
# HelpInfoURI = ''
# DefaultCommandPrefix = ''
}