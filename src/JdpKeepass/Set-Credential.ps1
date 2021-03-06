function Set-Credential {
    <#
    .SYNOPSIS
    .DESCRIPTION
    .EXAMPLE
	    Set-JdpKeepassCredential -Title test1 -Group group1 -Credential (Get-Credential)
    .OUTPUTS
    .NOTES
        Author: JDP
    .LINK
    #>
	
	
	param (
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
		$Config = (Get-Config)
    )
	
	[string] $UserName = $Credential.UserName
	[string] $Password = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
	    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Credential.Password))
	
	$Database = Get-Database -Vault $Vault -Config $Config
	$Database.Open()
	$Database.Add($Title, $UserName, $Password, $Group, $Url, $Note)
	$Database.Save()
	$Database.Close()
}
