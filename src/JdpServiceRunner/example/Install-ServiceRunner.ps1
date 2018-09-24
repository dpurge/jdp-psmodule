function Install-ServiceRunner {
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
    
    [Reflection.Assembly]::LoadWithPartialName("System.Messaging") | Out-Null
    
    $config = Get-ServiceMainConfig @PSBoundParameters
    foreach ($key in $($config.Keys)) {
        if ($config[$key].PSObject.TypeNames[0] `
            -eq 'jdp.service.EvalInfo') {
            switch ($config[$key].command) {
                "get-credential" { 
                    $config[$key] = $(`
                        Get-ServiceCredential `
                            -CredentialID $config[$key].param[0] `
                            -ConfigFile $ConfigFile)
                }
                default { 
                    Throw "Unsupported config command: {0}" -F $config[$key]['command'] }
            }
        }
    }

    $QueueName = $config.queue
    $isTransactional = $true
    $isJournalEnabled = $true
    $QueueOwner = $config.credential.UserName
    If (-not [System.Messaging.MessageQueue]::Exists($QueueName))
    {
        try {
          $newQ = [System.Messaging.MessageQueue]::Create($QueueName,
            $isTransactional)
          $newQ.UseJournalQueue = $isJournalEnabled
          $newQ.SetPermissions($QueueOwner,`
            [System.Messaging.MessageQueueAccessRights]::FullControl,`
            [System.Messaging.AccessControlEntryType]::Allow)
          $newQ.Label = "PSService queue"
        } catch [Exception] {
            Write-Host $_.Exception.ToString()
        }
    }
    
    # Register job schedulers
    #$dailyTrigger = New-JobTrigger -Daily -At "2:00 PM"
    #$option = New-ScheduledJobOption -StartIfOnBattery –StartIfIdle
    #Register-ScheduledJob `
    #    -Name PSService-Daily `
    #    -ScriptBlock {Import-Module ServiceRunner; (Get-ServiceScheduler -Schedule test -ConfigFile C:\jdp\src\tmp\jdp-psservice\Script\Service.config).Run()} `
    #    -Trigger $dailyTrigger `
    #    -ScheduledJobOption $option
}

# EXECUTE #
Import-Module ServiceRunner
Install-ServiceRunner -ConfigFile $PSScriptRoot\Service.config 