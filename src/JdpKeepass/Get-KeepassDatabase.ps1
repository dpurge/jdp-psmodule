function Get-KeepassDatabase {
    <#
    .SYNOPSIS
    .DESCRIPTION
    .EXAMPLE
	    Remove-Module KeepassTools; Import-Module .\KeepassTools; $x = Get-KeepassDatabase 
    .OUTPUTS
    .NOTES
        Author: JDP
    .LINK
    #>
	
	[OutputType('KeepassTools.VaultInfo')]
	
	PARAM(
        [Parameter(Position=0)]
        [string]$Vault = 'default',
		
		[Parameter(Position=1)]
		$Config = (Get-KeepassConfig)
    )
	
	[IO.FileInfo] $KeePassExe = Join-Path -Path $Config.'keepass-home' -ChildPath "KeePass.exe"
	if (-not $KeePassExe.Exists) {
	    throw "Keepass executable not found: {0}" -F $KeePassExe.FullName
	}
	
	[Reflection.Assembly]::LoadFile($KeePassExe.FullName) | Out-Null
	. $PSScriptRoot\KeepassDatabase.ps1
	
	if (-not $KeepassFile) {
	    [IO.FileInfo] $KeepassFile = Join-Path -Path (Split-Path -Path $Profile -Parent) -ChildPath ("{0}.kdbx" -F $Vault)
	}
	
	$VaultConfig = $Config.vault."$Vault"
	
	if (-not $VaultConfig){
		throw "Vault configuration not found: {0}" -F $Vault
	}
	
	if (-not $VaultConfig.file) {
	    throw "File not specified in vault configuration: {0}" -F $Vault
	}
	
	[IO.FileInfo] $KeepassFile = $VaultConfig.file
	[String] $Group = $VaultConfig.group
	

	
	$DB = New-Object KeepassDatabase -ArgumentList @(,$KeepassFile)
	
	return $DB
}