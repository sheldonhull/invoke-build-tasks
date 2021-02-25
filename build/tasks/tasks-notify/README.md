## Tasks Notify


## Datadog Example

With Azure Pipelines, this could be called like below, noting that you'd want to provide a sensitive environment variable into the task for it to be visible.

```yaml
- task: PowerShell@2
    displayName: Send Datadog Final Result
    inputs:
        filePath: build.ps1
        arguments: '-Task notify-datadog -Configuration ${{ parameters.CONFIGURATION }}'
        errorActionPreference: 'Continue'
        pwsh: true
        failOnStderr: true
    condition: always()
    env:
        DD_API_KEY: $(DD_API_KEY)
        DD_APPEND_MESSAGE: |
            finished azure-pipelines

            Special Comment and Parameter value: `${{ parameters.CONFIGURATION }}`
```
