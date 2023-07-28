# Synopsis: Lint code using PSScriptAnalyzer
Task powershell-lint {
    $Settings = Join-Path $BuildRoot -ChildPath 'build' -AdditionalChildPath 'settings', 'PSScriptAnalyzerSettings.psd1'
    $list = [System.Collections.Generic.List[pscustomobject]]::new()
    $scriptAnalyzerRules = Get-ScriptAnalyzerRule
    $files = & git diff --name-only --diff-filter=d | Where-Object { $_ -like '*.ps1' } | ForEach-Object { Get-Item -Path $_ }
    # generate a progress bar for the files to process
    $ProgressPreference = 'Continue'
    $id = Get-Random
    Write-Progress -Id $id -Activity 'Linting Files' -PercentComplete 0
    $x = 0
    $rules = @($scriptAnalyzerRules).Count
    $scriptAnalyzerRules | ForEach-Object {
        $rule = $_
        $percentcomplete = [math]::Floor(($x / $rules) * 100)
        Write-Progress -Id $id -Activity 'Linting Files' -Status "${rule.RuleName} ${percentcomplete}" -PercentComplete $percentcomplete -CurrentOperation "Linting $($rule.RuleName)" -ErrorAction SilentlyContinue
        $x++
        $files | ForEach-Object {
            $file = $_
            Invoke-ScriptAnalyzer -Path $file -Settings $Settings -IncludeRule $rule | ForEach-Object {
                $list.Add([pscustomobject]@{
                        RuleName   = $_.RuleName
                        ScriptName = $_.ScriptName
                        Line       = $_.Line
                        Message    = $_.Message
                    })
            }
        }
    }
    $list | Format-Table -AutoSize
    Write-Progress -Id $id -Activity 'Linting Files' -Completed
}
