<#
.Description
    Combination of:
    - https://github.com/nightroman/Invoke-Build/wiki/Build-Analysis
    - https://github.com/HowellIT/PSPDFGen/blob/master/build.ps1
    #>

[cmdletbinding()]
param(
    [string[]]$Tasks = '.'

    , [switch]$LoadConstants
    , $File
    , $Configuration

)
($File) ? ( Join-Path $PSScriptRoot 'tasks.build.ps1') : (Write-Verbose "Task File Override: '$File'")

$DependentModules = @('InvokeBuild', 'PSGitHub', 'NameIt') # add pester when pester tests are added
Foreach ($Module in $DependentModules)
{
    If (-not (Get-InstalledModule $module -ErrorAction SilentlyContinue))
    {
        Install-Module -Name $Module -Scope CurrentUser -Force -Confirm:$false
    }
    Import-Module $module -ErrorAction Stop -Force
}

# Builds the module by invoking psake on the build.psake.ps1 script.
# $OptionalArgs = @{}
# if ()
# {
#     Write-Host "OptionalArg provided: [] setting to []"
#     $OptionalArgs.Add('', )
# }

Invoke-Build -File $File -Result Result -Task $Tasks -LoadConstants:$LoadConstants -Configuration $Configuration @OptionalArgs

# Show invoked tasks ordered by Elapsed with ScriptName included
$Result.Tasks |
    Sort-Object Elapsed |
    Format-Table -AutoSize Elapsed, @{
        Name       = 'Task'
        Expression = { $_.Name + ' @ ' + $_.InvocationInfo.ScriptName }
    }
