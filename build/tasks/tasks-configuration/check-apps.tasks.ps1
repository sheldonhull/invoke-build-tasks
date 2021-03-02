
check bootstrap-install-aws-vault {
    Write-Build DarkGray "Bootstraping aws-vault for: $($PSVersionTable.OS)"
    switch -Wildcard ($PSVersionTable.OS)
    {
        'Windows' { choco install aws-vault -y --no-progress --quiet }
        'Darwin' { brew cask install aws-vault }
        'Linux'
        {
            $releases = Get-GitHubRelease -Owner 99designs -RepositoryName 'aws-vault' -Latest | Get-GitHubReleaseAsset
            Write-Build DarkGray "Github Releases found: $(@($releases).count)"
            $downloadurl = $releases.Where{ $_.Name -match 'linux\-amd64' }.url
            sudo curl -L -o /usr/local/bin/aws-vault $downloadurl
            sudo chmod 755 /usr/local/bin/aws-vault
        }
    }
}
