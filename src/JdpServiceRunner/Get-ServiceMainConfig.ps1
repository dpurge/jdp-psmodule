function Get-ServiceMainConfig {
    <#
    .SYNOPSIS
    .DESCRIPTION
    .EXAMPLE
        Get-ServiceMainConfig 
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
    $config = Get-ServiceConfig -ConfigFile $ConfigFile
    $srv = $config.SelectSingleNode("/configuration/service")
    if (-not $srv) {Throw "Service configuration is missing!"}
    $cfg = @{ConfigFile = $ConfigFile;}
    foreach ($item in $srv.SelectNodes("child::*[@type]")) {
        $cfg[$item.name] = ConvertTo-ServiceParam $item
    }
    $cfg
}