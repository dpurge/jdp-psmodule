function Get-KeepassCredential {
    <#
    .SYNOPSIS
    .DESCRIPTION
    .EXAMPLE
	    Remove-Module KeepassTools; Import-Module .\KeepassTools; Get-KeepassCredential -Title test1 -Group group1
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
	
	$DB = Get-KeepassDatabase -Vault $Vault -Config $Config
	$DB.Open()
	$KeepassCredential = $DB.Get($Title, $Group)
	#$DB.Save()
	$DB.Close()
	
	return $KeepassCredential
}
