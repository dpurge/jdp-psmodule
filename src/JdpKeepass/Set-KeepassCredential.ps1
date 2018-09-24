function Set-KeepassCredential {
    <#
    .SYNOPSIS
    .DESCRIPTION
    .EXAMPLE
	    Remove-Module KeepassTools; Import-Module .\KeepassTools; Set-KeepassCredential -Title test1 -Group group1 -Credential $cred
    .OUTPUTS
    .NOTES
        Author: JDP
    .LINK
    #>
	
	
	PARAM(
        [Parameter(Position=0, Mandatory=$true)]
		[ValidateNotNullOrEmpty()] 
        [string] $Title,
		
        [Parameter(Position=1, Mandatory=$true)]
        [System.Management.Automation.PSCredential] $Credential,
		
        [Parameter(Position=2, Mandatory=$false)]
        [string] $Group,
		
        [Parameter(Position=3, Mandatory=$false)]
        [string] $Url,
		
        [Parameter(Position=4, Mandatory=$false)]
        [string] $Note,
		
        [Parameter(Position=5, Mandatory=$false)]
        [string] $Vault = 'default',
		
		[Parameter(Position=6, Mandatory=$false)]
		$Config = (Get-KeepassConfig)
    )
	
	[string] $UserName = $Credential.UserName
	[string] $Password = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
	    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Credential.Password))
	
	$DB = Get-KeepassDatabase -Vault $Vault -Config $Config
	$DB.Open()
	$DB.Add($Title, $UserName, $Password, $Group, $Url, $Note)
	$DB.Save()
	$DB.Close()
	
}
