@{
    RootModule = 'JdpKeepass'
    ModuleVersion = '1.0'
    GUID = 'f02efd3a-dcbe-4b89-8355-69c57e1958bb'
    Description = 'Manage credentials in the KeePass file.'
    # RequiredModules = @()
    # RequiredAssemblies = @()
    # ScriptsToProcess = @()
    # TypesToProcess = @()
    # FormatsToProcess = @('Jdp.Example.Format.ps1xml')
    # NestedModules = @()
    # ModuleList = @()
    FileList = @(
        'JdpKeepass.psd1',
        'JdpKeepass.psm1'
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
    DefaultCommandPrefix = 'JdpKeepass'
}
