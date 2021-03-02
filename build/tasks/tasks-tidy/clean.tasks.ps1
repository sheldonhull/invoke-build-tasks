#Synposis: cleanup local artifacts
Task clean {
    Write-Build DarkGray 'removing artifacts'
    Assert { $ArtifactDirectory -match 'artifacts' }
    remove $ArtifactDirectory
    New-Item -Path $ArtifactDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue *> $null
}
