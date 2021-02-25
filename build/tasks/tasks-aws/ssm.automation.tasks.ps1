#Synposis: Run the AWS SSM Automation Document
task ssm-run-automation-example {
    @(
        'Aws.Tools.Common'
        'AWS.Tools.SimpleSystemsManagement'
    ) | ForEach-Object {
        try
        {
            Import-Module $_ -Scope Global
        }
        catch
        {
            Write-Build DarkYellow "error noted on trying to import: $($_.Exception.Message.ToString()) . Likely assembly already loaded"
        }
    }
    $StopWatch = [diagnostics.stopwatch]::StartNew()

    #################################################
    # Invoke Database Restore Command On SQL Server #
    #################################################

    $Params = @{
        'Foo'         = $ENV:FOO
        'bar'         = $ENV:BAR
        'AnotherTaco' = $ENV:ANOTHER_TACO
    }
    $sendSSMCommandSplat = @{
        DocumentName    = 'AWS-AutomatioNDocumentExample'
        Parameter       = $params
        DocumentVersion = '$LATEST'
    }

    $result = Start-SSMAutomationExecution -Mode Auto @sendSSMCommandSplat
    $result | Get-SSMAutomationExecution | Select-Object -ExpandProperty StepExecutions | Select-Object StepName, Action, StepStatus, ValidNextSteps

    Write-Build Green "Issued command with following parameters: $(($result | Get-SSMAutomationExecution).Parameters | Format-List | Out-String)"
    do
    {
        $execution = $result | Get-SSMAutomationExecution
        Write-Build DarkGray "SSMAutomationExecution: $($execution.AutomationExecutionStatus) $($Execution.CurrentStepName) $($Execution.CurrentAction) $($StopWatch.Elapsed.ToString('hh\:mm\:ss'))"
        Start-Sleep -Seconds 5
    }
    while ([string]::IsNullOrWhiteSpace($execution.CurrentAction) -eq $false -or $execution.AutomationExecutionStatus -eq 'InProgress')

    Write-Build DarkGreen "$($result | Get-SSMAutomationExecution | Select-Object -ExpandProperty StepExecutions | Select-Object StepName, Action, StepStatus, ValidNextSteps,FailureMessage | Format-List -Force | Out-String)"
    $result | Get-SSMAutomationExecution | Select-Object -ExpandProperty StepExecutions | ForEach-Object {
        $e = $_
        Write-Build DarkGray "$($e | Select-Object StepName, Action, StepStatus, ValidNextSteps | Format-Table -AutoSize -Wrap | Out-String)"
        Write-Build Green "Output Payload: `n$($e.Outputs.OutputPayload | ConvertFrom-Json -ErrorAction SilentlyContinue | Format-List -Force | Out-String)"
    }
    if ($result.FailureMessage)
    {
        Write-Build Red "SSM Failure: $($result.FailureMessage)"
    }
}
