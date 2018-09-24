function Invoke-DummyJob {
    <#
    .SYNOPSIS
    .DESCRIPTION
        Example job returning some data to be processed
        by another job.
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
    
    @{
	    MyItem = $Item;
	}
}