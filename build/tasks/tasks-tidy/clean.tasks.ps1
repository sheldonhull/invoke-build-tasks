#Synposis: cleanup local artifacts
Task clean {
    Write-Build DarkGray 'removing artifacts'
    Assert { $ArtifactDirectory -match '.artifacts' }
    remove $ArtifactDirectory
    New-Item -Path $ArtifactDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue *> $null
}
#Synposis: cleanup local artifacts and even the local cached modules
Task deepclean clean, {
    Write-Build DarkGray 'removing packages, which includes RequiredModules'
    remove (Join-Path $BuildRoot 'packages')
    $CheckpointFiles = Get-ChildItem $BuildRoot -Filter *.clixml
    remove $CheckpointFiles
}
