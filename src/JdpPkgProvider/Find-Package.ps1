function Find-Package { 
    param(
        [string[]] $Name,
        [string] $RequiredVersion,
        [string] $MinimumVersion,
        [string] $MaximumVersion
    )

    #if (-not $Name) { $Name = Get-ChildItem $PackageLocation | ForEach-Object {$_.BaseName} }
    
    foreach($item in $Name) {
        if (Test-Path "${PackageLocation}\${item}") {

            # When Powershell 6 comes, replace System.Version with System.Management.Automation.SemanticVersion
            $Versions = Get-ChildItem -Path "${PackageLocation}\${item}" | ForEach-Object { [Version] $_.BaseName }

            foreach ($Version in $Versions) {

                $isMatching = $True

                if ($RequiredVersion) { $isMatching = $Version -eq $RequiredVersion }

                if ($MinimumVersion) { $isMatching = $Version -ge $MinimumVersion }

                if ($MaximumVersion) { $isMatching = $Version -le $MaximumVersion }

                if ($isMatching) {

                    $info = Import-PowerShellDataFile -Path "${PackageLocation}\${item}\${Version}\package.psd1"

                    $SWID = @{
                        Name                 = $info.Name
                        Version              = $info.Version
                        Summary              = $info.Description
                        VersionScheme        = "semver"
                        Source               = $ProviderName
                        SearchKey            = $item
                        FullPath             = "${PackageLocation}\${item}\${Version}\"
                    }

                    $SWID['FastPackageReference'] = $SWID | ConvertTo-JSON -Compress

                    New-SoftwareIdentity @SWID
                }
            }
        }
    }
}