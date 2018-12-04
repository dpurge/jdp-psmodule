function Set-PackageInfo {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string] $Name,

        [Parameter(Position=1, Mandatory=$true)]
        [string] $Version,

        [Parameter(Position=2, Mandatory=$false)]
        [string[]] $Directory = @(),

        [Parameter(Position=3, Mandatory=$false)]
        [string[]] $File = @()
    )

    $PackageInfo = Get-PackageInfo -Name $Name

    if ( -not (Test-Path $PackageInfo.Registry)) {
        if ($PSCmdlet.ShouldProcess($PackageInfo.Registry)) {
            Write-Host "Creating package registry: $($PackageInfo.Registry)"
            New-Item -Path $PackageInfo.Registry -ItemType File -Value '{}' -Force
        }
    }

    $Registry = Get-Content -Path $PackageInfo.Registry -Raw | ConvertFrom-Json
    $Properties = @{
        Version = $Version
		Directory = $Directory
		File = $File
		Timestamp = Get-Date -Format 'yyyy-MM-dd hh:mm:ss'
    }

    if ($PSCmdlet.ShouldProcess("${Name} ${Version}")) {
        if ($Registry.PSobject.Properties.name -match $Name) {
            $Registry."${Name}" = $Properties
        } else {
            Add-Member -InputObject $Registry -Name $Name -MemberType NoteProperty -Value $Properties
        }
        ConvertTo-Json -InputObject $Registry -Compress | Out-File $PackageInfo.Registry
    }

}