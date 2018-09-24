function Get-KeepassPSCredential {
    <#
    .SYNOPSIS
    .DESCRIPTION
    .EXAMPLE
    .OUTPUTS
    .NOTES
        Author: JDP
    .LINK
    #>
	
	
	PARAM(
        [Parameter(Position=0, Mandatory=$true)]
		[ValidateNotNullOrEmpty()] 
        [string] $Title,
		
        [Parameter(Position=1, Mandatory=$false)]
        [string] $Group,
		
        [Parameter(Position=2, Mandatory=$false)]
        [string] $Vault = 'default',
		
		[Parameter(Position=3, Mandatory=$false)]
		$Config = (Get-KeepassConfig)
    )
	
	$KeepassCredential = Get-KeepassCredential -Title $Title -Group $Group -Vault $Vault -Config $Config
	$SecurePassword = ConvertTo-SecureString $KeepassCredential.Password -AsPlainText -Force
	$KeepassPSCredential = New-Object System.Management.Automation.PSCredential ($KeepassCredential.UserName, $SecurePassword)
	
	return $KeepassPSCredential
}
