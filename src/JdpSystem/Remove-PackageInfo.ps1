function Remove-PackageInfo {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string] $Name
    )

    $PackageInfo = Get-PackageInfo -Name $Name

    if (Test-Path $PackageInfo.Registry) {
        $Registry = Get-Content -Path $PackageInfo.Registry -Raw | ConvertFrom-Json
        if ($Registry.PSobject.Properties.name -match $Name) {
            if ($PSCmdlet.ShouldProcess("Removing package info: ${Name}")) {
                $Registry.PSObject.Properties.Remove($Name)
                ConvertTo-Json -InputObject $Registry -Compress | Out-File $PackageInfo.Registry
            }
        }
    }
}