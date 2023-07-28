
# Synopsis: run pester against any test files in the repo
task powershell-pester {
    Import-Module Pester -MinimumVersion 5.4

    $configuration = [PesterConfiguration]@{
        Run        = @{
            Path        = '*.tests.ps1'
            ExcludePath = '*PSFramework*', '*_tmp*'
            PassThru    = $True
            Container   = $pc
        }
        Should     = @{
            ErrorAction = 'Continue'
        }
        TestResult = @{
            Enabled      = $true
            OutputPath   = (Join-Path $ArtifactDirectory 'TEST-PESTER-RESULTS.xml')
            OutputFormat = 'NUnitXml'
        }
        Output     = @{
            Verbosity = 'Diagnostic'
        }
    }
    $files = Get-ChildItem $configuration.Run.Path -Recurse
    if ($files.Count -eq 0) {
        Write-Build DarkYellow "No test files found in $($configuration.Run.Path)"
        return
    }
    $testresults = @()
    $testresults += Invoke-Pester -Configuration $Configuration

    Write-Host '======= TEST RESULT OBJECT ======='

    foreach ($result in $testresults) {
        $totalRun += $result.TotalCount
        $totalFailed += $result.FailedCount
        $result.Tests | Where-Object Result | ForEach-Object {
            $testresults += [pscustomobject]@{
                Block   = $_.Block
                Name    = "It $($_.Name)"
                Result  = $_.Result
                Message = $_.ErrorRecord.DisplayErrorMessage
            }
        }
    }

    if ($totalFailed -eq 0) { Write-Build Green "All $totalRun tests executed without a single failure!" }
    else { Write-Build Red "$totalFailed tests out of $totalRun tests failed!" }
    if ($totalFailed -gt 0) {
        throw "$totalFailed / $totalRun tests failed!"
    }
}
