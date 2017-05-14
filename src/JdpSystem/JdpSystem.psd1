@{
RootModule = 'JdpSystem'
ModuleVersion = '1.0'
GUID = '824016ad-d4c1-4590-8c01-7123a780be94'
Author = 'jdp'
CompanyName = 'JDP'
Copyright = '(c) 2017 JDP. All rights reserved.'
Description = 'Module managing JDP system directory.'
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
    'JdpSystem.Info.Format.ps1xml'
)
# NestedModules = @()
FunctionsToExport = '*'
CmdletsToExport = '*'
VariablesToExport = '*'
AliasesToExport = '*'
# ModuleList = @()
FileList = @(
    'JdpSystem.psd1',
	'JdpSystem.psm1',
	'JdpSystem.Info.Format.ps1xml'
)
PrivateData = @{

    PSData = @{
        Tags = @(
		    'powershell'
		)
        # LicenseUri = 'https://github.com/USER/REPOSITORY/blob/master/LICENSE.txt'
        ProjectUri = 'https://github.com/dpurge/jdp-psmodule'
        # IconUri = ''
        # ReleaseNotes = ''
    }
}
# HelpInfoURI = ''
# DefaultCommandPrefix = ''
}