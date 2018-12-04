function Get-PackageInfo {

	[OutputType('JdpSystem.PackageInfo')]
	[CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string] $Name
    )

	# ---------- ---------- ---------- ---------- ----------
    $SystemInfo = Get-JdpSystemInfo

	$Info = New-Object PSCustomObject -Property @{
        Registry  = $script:PackageRegistryFile -Replace '{CONFIGURATION-DIRECTORY}',$SystemInfo.Directory.Data.FullName
		Name      = $Name
		Version   = $null
		Directory = @()
        File = @()
		Timestamp = $null
	}
	$Info.PSTypeNames.Insert(0, 'JdpSystem.PackageInfo')

	# ---------- ---------- ---------- ---------- ----------

    if (Test-Path $Info.Registry) {
        $Registry = Get-Content $Info.Registry -Raw | ConvertFrom-Json
        if ($Registry.PSobject.Properties.name -match $Name) {
            $Item = $Registry."${Name}"
            $Info.Version = $Item.Version
            $Info.Directory = $Item.Directory
            $Info.File = $Item.File
            $Info.Timestamp = $Item.Timestamp
        }
    }

    return $Info

}