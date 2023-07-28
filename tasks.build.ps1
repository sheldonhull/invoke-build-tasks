<#
.Description
    Initialize and build project
.Notes
    PS> New-Alias ib -value "invoke-build"
    Set this value in your profile to have a quick alias to call
#>

[cmdletbinding()]
param(
    $BuildRoot = $BuildRoot,

    $Tasks,
    [switch]$LoadConstants,
    $Configuration

)

foreach ($file in (Get-ChildItem -Path (Join-Path $BuildRoot 'build/functions') -Filter '*.ps1').FullName) { . $file }
foreach ($file in (Get-ChildItem -Path (Join-Path $BuildRoot 'build/tasks') -Filter '*.tasks.ps1' -Recurse).FullName) { . $file }

# Can handle both windows and mac if powershell core is setup on mac
if ([System.IO.Path]::GetFileName($MyInvocation.ScriptName) -ne 'Invoke-Build.ps1') {
    $ErrorActionPreference = 'Stop'
    if (!(Get-InstalledModule InvokeBuild -ErrorAction SilentlyContinue)) {
        Install-Module InvokeBuild
        'Installed and imported InvokeBuild as was not available'
    }
    Import-Module InvokeBuild
    # call Invoke-Build
    Write-Build DarkGray '===InvokeBuild Invocation === '
    Write-Build DarkGray "Invoke-Build $Tasks -File $($MyInvocation.MyCommand.Path) $($PSBoundParameters.GetEnumerator() | Format-List -Force | Out-String)"
    & Invoke-Build -Task $Tasks -File $MyInvocation.MyCommand.Path @PSBoundParameters
    return
}

###################################
# Load All Custom & Project Tasks #
###################################

Enter-Build {
    # $ProjectDirectory = $BuildRoot | Split-Path -Leaf
    $script:ArtifactDirectory = Join-Path $BuildRoot '.artifacts'
    $null = New-Item (Join-Path $BuildRoot '.artifacts' ) -ItemType Directory -Force -ErrorAction SilentlyContinue
    ## TODO: Reevaluate this approach to use something like like direnv, but in a cross-platform way, if possible. Not happy with this
    # if ($PSVersionTable.PSVersion.Major -eq 5) {
    #     $HOME = $env:USERPROFILE
    # }

    # if ($LoadConstants) {
    #     $ENV:XDG_CONFIG_HOME = $ENV:XDG_CONFIG_HOME ? $ENV:XDG_CONFIG_HOME : (Join-Path $HOME '.config')
    #     $ENV:XDG_CACHE_HOME = $ENV:XDG_CACHE_HOME ? $ENV:XDG_CACHE_HOME : (Join-Path $HOME '.cache')
    #     $ENV:XDG_DATA_HOME = $ENV:XDG_DATA_HOME ? $ENV:XDG_DATA_HOME : ($HOME, '.local', 'share' -join [IO.Path]::DirectorySeparatorChar)

    #     if (-not (Test-Path (Join-Path $ENV:XDG_CONFIG_HOME '.invokebuild')) ) {
    #         New-Item (Join-Path $ENV:XDG_CONFIG_HOME '.invokebuild') -ItemType Directory -Force -ErrorAction SilentlyContinue
    #         Write-Build DarkGray "Created: $(Join-Path $ENV:XDG_CONFIG_HOME '.invokebuild') for storing local overrides"
    #     }
    #     $ConstantsFile = Join-Path $ENV:XDG_CONFIG_HOME ".invokebuild/$ProjectDirectory.constants.ps1"
    #     if (Test-Path $ConstantsFile) {
    #         . $ConstantsFile
    #         Write-Build DarkYellow "Loaded: $ConstantsFile"
    #     }
    #     else {
    #         New-Item $ConstantsFile -ItemType File -Force
    #         Write-Build DarkYellow "Created Constants file $ConstantsFile"
    #     }
    # }
}

####################################
# Job Aliases for quick typing     #
####################################
Task tidy job-tidy
Task bootstrap job-bootstrap
Task init job-bootstrap


##################
# Standard Tasks #
##################
Task job-tidy vscode-rebuild-tasks, powershell-format-code
Task job-bootstrap clean, tidy, check-run-psdepend-install, powershell-import-requirements
# Task lint TDB

########
# CICD #
########
Task github-tidy tidy, git-commit-push
