function New-ServiceMessage {
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
    param ()
    
    $Template = @{
            subject = "";
            to = @{
                job = "";
                queue = "";
            };
            from = @{
                job = "";
                queue = "";
            }
            data = $Null;
        }
    
    $MessageInfo = New-Object PSCustomObject -Property $Template
    $MessageInfo.PSObject.TypeNames.Insert(0,'jdp.service.MessageInfo')
    
    [ScriptBlock] $Send = {
        [Reflection.Assembly]::LoadWithPartialName("System.Messaging") `
            | Out-Null
        $MSMQ = New-Object System.Messaging.MessageQueue($this.to.queue)
        $UTF8 = New-Object System.Text.UTF8Encoding
        $Transaction = New-Object System.Messaging.MessageQueueTransaction
        $Transaction.Begin()
        $msgBytes = $UTF8.GetBytes($this.toJSON())
        $msgStream = New-object System.IO.MemoryStream
        $msgStream.Write($msgBytes, 0, $msgBytes.Length)
        $msg = New-Object System.Messaging.Message
        $msg.BodyStream = $msgStream
        $msg.Label = $this.subject
        $MSMQ.Send($msg, $Transaction)
        $Transaction.Commit()
    }
    Add-Member `
        -InputObject $MessageInfo `
        -MemberType ScriptMethod `
        -Name Send `
        -Value $Send
    
    [ScriptBlock] $toJSON = {
        $this | ConvertTo-JSON -Compress
    }
    Add-Member `
        -InputObject $MessageInfo `
        -MemberType ScriptMethod `
        -Name toJSON `
        -Value $toJSON
    
    [ScriptBlock] $LoadJSON = {
        param (
            [Parameter(mandatory=$true, Position=0)]
            [string] $JSON
        )
        $j = $JSON | ConvertFrom-JSON
        $this.subject = $j.subject
        $this.to.job = $j.to.job
        $this.to.queue = $j.to.queue
        $this.from.job = $j.from.job
        $this.from.queue = $j.from.queue
        $this.data = $j.data
    }
    Add-Member `
        -InputObject $MessageInfo `
        -MemberType ScriptMethod `
        -Name LoadJSON `
        -Value $LoadJSON
    
    [ScriptBlock] $Respond = {
        param (
            [Parameter(mandatory=$true)]
            $Data
        )
        $msg = New-ServiceMessage
        $msg.subject = $this.subject
        $msg.to.job = $this.from.job
        $msg.to.queue = $this.from.queue
        $msg.from.job = $this.to.job
        $msg.from.queue = $this.to.queue
        $msg.data = $Data
        $msg.Send()
    }
    Add-Member `
        -InputObject $MessageInfo `
        -MemberType ScriptMethod `
        -Name Respond `
        -Value $Respond
        
    $MessageInfo
}