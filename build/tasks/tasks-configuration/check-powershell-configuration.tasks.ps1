##########################################################################
# List Any Composite "Jobs" for this category at the top for easy review #
##########################################################################

#Synopsis: Ensure that PSGallery is marked as trusted. Additionally remove PowerShellGet\1.0.0.1 as causes issues with PowerShellGet parameters if imports by accident
task check_powershell_configuration {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Write-Build DarkYellow "Removing prebuilt powershellget 1.0.0.1 as this causes issues in new environments"
    remove "C:\Program Files\WindowsPowerShell\Modules\PowerShellGet\1.0.0.1"
}
