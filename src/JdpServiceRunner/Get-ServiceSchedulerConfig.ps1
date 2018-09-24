function Get-ServiceSchedulerConfig {
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
        [string] $Schedule,
        [Parameter(mandatory=$true)]
        [System.IO.FileInfo] $ConfigFile
    )
    $config = Get-ServiceConfig -ConfigFile $ConfigFile
    $sched = $config.SelectSingleNode("/configuration/scheduler/schedule[@id = '$Schedule']")
    if (-not $sched) {Throw "Scheduler configuration is missing: {0}" -F $Schedule}
    
    $cfg = New-Object System.Collections.ArrayList
    foreach ($item in $sched.SelectNodes("child::*[@type]")) {
        $msg = ConvertTo-ServiceParam $item
        $cfg.Add($msg) | Out-Null
    }
    $cfg
}