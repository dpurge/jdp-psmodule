function Get-Credential {
    <#
    .SYNOPSIS
    .DESCRIPTION
    .EXAMPLE
	    Get-JdpKeepassCredential -Title test1 -Group group1
    .OUTPUTS
    .NOTES
        Author: JDP
    .LINK
    #>
	
	
	param (
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
	
	$Database = Get-Database -Vault $Vault -Config $Config
	$Database.Open()
	$Credential = $Database.Get($Title, $Group)
	#$Database.Save()
	$Database.Close()
	
	return $Credential
}
