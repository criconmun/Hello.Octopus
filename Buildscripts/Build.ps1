Properties {
    $ReleaseTag
    $BuildNumber
    $OctopusApiKey
    $Channel
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
    Exec{
        & Octo.exe create-release --project HelloOctopus.Web --channel $Channel --server http://localhost:8081/ --apiKey $OctopusApiKey --releaseNotes "Jenkins build [$BuildNumber](http://localhost:8080/job/Hello.Octopus-sprint/$BuildNumber)/"
        & Octo.exe create-release --project HelloOctopus.Service --channel $Channel --server http://localhost:8081/ --apiKey $OctopusApiKey --releaseNotes "Jenkins build [$BuildNumber](http://localhost:8080/job/Hello.Octopus-sprint/$BuildNumber)/"
    }
}
