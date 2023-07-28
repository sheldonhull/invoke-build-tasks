# Synopsis: install all required modules for powershell
task powershell-installmodules {
    $RequiredModules = @(
        'Pester'
        'PSScriptAnalyzer'
    )
    $RequiredModules | ForEach-Object {
        $module = $_
        if (-not (Get-InstalledModule -Name $module -ErrorAction SilentlyContinue)) {
            Write-Build DarkGray "$module module not installed, installing now"
            Install-Module -Name $module -Force -Scope CurrentUser -AllowClobber -SkipPublisherCheck
        }
    }
}