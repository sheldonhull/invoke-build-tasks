task powershell_run_scriptanalyzer {
    [CmdletBinding()]
    Param (
        [switch]
        $SkipTest
    )
    $CommandPath = $BuildRoot
    $Settings = Join-Path $BuildRoot 'build\PSScriptAnalyzerSettings.psd1'
    if ($SkipTest) { return }
    $list = New-Object System.Collections.ArrayList
    Describe 'Invoking PSScriptAnalyzer against commandbase' {
        $commandFiles = Get-ChildItem -Path $CommandPath -Recurse -Filter '*.ps1' | Where-Object { $_.FullName -notmatch 'ps_modules' }
        $scriptAnalyzerRules = Get-ScriptAnalyzerRule

        foreach ($file in $commandFiles)
        {
            Context "Analyzing $($file.BaseName)" {
                $analysis = Invoke-ScriptAnalyzer -Path $file.FullName -Settings $Settings
                forEach ($rule in $scriptAnalyzerRules)
                {
                    It "Should pass $rule" {
                        If ($analysis.RuleName -contains $rule)
                        {
                            $analysis | Where-Object RuleName -EQ $rule -OutVariable failures | ForEach-Object { $list.Add($_) }
                            1 | Should Be 0
                        }
                        else
                        {
                            0 | Should Be 0
                        }
                    }
                }
            }
        }
    }
    $list
}
