<#
.SYNOPSIS
    A brief description of the function or script. This keyword can be used only once in each topic.
.DESCRIPTION
    Send the start message of an action and return the info on the message so it can be updated if required
.PARAMETER thread_ts
    Timestamp of the message to be updated. (ts in slack documentation)
.PARAMETER text
    New text for the message, using the default formatting rules.
.PARAMETER Parse
    Change how messages are treated. Defaults to client, unlike chat.postMessage. See below.
.PARAMETER Parse
    Channel. Defaults to the configuration provided value by psconfig. Can override here if needed
.EXAMPLE
    PS> Update-SlackMessage
    Runs Update-SlackMessage
.LINK
    https://api.slack.com/methods/chat.update
#>
function Update-SlackMessage
{
    [CmdletBinding()]
    #[OutputType([pscustomobject[]])]
    Param (
        [Parameter(ValueFromPipelineByPropertyName)][AllowNull()]$ts,
        [Parameter(ValueFromPipelineByPropertyName)][AllowNull()]$Channel,
        [Parameter(ValueFromPipelineByPropertyName)][AllowNull()]$message,
        [Parameter(ValueFromPipelineByPropertyName)][AllowNull()]$MessageStopWatch,
        [ValidateSet('full', 'client')][string]$parse = 'full'
    )
    begin
    {
        $StopWatch = [diagnostics.stopwatch]::StartNew()
        Write-PSFMessage -Level VeryVerbose -Message ( '{0:hh\:mm\:ss\.fff} {1}: starting' -f $StopWatch.Elapsed, 'Update-SlackMessage')
    }
    process
    {
        $StopwatchProcess = [diagnostics.stopwatch]::StartNew()

        Write-PSFMessage -Level Debug -Message ( '{0:hh\:mm\:ss\.fff} {1}: process start' -f $StopwatchProcess.Elapsed, 'Update-SlackMessage')

        if (-not (Get-PSFConfigValue 'Slack.Enabled'))
        {
            Write-PSFMessage -Level Verbose -Message "Bypassing New-SlackMessage per Slack.Enabled = `$false"
            return
        }


        try { [string]$Duration = $MessageStopWatch.Elapsed.Humanize() }
        catch { Write-PSFMessage -Level Warning -Message 'Error in humanizing timestamp' }

        try
        {

            $Body = @{
                ts      = $ts
                text    = ( [string]::Concat(($message.Text -replace 'start\w*', '' -replace '^\:\w*\:', ':heavy_check_mark:'), ' ', $duration) | ConvertTo-Json -Depth 1 -Compress).Trim('"')
                parse   = 'full'
                channel = $Channel
            }
            $response = Send-SlackApi -Method chat.update -Body $body -Token (Get-PSFConfigValue 'Slack.Authentication').GetNetworkCredential().Password
            $response
            Write-PSFMessage -Level Debug -Message ( '{0:hh\:mm\:ss\.fff} {1}: process end' -f $StopwatchProcess.Elapsed, 'Update-SlackMessage')
        }
        catch
        {
            Write-PSFMessage -Level Warning -Message ( '{0:hh\:mm\:ss\.fff} {1}: error experienced' -f $StopwatchProcess.Elapsed, 'Update-SlackMessage') -Exception $_.Exception
        }
    }
    end
    {
        Write-PSFMessage -Level Verbose -Message ( '{0:hh\:mm\:ss\.fff} {1}: finished' -f $StopWatch.Elapsed, 'Update-SlackMessage')
        $StopWatch.Stop()
    }

}
