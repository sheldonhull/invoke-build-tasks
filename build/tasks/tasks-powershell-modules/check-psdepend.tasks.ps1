#Synopsis: This is a very slow task. use this only if you fail to get the modules to install through other methods. This might take 10-15 mins to do what the other does in a few minutes.

check check-run-psdepend-install {
    Write-Build Gray 'Running Invoke-PSDepend'
    if (-not (Get-InstalledModule PSDepend -ErrorAction SilentlyContinue))
    {
        Write-Build Gray 'Installing PSDepend'
        Install-Module PSDepend -Scope CurrentUser -Force -AllowClobber -Confirm:$false
    }
    else
    {
        Write-Build Gray 'PSDepend already installed. Going to run installation of identified dependencies now'
    }
    try
    {
        Import-Module PSDepend -Force
    }
    catch
    {
        Write-Warning 'Issue in importing normally. Going to find the psd1 file to create correctly'
        $PSDepend = (Get-ChildItem @($ENV:PSModulePath -split ';') -Filter PSDepend.psd1 -Recurse | Sort-Object $_.CreationTime -Descending | Select-Object -First 1).FullName
        Write-Warning "Found PSDepend to import at: $PSDepend"
        Import-Module $PSDepend -Force
    }
    Invoke-PSDepend -Path (Join-Path $BuildRoot 'build') -Confirm:$false -Install -Target (Join-Path $BuildRoot 'packages/RequiredModules')
}

#Synopsis: Use the locally cached modules from prior task and load them using PSDepend
task powershell-import-requirements {
    Invoke-PSDepend -Path (Join-Path $BuildRoot 'build') -Confirm:$false -Import
    Write-Build DarkGray "$('#' * 20) LOADED MODULES`n$(Get-Module | Format-Table -AutoSize -Wrap -Property ModuleType, Version, PreRelease, Name| Out-String)`n$('#' * 20)"

}
