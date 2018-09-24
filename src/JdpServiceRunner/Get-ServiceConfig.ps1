function Get-ServiceConfig {
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
        [System.IO.FileInfo] $ConfigFile
    )
	   
    if (-not $ConfigFile.Exists) {
        Throw "Configuration file does not exist: " + `
            $ConfigFile.FullName
    }
    
	$Config = New-Object System.Xml.XmlDocument
    $Config.PreserveWhitespace = $true
    $Config.Load($ConfigFile)
    if (-not $Config.configuration.credentials) {
        Throw "Incorrect format of configuration file: " + `
            $ConfigFile.FullName
    }
    $Config.PreserveWhitespace = $true
    
    $Config
}
