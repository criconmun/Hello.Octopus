Properties {
    $ReleaseTag
    $BuildNumber
    $OctopusApiKey
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
            /p:OctoPackAppendToVersion=$ReleaseTag-$BuildNumber `
            /p:OctoPackPublishPackageToHttp=http://localhost:8081/api/v2/package `
            /p:OctoPackPublishApiKey=$OctopusApiKey
    }

}

Task Push {
    Write-Host "Starting Push"
}
