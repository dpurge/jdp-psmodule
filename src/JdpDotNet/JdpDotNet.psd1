@{
    RootModule = 'JdpDotNet'
    ModuleVersion = '1.0'
    GUID = '3d81c344-fb9a-4d21-a2be-130db5abc9c8'
    Description = 'This module contains functions allowing investigation of dotnet assemblies.'
    # RequiredModules = @()
    # RequiredAssemblies = @()
    # ScriptsToProcess = @()
    # TypesToProcess = @()
    # FormatsToProcess = @('Jdp.Example.Format.ps1xml')
    # NestedModules = @()
    # ModuleList = @()
    FileList = @(
        'JdpDotNet.psd1',
        'JdpDotNet.psm1'
    )
    PrivateData = @{

        PSData = @{
            Tags = @('PSModule')
            # LicenseUri = 'https://github.com/USER/REPOSITORY/blob/master/LICENSE.txt'
            ProjectUri = 'https://github.com/dpurge/jdp-psmodule'
            # IconUri = ''
            # ReleaseNotes = ''
        }
    }
    # HelpInfoURI = ''
    DefaultCommandPrefix = 'JDP'
}
