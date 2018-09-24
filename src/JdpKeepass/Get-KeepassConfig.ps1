function Get-KeepassConfig {
    <#
    .SYNOPSIS
    .DESCRIPTION
    .EXAMPLE
	    Remove-Module KeepassTools; Import-Module .\KeepassTools; Get-KeepassConfig
    .OUTPUTS
    .NOTES
        Author: JDP
    .LINK
    #>
	
	[OutputType('KeepassTools.KeepassConfig')]
	
	PARAM(
        [Parameter(Position=0)]
        [string]$Name = 'KeepassTools',
		
        [Parameter(Position=1)]
        [IO.DirectoryInfo]$Directory = (Split-Path -Path $Profile -Parent)
    )
	
	[IO.FileInfo] $ConfigFile = Join-Path -Path $Directory -ChildPath ("{0}.json" -F $Name)
	if (-not $ConfigFile.Exists) {
		throw "Keepass tools configuration file does not exist: {0}" -F $ConfigFile.FullName
	}
	
	$Config = Get-Content $ConfigFile -Raw | ConvertFrom-Json
	$Config.PSTypeNames.Insert(0, 'KeepassTools.KeepassConfig')
	
	return $Config
}