function Uninstall-Package {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string] $Name
    )

    $PackageInfo = Get-PackageInfo -Name $Name

    throw "NOT IMPLEMENTED!"
}