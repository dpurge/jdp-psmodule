function Resolve-PackageSource {

    $IsTrusted    = $false
    $IsRegistered = $false
    $IsValidated  = $true

    if (Test-Path $PackageLocation) {
        New-PackageSource -Name $ProviderName -Location $PackageLocation -Trusted $IsTrusted -Registered $IsRegistered -Valid $IsValidated
    }   
}