##########################################################################
# List Any Composite "Jobs" for this category at the top for easy review #
##########################################################################

#Synopsis: Ensure that PSGallery is marked as trusted. Additionally remove PowerShellGet\1.0.0.1 as causes issues with PowerShellGet parameters if imports by accident
task check_powershell_configuration {


    if (-not $WhatIf ) #$PSCmdlet.ShouldProcess("Install-PackageProvider -Name Nuget -Scope AllUsers -Force -MinimumVersion 2.8.5.201")
    {
        $null = Install-PackageProvider -Name Nuget -Scope AllUsers -Force -MinimumVersion 2.8.5.201 -Confirm:$false
    }


    #----------------------------------------------------------------------------#
    #                     Up to Date PowershellGet Installed                     #
    #----------------------------------------------------------------------------#
    $InstalledPowershellGet = Get-Module PowershellGet -ListAvailable | Sort-Object Version | Select-Object -First 1
    if (-not $WhatIf ) #$PSCmdlet.ShouldProcess("Install-Module PowershellGet -Force -Scope AllUsers -AllowClobber")
    {
        if ($InstalledPowershelLGet.Version -lt [Version]::New(2, 2, 3))
        {
            Install-Module PowershellGet -Scope AllUsers -Force -AllowClobber
            Import-Module PowershellGet -MinimumVersion '2.2.3' -Force -Verbose
        }
    }
    if (-not $WhatIf ) #$PSCmdlet.ShouldProcess("Enable-PSRemoting -Force")
    {
        Enable-PSRemoting -Force
    }
    if (-not $WhatIf ) #$PSCmdlet.ShouldProcess("Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force")
    {
        Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force -ErrorAction SilentlyContinue # Process Scope will cause error, so supressing this from output
    }
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    # Write-Build DarkYellow "Removing prebuilt powershellget 1.0.0.1 as this causes issues in new environments"
    # remove "C:\Program Files\WindowsPowerShell\Modules\PowerShellGet\1.0.0.1"
}
