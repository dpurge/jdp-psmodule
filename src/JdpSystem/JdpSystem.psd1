@{
    RootModule = 'JdpSystem'
    ModuleVersion = '1.0'
    GUID = '824016ad-d4c1-4590-8c01-7123a780be94'
    Description = 'Module managing JDP system directory.'
    # RequiredModules = @()
    # RequiredAssemblies = @()
    # ScriptsToProcess = @()
    # TypesToProcess = @()
    FormatsToProcess = @(
        'JdpSystem.Info.Format.ps1xml'
    )
    #NestedModules = @()
    #ModuleList = @()
    FileList = @(
        'JdpSystem.psd1',
        'JdpSystem.psm1',
        'JdpSystem.Info.Format.ps1xml'
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
