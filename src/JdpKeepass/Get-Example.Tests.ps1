Import-Module JdpKeepass -Force

Describe "Get-Example" {
    It "returns example" {
	    $message = 'Message'
	    $example = Get-Example -Message $message
        $example.Message | Should Be $message
    }
}