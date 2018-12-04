function Install-Package {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string] $Name,

        [Parameter(Mandatory=$false)]
        [version] $RequiredVersion,

        [Parameter(Mandatory=$false)]
        [version] $MinimumVersion,

        [Parameter(Mandatory=$false)]
        [version] $MaximumVersion
    )

    $PackageInfo = Get-PackageInfo -Name $Name

    if ($PackageInfo.Version) {
        if ($Version -eq $PackageInfo.Version) {
            Write-Warning "Package ${Name} version ${Version} is already installed."
        } else {
            Write-Warning "Package $($PackageInfo.Name) version $($PackageInfo.Version) has to be uninstalled before installing version ${Version}."
        }
        return
    }

    if ($PSCmdlet.ShouldProcess("Installing package: ${Name}")) {
        PackageManagement\Install-Package @PSBoundParameters -ProviderName JdpSystem
    }

    Set-PackageInfo -Name $Name -Version $Version -Directory @() -File @()
}