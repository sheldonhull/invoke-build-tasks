# Synopsis: Build tasks for vscode task explorer
Task vscode-rebuild-tasks {
    if (-not (Get-InstalledScript 'New-VSCodeTask' -ErrorAction SilentlyContinue))
    {
        Write-Build DarkGray 'Installing New-VscodeTask'
        Install-Script -Name New-VsCodeTask -Force -Confirm:$false -Scope CurrentUser
    }
    #New-VSCodeTask.ps1 -BuildFile 'tasks.build.ps1' -Shell 'pwsh' #-WhereTask{ $_.Jobs.Count -gt 1 }
    . (Join-Path (Get-InstalledScript 'New-VSCodeTask').InstalledLocation 'New-VSCodeTask.ps1') -BuildFile ./task.build.ps1 -Shell 'pwsh' #-WhereTask{ $_.Jobs.Count -gt 1 }
    $TasksJsonFile = Join-Path $BuildRoot '.vscode\tasks.json'
    $Content = Get-Content $TasksJsonFile -Raw
    $NewContent = $Content.Replace('"command": "Invoke-Build -Task', '"command": "./build.ps1 -LoadConstants -Task')
    $UTF8NoBOM = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllLines($TasksJsonFile, $NewContent, $UTF8NoBOM)
}
