function Get-ServiceScheduler {
    <#
    .SYNOPSIS
    .DESCRIPTION
    .EXAMPLE
        (Get-ServiceScheduler hourly C:\jdp\src\tmp\jdp-psservice\PSModules\Service.config).Run()
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
    
    $template = @{
        messages = (Get-ServiceSchedulerConfig @PSBoundParameters);
    }
    $SchedulerInfo = New-Object PSCustomObject -Property $Template
    $SchedulerInfo.PSObject.TypeNames.Insert(0,'jdp.service.SchedulerInfo')
    
    [ScriptBlock] $Run = {
        foreach ($message in $this.messages) {
            $message.Send()
        }
    }
    Add-Member `
        -InputObject $SchedulerInfo `
        -MemberType ScriptMethod `
        -Name Run `
        -Value $Run
        
    $SchedulerInfo
}