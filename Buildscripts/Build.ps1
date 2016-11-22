Properties {
    $ReleaseTag
    $BuildNumber
}

Task Default -Depends Build, Push

Task Build {
    Exec {
        Push-Location ..\

        nuget restore
        msbuild HelloOctopus.sln `
            /t:build `
            /p:configuration=release `
            /p:runoctopack=true `
            /p:OctoPackAppendToVersion=$ReleaseTag-$BuildNumber
    }

}

Task Push {
    Write-Host "Starting Push"
}