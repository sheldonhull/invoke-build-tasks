#Synopsis: Bootstrap all the required dependencies
check check-powershell-modules {
    Write-Build Gray 'Running Invoke-PSDepend'
    if (-not (Get-InstalledModule PSDepend -ListAvailable -ErrorAction SilentlyContinue))
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
    Invoke-PSDepend -Path $BuildRoot -Confirm:$false -Install
}

#Synopsis: manually run through PSDepend config and load modules. This can be faster than PSDepend at times
task load-powershell-modules {

    $manifest = ((Get-Content requirements.psd1) -join "`n") | Invoke-Expression
    $RequiredModules = $manifest.GetEnumerator().Where{ $_.Key -notmatch 'PSDependOptions' }.ForEach{
        $m = $_
        @{
            Name           = $m.key
            MinimumVersion = $m.value
        }
    }
    $StopWatchModuleLoad = [diagnostics.stopwatch]::StartNew()
    $RequiredModules | ForEach-Object {
        [void]$StopWatchModuleLoad.Restart()
        $m = $_
        $module = Get-InstalledModule @m -ErrorAction SilentlyContinue

        if (-not $module)
        {
            Write-Host -NoNewline "$($m.Name) not installed, installing now..." -ForegroundColor DarkYellow
            $null = Install-Module @m -Repository PSGallery -Scope CurrentUser -Force -AllowClobber
            Write-Host 'installed' -NoNewline -ForegroundColor Green
        }
        else
        {
            Write-Host "$($m.name) Module $($m.MinimumVersion)" -ForegroundColor Gray -NoNewline
            Write-Host -NoNewline '...' -ForegroundColor DarkYellow
            try
            {
                Import-Module @m -Force -ErrorAction Continue -Scope Global #To speed up installation from other custom galleries
            }
            catch
            {
                Write-Warning "$($m.Name) // $($M.MinimumVersion) // warning: $($_.Exception.Message)"
            }
            Write-Host 'imported' -NoNewline -ForegroundColor Green
        }
        Write-Host ('...{0:mm\:ss\.fff}' -f $StopWatchModuleLoad.Elapsed) -ForegroundColor Green
    }
    [void]$StopWatchModuleLoad.Stop()
}
