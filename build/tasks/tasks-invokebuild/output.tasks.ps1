# Define headers as separator, task path, synopsis, and location, e.g. for Ctrl+Click in VSCode.
# Also change the default color to Green. If you need task start times, use `$Task.Started`.
Set-BuildHeader {
    param($Path)
    # separator line
    Write-Build Green ('=' * 140)
    #Write-Build Green ('=' * 140)
    # default header + synopsis
    Write-Build Green "Task $Path : $(Get-BuildSynopsis $Task)"
    # task location in a script
    Write-Build Green "At $($Task.InvocationInfo.ScriptName):$($Task.InvocationInfo.ScriptLineNumber)"
}

# Define footers similar to default but change the color to DarkGray.
Set-BuildFooter {
    param($Path)
    Write-Build DarkGray "Done $Path, $($Task.Elapsed)"
    Write-Build Green ('=' * 140)
}

task docs-output-invoke-build-docs {
    if (-not (Get-InstalledModule PSWriteHtml -ErrorAction SilentlyContinue))
    {
        throw "Can't do this without [Install-Module PSWriteHTML -Scope CurrentUser ]"
    }
    Invoke-Build ? .\tasks.build.ps1 | Where-Object { @($_.Jobs).Count -gt 1 } | ForEach-Object {
        [pscustomobject]@{
            JobName  = $_.Name
            Synopsis = $_.Synopsis
            Tasks    = $_.Jobs.ForEach{ [string]$_ } | Format-Table -AutoSize -Wrap | Out-String
        }

    } | Out-HtmlView
}
