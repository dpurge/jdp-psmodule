Function Import-Configuration {
    [CmdletBinding()]
    Param(
	    [string] $ConfigurationFile = "JdpBookbind.psd1",
        [string[]] $ConfigurationPath = @(
            $pwd
            (Split-Path $Profile)
        )
	)

    $config = $null

    foreach ($ConfigDir in $ConfigurationPath) {
        $ConfigFile = Join-Path -Path $ConfigDir -ChildPath $ConfigurationFile
        if (Test-Path $ConfigFile -PathType Leaf) {
            Write-Host "Using configuration file: ${ConfigFile}"
            $config = Import-PowerShellDataFile $ConfigFile
            break
        }
    }

    if (-not $config) {
       $config = Import-PowerShellDataFile $PSScriptRoot\Configuration.psd1
    }

    return $config
}