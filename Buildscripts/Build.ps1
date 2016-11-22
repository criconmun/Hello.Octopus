Task Default -Depends Build, Push



Task Build {
    Exec {
        Push-Location ..\
        nuget restore
        msbuild HelloOctopus.sln /t:build /p:configuration=release,runoctopack=true
    }
}



Task Push {
    Write-Host "Starting Push"
}