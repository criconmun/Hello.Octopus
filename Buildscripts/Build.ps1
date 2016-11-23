Properties {
    $ReleaseTag
    $BuildNumber
    $OctopusApiKey
}

Task Default -Depends Build, Push

Task Build {
    $PaddedBuildNumber = $BuildNumber.PadLeft(4,"0")
    
    Exec {
        Push-Location ..\

        nuget restore
        msbuild HelloOctopus.sln `
            /t:build `
            /p:configuration=release `
            /p:runoctopack=true `
            /p:OctoPackAppendToVersion=$ReleaseTag-$PaddedBuildNumber `
            /p:OctoPackPublishPackageToHttp=http://localhost:8081/nuget/packages `
            /p:OctoPackPublishApiKey=$OctopusApiKey
    }

}

Task Push {
    Write-Host "Starting Push"
}
