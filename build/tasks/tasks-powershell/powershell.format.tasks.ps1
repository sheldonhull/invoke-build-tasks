# Synopsis: Format code using PSScriptAnalyzer
Task powershell-format-code {
    $PSScriptAnalyzerExclusions = '(artifacts)|(packages)'
    $Settings = Join-Path $BuildRoot 'build/settings/powershell-formatting-settings.psd1'
    Write-Build DarkGray 'Applying Formatting to All PS1 Files'
    $files = & git status --porcelain | Where-Object { $_ -notmatch '^D' } |
    ForEach-Object { $_.TrimStart('ADMR ') } |
    ForEach-Object { Get-Item -Path $_ } |
    Where-Object { $_ -like '*.ps1' } |
    Where-Object FullName -NotMatch $PSScriptAnalyzerExclusions
    Write-Build DarkGray "Total Files to Process: $(@($Files).Count)"
    $x = 0
    $id = Get-Random
    Write-Progress -Id $id -Activity 'Formatting Files' -PercentComplete 0
    $files | ForEach-Object {
        $f = $_
        [string]$content = ([System.IO.File]::ReadAllText($f.FullName)).Trim()
        if (-not $Content) {
            Write-Build DarkGray "Bypassed: $($f.Name) per empty"
            continue
        }
        $formattedContent = Invoke-Formatter -ScriptDefinition $content -Settings $Settings
        $UTF8NoBOM = [System.Text.UTF8Encoding]::new($false)
        [System.IO.File]::WriteAllLines($f.FullName, $formattedContent, $UTF8NoBOM) #no bom by default here or could use 6.1 out-file with this built in
        Write-Progress -Id $id -Activity 'Formatting Files' -PercentComplete ([math]::Floor(($x / @($files).Count)) * 100) -CurrentOperation "Formatted $($f.FullName)" -ErrorAction SilentlyContinue
        $x++
    } -End {
        Write-Progress -Id $id -Activity 'Formatting Files' -Completed
    }
}
