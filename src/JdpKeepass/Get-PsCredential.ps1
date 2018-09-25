function Get-PsCredential {
    <#
    .SYNOPSIS
    .DESCRIPTION
    .EXAMPLE
	    Get-JdpKeepassPsCredential -Title test1 -Group group1
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
		$Config = (Get-Config)
    )
	
	$Credential = Get-Credential -Title $Title -Group $Group -Vault $Vault -Config $Config
	$SecurePassword = ConvertTo-SecureString $Credential.Password -AsPlainText -Force
	$PSCredential = New-Object System.Management.Automation.PSCredential ($Credential.UserName, $SecurePassword)
	
	return $PSCredential
}
