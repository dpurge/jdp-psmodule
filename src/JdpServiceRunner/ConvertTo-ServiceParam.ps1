function ConvertTo-ServiceParam {
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
        $Item
    )
    
    $Value = $Null
    switch ($Item.type) {
    
        "string" {
            $Value = $Item.'#text'
        }
        
        "file" {
            $Value = [System.IO.FileInfo] $Item.'#text'
        }
        
        #"credential" {
        #    #$Value = $Item.'#text'
        #    $Value = Get-ServiceCredential $Item.'#text'
        #}
        
        "msmq" {
            $Value = $Item.'#text'
        }
    
        "eval" {
            $option = [System.StringSplitOptions]::RemoveEmptyEntries
            $chunk = $Item.'#text'.Split(' ', $option)
            $command = $chunk[0]
            $param = $chunk | select -skip 1
            #switch ($command) {
            #    "get-credential" {...}
            #}
            $Value = New-Object PSCustomObject -Property @{
                command = $command;
                param = @(,$param);
            }
            $Value.PSObject.TypeNames.Insert(0,'jdp.service.EvalInfo')
        }
    
        "self-eval" {
            $Value = '$this.{0}' -F $Item.'#text'
        }
        
        "service-message" {
            $Value = New-ServiceMessage
            $Value.subject = $Item.SelectSingleNode("subject") `
                | %{$_.InnerText}
            $Value.to.job = $Item.SelectSingleNode("to/job") `
                | %{$_.InnerText}
            $Value.to.queue = $Item.SelectSingleNode("to/queue") `
                | %{$_.InnerText}
            $Value.from.job = $Item.SelectSingleNode("from/job") `
                | %{$_.InnerText}
            $Value.from.queue = $Item.SelectSingleNode("from/queue") `
                | %{$_.InnerText}
            $Value.data = $Item.SelectSingleNode("data") `
                | %{$_.InnerText}
        }
        
        default {
            Throw "Type not supported: {0}" -F $Type
        }
    }
    
    $Value
}