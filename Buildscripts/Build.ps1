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
    & "C:\Tools\Octo\Octo.exe" create-release --project HelloOctopus.Web --server http://localhost:8081/ --apiKey $OctopusApiKey --releaseNotes "Jenkins build [$BuildNumber](http://localhost:8080/job/Hello.Octopus-sprint/$BuildNumber)/"
    & "C:\Tools\Octo\Octo.exe" create-release --project HelloOctopus.Service --server http://localhost:80:81/ --apiKey $OctopusApiKey --releaseNotes "Jenkins build [$BuildNumber](http://localhost:8080/job/Hello.Octopus-sprint/$BuildNumber)/"

}
