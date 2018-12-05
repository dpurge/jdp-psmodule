function Find-Package { 
    param(
        [string[]] $Name,
        [string] $RequiredVersion,
        [string] $MinimumVersion,
        [string] $MaximumVersion
    )

    foreach($item in (Get-ChildItem -Path $PackageLocation -Include 'package.psd1' -Recurse)) {
        $info = Import-PowerShellDataFile -Path $item.FullName
        [version] $Version = $info.Version
        $isMatching = if ($Name) { $Name -contains $info.Name } else {$True}

        if ($RequiredVersion) { $isMatching = $isMatching -and $Version -eq $RequiredVersion }

        if ($MinimumVersion) { $isMatching = $isMatching -and $Version -ge $MinimumVersion }

        if ($MaximumVersion) { $isMatching = $isMatching -and $Version -le $MaximumVersion }

        if ($isMatching) {

            $SWID = @{
                Name                 = $info.Name
                Version              = $info.Version
                Summary              = $info.Description
                VersionScheme        = "semver"
                Source               = $ProviderName
                SearchKey            = $info.Name
                FullPath             = $item.FullName
            }

            $SWID['FastPackageReference'] = $SWID | ConvertTo-JSON -Compress

            New-SoftwareIdentity @SWID
        }
    }
}