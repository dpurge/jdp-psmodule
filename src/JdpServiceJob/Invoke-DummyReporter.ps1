function Invoke-DummyReporter {
    <#
    .SYNOPSIS
    .DESCRIPTION
        Example report writing data to a file.
    .EXAMPLE   
    .OUTPUTS
    .NOTES
        Author: JDP
    .LINK
    #>
                
    [CmdletBinding()]
    param (
        [Parameter(mandatory=$true)]
        $DataFile,
        [Parameter(mandatory=$true)]
        $DataItem
    )
    
    $ReportLine = "Received data ==> {0}" -F $DataItem.data.MyItem
    Write-Output $ReportLine | Out-File $DataFile -Append
}