function Get-Config {
	
	[OutputType('JdpKeepass.Config')]
	param (
        [Parameter(Position=0)]
        [string] $Name = 'JdpKeepass',
		
        [Parameter(Position=1)]
        [IO.DirectoryInfo] $Directory = (Split-Path -Path $Profile -Parent)
    )
	
	[IO.FileInfo] $ConfigFile = Join-Path -Path $Directory -ChildPath ("{0}.json" -F $Name)
	if (-not $ConfigFile.Exists) {
		throw "JDP Keepass configuration file does not exist: {0}" -F $ConfigFile.FullName
	}
	
	$Config = Get-Content $ConfigFile -Raw | ConvertFrom-Json
	$Config.PSTypeNames.Insert(0, 'JdpKeepass.Config')
	
	return $Config
}