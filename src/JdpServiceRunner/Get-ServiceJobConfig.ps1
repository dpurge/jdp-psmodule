function Get-ServiceJobConfig {
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
        [string] $JobID,
        [Parameter(mandatory=$true)]
        [System.IO.FileInfo] $ConfigFile,
        [Parameter(mandatory=$false)]
        $Message = $Null
    )
    $config = Get-ServiceConfig -ConfigFile $ConfigFile
    $job = $Config.SelectNodes("/configuration/jobs/job[@id = '$JobID']")
    if (-not $job) {Throw "Job configuration is missing!"}
    
    $cfg = @{
        ConfigFile = $ConfigFile;
        Param = @{};
        Message = $Message;
		Respond = if ($job.respond -eq "true") {$True} else {$False};
    }
    $cfg["Command"] = $job.SelectSingleNode("command") `
        | %{$_.InnerText}
    $cfg["Description"] = $job.SelectSingleNode("description") `
        | %{$_.InnerText}
        
    foreach ($item in $job.SelectNodes("param/child::*[@type]")) {
        $cfg.Param[$item.name] = ConvertTo-ServiceParam $item
    }
    
    $cfg
}