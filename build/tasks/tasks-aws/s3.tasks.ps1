#Synopsis: Using s5cmd (for now assuming it's installed) sync an updated directory. Note uses PowerShell 7 chain operator. woot woot.
Task s3-upload-directory {
    requires -Environment S3_BUCKET
    $MyCustomArtifactPath = Join-Path $ArtifactDirectory 'my-artifacts'
    $null = New-Item $MyCustomArtifactPath -ItemType Directory -Force
    switch -Wildcard ($PSVersionTable.OS)
    {
        '*Windows*' { $s5cmd = 's5cmd.exe' }
        '*Darwin*' { $s5cmd = 's5cmd' }
        '*Linux*' { $s5cmd = (Join-Path $BuildRoot 'binaries/linux/s5cmd') }
    }
    s5cmd version && Write-Build Green "s5cmd version matched: $(s5cmd version)" || Write-Build DarkYellow 'S5cmd not found so not running the sync commands. Install first'; return

    Write-Build Green 'Running sync command with following syntax:'
    Write-Build DarkGray "Exec { & $s5cmd cp --if-size-differ --if-source-newer `"$MyCustomArtifactPath/`" `"s3://$ENV:S3_BUCKET/modules/`" }"
    Exec { & $s5cmd cp --if-size-differ --if-source-newer "$MyCustomArtifactPath" "s3://$ENV:S3_BUCKET/modules/" }
}
