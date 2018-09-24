function Get-ServiceMain {
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
    
    $config = Get-ServiceMainConfig @PSBoundParameters
    $ServiceInfo = New-Object PSCustomObject -Property $config
    $ServiceInfo.PSObject.TypeNames.Insert(0,'jdp.service.ServiceInfo')
    
    [ScriptBlock] $Run = {
        [Reflection.Assembly]::LoadWithPartialName("System.Messaging") | Out-Null
    
        $MSMQ = New-Object System.Messaging.MessageQueue($this.queue)
        $UTF8 = New-Object System.Text.UTF8Encoding
        $RUN = $True
    
        while ($RUN) {
            $mqmsg = $MSMQ.Receive()
            $msgbody = $UTF8.GetString($mqmsg.BodyStream.ToArray())
			$msg = New-ServiceMessage
			$msg.LoadJSON($msgbody)
            if ($msg.to.job -eq "service") {
                switch ($msg.data) {
                    "STOP-SERVICE" {
                        $RUN = $False
                    }
                    default {
                    
                    }
                }
            } else {
				$LogEntry = "{0} -> {1} ({2})" -F $msg.to.job,$msg.subject,$msg.data
                $this.WriteLog($LogEntry)
                $Job = Get-ServiceJob `
                    -JobID $msg.to.job `
                    -ConfigFile $this.ConfigFile `
					-Message $msg
                $Job.Run()
            }
        }
    }
    Add-Member `
        -InputObject $ServiceInfo `
        -MemberType ScriptMethod `
        -Name Run `
        -Value $Run
        
    
    [ScriptBlock] $WriteLog = {
        param (
            [Parameter(mandatory=$true)]
            [string] $LogEntry
        )
        if ($this.log) {
		    $Timestamp = Get-Date -F "yyyy-MM-dd HH:mm:ss"
            "{0} {1}" -F $Timestamp,$LogEntry `
            | Out-File $this.log -Append
        }
    }
    Add-Member `
        -InputObject $ServiceInfo `
        -MemberType ScriptMethod `
        -Name WriteLog `
        -Value $WriteLog
        
    $ServiceInfo
}