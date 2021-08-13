<#
.SYNOPSIS
    A brief description of the function or script. This keyword can be used only once in each topic.
.DESCRIPTION
    Send the start message of an action and return the info on the message so it can be updated if required
.PARAMETER Text
    Message to log
.PARAMETER Single
    Don't include the white check mark at beginning for status updates

.EXAMPLE
    PS> New-SlackMessage
    Runs New-SlackMessage

#>
function New-SlackMessage
{
    [CmdletBinding()]
    #[OutputType([pscustomobject[]])]
    Param (
        [Parameter(mandatory)][string]$Text
        , [switch]$Single
    )

    begin
    {
        $StopWatch = [diagnostics.stopwatch]::StartNew()
        Write-PSFMessage -Level VeryVerbose -Message ( '{0:hh\:mm\:ss\.fff} {1}: starting' -f $StopWatch.Elapsed, 'New-SlackMessage')
    }
    process
    {
        if (-not (Get-PSFConfigValue 'Slack.Enabled'))
        {
            Write-PSFMessage -Level Verbose -Message "Bypassing New-SlackMessage per Slack.Enabled = `$false"
            return
        }

        try
        {
            $StopwatchProcess = [diagnostics.stopwatch]::StartNew()
            Write-PSFMessage -Level Debug -Message ( '{0:hh\:mm\:ss\.fff} {1}: process start' -f $StopwatchProcess.Elapsed, 'New-SlackMessage')
            $blocks = @()
            $body = @{ }
            # if ($ENV:BUILD_BUILDID -and $ENV:BUILD_BUILDNUMBER)
            # {
            #     Write-PSFMessage -Level Verbose -Message "Identified running in azure devops pipeline. Constructing context from $ENV:BUILD_BUILDID and $ENV:BUILD_BUILDNUMBER)"
            #     $blocks = @(
            #         [pscustomobject]@{
            #             type = 'section'
            #             text =
            #             [pscustomobject]@{
            #                 type = 'mrkdwn'
            #                 text = [string](("{0}$Text" -f @(':white_check_mark: ', '')[[bool]$Single])).Trim('"')
            #             }

            #         }

            #         [pscustomobject]@{
            #             type     = 'context'
            #             elements = @(
            #                 [pscustomobject]@{
            #                     type = 'mrkdwn'
            #                     text = "<BUILDURL>"
            #                 }
            #             )
            #         }
            #     )
            #     Write-PSFMessage -Level Debug -Message "----- Blocks Property`n -----$($Blocks | Format-List -Force | Out-String)"
            # }
            $Body.Add('channel', (Get-PSFConfigValue 'Slack.Channel'))
            $Body.Add('parse', 'full')


            # if ($ENV:BUILD_BUILDID -and $ENV:BUILD_BUILDNUMBER)
            # {
            #     Write-PSFMessage -Level Verbose -Message "Identified running in azure devops pipeline. Ang context block with link to build"
            #     $Body.Add('blocks', ("[$($blocks | ConvertTo-Json -Depth 3)]").Replace('[[', '[').Replace(']]', ']'))
            # }
            # else
            # {
            #   $Body.Add('text', (("{0}$Text" -f @(':white_check_mark: ', '')[[bool]$Single]) ).Trim('"'))
            # }


            if ($single)
            {
                $Body.Add('text', ((":information_source: $Text").Trim('"')))
            }
            else
            {
                $Body.Add('text', ((":white_check_mark: $Text" ).Trim('"')))
            }
            Write-PSFMessage -Level Debug -Message "----- Body Of Request ----- `n$($Body | Format-List -Force | Out-String)"
            $response = Send-SlackApi -Method chat.postMessage -Body $body -Token (Get-PSFConfigValue 'Slack.Authentication').GetNetworkCredential().Password



            if (-not $Single)
            {
                $response | Add-Member -NotePropertyName MessageStopWatch -NotePropertyValue ([diagnostics.stopwatch]::StartNew())
            }
            $response
            Write-PSFMessage -Level Debug -Message ( '{0:hh\:mm\:ss\.fff} {1}: process end' -f $StopwatchProcess.Elapsed, 'New-SlackMessage')
        }
        catch
        {
            Write-PSFMessage -Level Warning -Message ( '{0:hh\:mm\:ss\.fff} {1}: error experienced' -f $StopwatchProcess.Elapsed, 'New-SlackMessage') -Exception $_.Exception
        }
    }
    end
    {
        Write-PSFMessage -Level Verbose -Message ( '{0:hh\:mm\:ss\.fff} {1}: finished' -f $StopWatch.Elapsed, 'New-SlackMessage')
        $StopWatch.Stop()
    }
}
