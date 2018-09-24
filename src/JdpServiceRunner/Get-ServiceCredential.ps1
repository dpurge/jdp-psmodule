function Get-ServiceCredential {
    <#
    .SYNOPSIS
    .DESCRIPTION
    .EXAMPLE 
    .OUTPUTS
    .NOTES
        Author: JDP
    .LINK
    #>
                
    [CmdletBinding()]
    param (
        [Parameter(mandatory=$true)]
        [string] $CredentialID,
        [Parameter(mandatory=$true)]
        [System.IO.FileInfo] $ConfigFile
    )
    $config = Get-ServiceConfig -ConfigFile $ConfigFile
    $cred = $Config.SelectNodes("/configuration/credentials/credential[@id = '$CredentialID']")
    if (-not $cred) {Throw "Credential configuration is missing: {0}" -F $CredentialID}
    
    $password = `
        $cred.SelectSingleNode("password") `
        | %{$_.InnerText} `
        | ConvertTo-SecureString -asPlainText -Force
    
    $domain = `
        $cred.SelectSingleNode("domain") `
        | %{$_.InnerText}
    
    $username = `
        $cred.SelectSingleNode("username") `
        | %{$_.InnerText}
        
    if ($domain) {
        $credential = New-Object `
          -TypeName System.Management.Automation.PSCredential `
          -ArgumentList "$domain\$username",$password
    } else {
        $credential = New-Object `
          -TypeName System.Management.Automation.PSCredential `
          -ArgumentList "$username",$password
    }
    
    $credential
}