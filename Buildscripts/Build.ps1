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
            /p:OctoPackAppendToVersion=$ReleaseTag-$BuildNumber.PadLeft(4,"0") `
            /p:OctoPackPublishPackageToHttp=http://localhost:8081/nuget/packages `
            /p:OctoPackPublishApiKey=$OctopusApiKey
    }

}

Task Push {
    Write-Host "Starting Push"
}
