function Set-ServiceCredential {
    <#
    .SYNOPSIS
    .DESCRIPTION
	    Write encrypted password in the service configuration file.
    .EXAMPLE
        Set-ServiceCredential -CredentialID default -Password secret -ConfigFile Service.config      
    .OUTPUTS
    .NOTES
        Author: JDP
    .LINK
    #>
                
    [CmdletBinding()]
    param (
        [Parameter(mandatory=$true)]
        [string] $CredentialID,
        [Parameter(mandatory=$false)]
        [System.IO.FileInfo] $ConfigFile
    )
    
    $Config = Get-ServiceConfig $ConfigFile.FullName
	
    $XmlCred = $Config.configuration.credentials.credential | ?{$_.id -eq $CredentialID}
    if (-not $XmlCred) {
            Throw "No credential with this ID: " + `
                $CredentialID
    }
	
	$Prompt = if ($XmlCred.domain -ne "") {"{0}\{1}" -F $XmlCred.domain, $XmlCred.username} else {$XmlCred.username}
	$Credential = Get-Credential $Prompt
    $NetCredential = $Credential.GetNetworkCredential()
    $XmlCred.domain = $NetCredential.Domain
	$XmlCred.username = $NetCredential.Username
	$XmlCred.password = [string]($Credential.Password | ConvertFrom-SecureString)
	$Config.Save($ConfigFile)
}