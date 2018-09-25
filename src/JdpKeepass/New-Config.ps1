function New-Config {
	
	[OutputType('IO.FileInfo')]
	param (
        [Parameter(Position=0)]
        [string]$Name = 'JdpKeepass',
		
        [Parameter(Position=1)]
        [IO.DirectoryInfo]$Directory = (Split-Path -Path $Profile -Parent)
    )
	
	[IO.FileInfo] $ConfigFile = Join-Path -Path $Directory -ChildPath ("{0}.json" -F $Name)
	if ($ConfigFile.Exists) {
		throw "File already exists: {0}" -F $ConfigFile.FullName
	}
	
	@{
		vault = @{
		    default = @{
		        file = (Join-Path -Path $Directory.FullName -ChildPath "JdpKeepass.kdbx")
			}
		}
	} | ConvertTo-Json -depth 100 | Out-File $ConfigFile
	
	$ConfigFile.Refresh()
	return $ConfigFile
}