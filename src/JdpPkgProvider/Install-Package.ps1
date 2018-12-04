function Install-Package { 
    param(
        [string] $FastPackageReference
    )

    "JDP install package: ${FastPackageReference}" | Out-File D:\dat\jdpsystem.txt
}