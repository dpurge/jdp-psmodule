function Get-ServiceJob {
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
    
    $config = Get-ServiceJobConfig @PSBoundParameters
    $JobInfo = New-Object PSCustomObject -Property $config
    $JobInfo.PSObject.TypeNames.Insert(0,'jdp.service.JobInfo')
        
    [ScriptBlock] $Run = {
            $cmd = $this.Command
            $cmdparam = $this.Param
			foreach ($key in $($cmdparam.Keys)) {
                if ($cmdparam[$key].PSObject.TypeNames[0] -eq 'jdp.service.EvalInfo') {
                    switch ($cmdparam[$key].command) {
                        "get-message" { $cmdparam[$key] = $this.Message }
                        default { Throw "Unsupported config command: {0}" -F $cmdparam[$key]['command'] }
                    }
                }
			}
            $result = &$cmd @cmdparam
			if ($this.Respond) {
			    $this.Message.Respond($result)
			}
	}  
    Add-Member `
        -InputObject $JobInfo `
        -MemberType ScriptMethod `
        -Name Run `
        -Value $Run
        
    [ScriptBlock] $ParamTest = {
	        $this.Message = "Ala ma kota2"
            $cmdparam = $this.Param
			foreach ($key in $($cmdparam.Keys)) {
			    if ($cmdparam[$key] -eq '$this.Message') {
				    $cmdparam[$key] = $this.Message
				}
			}
	}  
    Add-Member `
        -InputObject $JobInfo `
        -MemberType ScriptMethod `
        -Name ParamTest `
        -Value $ParamTest
        
    $JobInfo
}