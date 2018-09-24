function Install-System {

	[OutputType('JdpSystem.Info')]
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string] $RootDirectory,

        [switch] $User
    )

    $Scope = if ($User) {'User'} else {'Machine'}

    Write-Host "`nInstall JDP system ==> creating environment variables in scope '${Scope}'..." -ForegroundColor Yellow

    # Everything else depends on the value of the Home variable...
    $Info = Get-JdpSystemInfo
    if (-not $Info.Variable.Home.Exists -or $Info.Variable.Home.Value -ne $RootDirectory) {
        if ($PSCmdlet.ShouldProcess($Info.Variable.Home.Name)) {
            Write-Host "$($Info.Variable.Home.Name) ==> ${RootDirectory}"
            [Environment]::SetEnvironmentVariable($Info.Variable.Home.Name, $RootDirectory, $Scope)
            $env:JdpSystem_Home = $RootDirectory
        }
        $Info.Refresh()
    }

    foreach ($item in $Info.Variable.Keys) {
        $var = $Info.Variable[$item]
        if (-not $var.Exists) {
            if ($PSCmdlet.ShouldProcess($var.Name)) {
                Write-Host "$($var.Name) ==> $($var.Value)"
                [Environment]::SetEnvironmentVariable($var.Name, $var.Value, $Scope)
            }
        }
    }

    Write-Host "`nInstall JDP system ==> creating directories..." -ForegroundColor Yellow

    foreach ($item in $Info.Directory.Keys) {
        $dir = $Info.Directory[$item]
        if (-not $dir.Exists) {
            if ($PSCmdlet.ShouldProcess($dir.FullName)) {
                Write-Host "${item} ==> $($dir.FullName)"
                New-Item -ItemType Directory -Force -Path $dir.FullName | Out-Null
            }
        }
    }

    Write-Host "`nInstall JDP system ==> setting PATH..." -ForegroundColor Yellow

    foreach ($item in $Info.Path.Keys) {
        $path = $Info.Path[$item]
        if (-not $path.Exists) {
            if ($PSCmdlet.ShouldProcess($path.Value)) {
                Write-Host "${item} ==> $($path.Value)"
                $NewPath = "$($path.Value);$([Environment]::GetEnvironmentVariable('Path', $Scope))"
                [Environment]::SetEnvironmentVariable('Path', $NewPath, $Scope)
                $env:Path = "$($path.Value);$($env:Path)"
            }
        }
    }

    $Info.Refresh()
    return $Info
}