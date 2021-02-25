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
if ([System.IO.Path]::GetFileName($MyInvocation.ScriptName) -ne 'Invoke-Build.ps1')
{
    $ErrorActionPreference = 'Stop'
    if (!(Get-Module InvokeBuild -ListAvailable))
    {
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
    $ProjectDirectory = $BuildRoot | Split-Path -Leaf
    $script:ArtifactDirectory = Join-Path $BuildRoot 'artifacts'
    $null = New-Item (Join-Path $BuildRoot 'artifacts' ) -ItemType Directory -Force -ErrorAction SilentlyContinue
    if ($LoadConstants)
    {
        $ConstantsFile = (Join-Path "${ENV:HOME}${ENV:USERPROFILE}" ".invokebuild/$ProjectDirectory.constants.ps1")
        if (Test-Path $ConstantsFile)
        {
            . $ConstantsFile
            Write-Build DarkYellow "Loaded: $ConstantsFile"
        }
        else
        {
            New-Item $ConstantsFile -ItemType File -Force
            Write-Build DarkYellow "Created Constants file $ConstantsFile"
        }
    }
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
