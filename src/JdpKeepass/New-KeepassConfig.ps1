function New-KeepassConfig {
    <#
    .SYNOPSIS
    .DESCRIPTION
    .EXAMPLE
	    Remove-Module KeepassTools; Import-Module .\KeepassTools; New-KeepassConfig
    .OUTPUTS
    .NOTES
        Author: JDP
    .LINK
    #>
	
	[OutputType('IO.FileInfo')]
	
	PARAM(
        [Parameter(Position=0)]
        [string]$Name = 'KeepassTools',
		
        [Parameter(Position=1)]
        [IO.DirectoryInfo]$Directory = (Split-Path -Path $Profile -Parent)
    )
	
	[IO.FileInfo] $ConfigFile = Join-Path -Path $Directory -ChildPath ("{0}.json" -F $Name)
	if ($ConfigFile.Exists) {
		throw "File already exists: {0}" -F $ConfigFile.FullName
	}
	
	@{
	    "keepass-home" = (Join-Path -Path $Env:ProgramFiles -ChildPath "Keepass");
		"vault" = @{
		    "default" = @{
		        "file"= (Join-Path -Path $Directory.FullName -ChildPath "KeepassTools.kdbx");
			};
		};
	} | ConvertTo-Json -depth 999 | Out-File $ConfigFile
	
	$ConfigFile.Refresh()
	return $ConfigFile
}