function New-KeyGesture {

    [OutputType('System.Windows.Input.KeyGesture')]
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Input.Key] $Key,

        [Parameter(Mandatory=$false)] 
        [ValidateSet("Alt","Control","None","Shift","Windows")] 
        [System.Windows.Input.ModifierKeys[]] $ModifierKeys = "",

        [Parameter(Mandatory=$false)] 
        [String] $DisplayText = ""
    )
    
    Add-Type -AssemblyName PresentationFramework
    $KeyGesture = New-Object System.Windows.Input.KeyGesture -ArgumentList $Key, $ModifierKeys, $DisplayText
    return $KeyGesture
}