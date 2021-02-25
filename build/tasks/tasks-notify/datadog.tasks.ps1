<#
.Synopsis
    Function to create a nicely formatted build notification for Azure Pipelines that is generic enough to use in any context, while still allowing appending of additional info.
.Description
    Pretty markdown formatted messages
.Example
    PS> Write-DatadogEvent -title 'Test Pipeline Invocation' -text "This is important... but only a test `n [Google](Google.com)" -Status 'Fail'

#>
function Write-DatadogEvent
{
    [cmdletbinding()]
    param(
        [Parameter(mandatory)]
        [string]
        $title

        , [Parameter(mandatory)]
        [string]
        $text
        , [Parameter()]
        [string]$status
    )
    if (-not $ENV:DD_API_KEY)
    {
        Write-Warning 'No DD_API_KEY environment variable found, bypassing event'
        return
    }
    switch -regex ($status)
    {
        '(failed)|(warning)|(issues)' { $DatadogStatus = 'warning'; break }
        '^succeeded' { $DatadogStatus = 'success'; break }
        default { $DatadogStatus = 'success' }
    }
    Write-Host "Datadog Status: $DatadogStatus"
    $SplatRestMethod = @{

        Method                = 'POST'
        Uri                   = "https://api.datadoghq.com/api/v1/events?api_key=$env:DD_API_KEY"
        ContentType           = 'application/json'
        Body                  = @{
            text            = ('%%%', $text, '%%%' -join "`n")
            title           = $title
            alert_type      = $DatadogStatus
            aggregation_key = $title
            tags            = @(
                'code-pipeline:azure-devops'
                "code-repository:${env:Build_Repository_Name}"
            )
        } | ConvertTo-Json -Depth 2 -Compress
        UseDefaultCredentials = $true
    }
    Invoke-RestMethod @SplatRestMethod
}

#Synopsis: Notify datadog of the result when running in CI. Title and remaining message is dynamically set from the azure pipelines build variables
Task teams-notify-datadog {
    # List of Predefined Variables: https://docs.microsoft.com/en-us/azure/devops/pipelines/build/variables?view=azure-devops&tabs=yaml

    $Message = @"
## $ENV:BUILD_BUILDNUMBER

[${ENV:BUILD_BUILDNUMBER}](${ENV:SYSTEM_COLLECTIONURI}${ENV:System_TeamProject}/_build/results?buildId=${ENV:BUILD_BUILDID}&view=results) _${ENV:AGENT_JOBSTATUS}_

$ENV:DD_APPEND_MESSAGE
"@
    Write-DatadogEvent -title $ENV:BUILD_BUILDNUMBER -text $Message -status $ENV:AGENT_JOBSTATUS

}
