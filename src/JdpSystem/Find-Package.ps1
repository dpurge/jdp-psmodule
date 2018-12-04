function Find-Package {

	[CmdletBinding()]
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

    PackageManagement\Find-Package @PSBoundParameters -ProviderName JdpSystem
}