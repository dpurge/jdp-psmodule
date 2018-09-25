function Get-Database {
	
	[OutputType('JdpKeepass.VaultInfo')]
	param (
        [Parameter(Position=0)]
        [string] $Vault = 'default',
		
		[Parameter(Position=1)]
		$Config = (Get-Config)
    )
	
	
	[Reflection.Assembly]::LoadFile("${PsScriptRoot}\lib\KeePassLib.dll") | Out-Null
	. $PSScriptRoot\class\KeepassDatabase.ps1

	
	$VaultConfig = $Config.vault."$Vault"
	
	if (-not $VaultConfig){
		throw "Vault configuration not found: {0}" -F $Vault
	}
	
	if (-not $VaultConfig.file) {
	    throw "File not specified in vault configuration: {0}" -F $Vault
	}
	
	[IO.FileInfo] $KeepassFile = $VaultConfig.file
	
	$Database = New-Object KeepassDatabase -ArgumentList @(,$KeepassFile)
	
	return $Database
}