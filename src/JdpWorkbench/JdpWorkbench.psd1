@{
    RootModule = 'JdpWorkbench'
    ModuleVersion = '1.0'
    GUID = '5048923a-2c4d-4d5f-9b50-cdc1be49ef5d'
    Description = 'Workbench GUI for common tasks done interactively.'
    # RequiredModules = @()
    # RequiredAssemblies = @()
    # ScriptsToProcess = @()
    # TypesToProcess = @()
    # FormatsToProcess = @('Jdp.Example.Format.ps1xml')
    # NestedModules = @()
    # ModuleList = @()
    FileList = @(
        'JdpWorkbench.psd1',
        'JdpWorkbench.psm1'
    )
    PrivateData = @{

        PSData = @{
            Tags = @('PSModule')
            # LicenseUri = 'https://github.com/USER/REPOSITORY/blob/master/LICENSE.txt'
            # ProjectUri = 'https://github.com/USER/REPOSITORY'
            # IconUri = ''
            # ReleaseNotes = ''
        }
    }
    # HelpInfoURI = ''
    DefaultCommandPrefix = 'JDP'
}
