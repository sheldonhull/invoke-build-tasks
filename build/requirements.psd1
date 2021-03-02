@{
    psdepend                                    = 'latest'
    PsDependoptions                             = @{
        Version = 'Latest'
        Target  = 'currentuser'
    }
    'PSGalleryModule::AWS.Tools.Installer'      = 'latest'
    'PSGalleryModule::PSReadLine'               = 'latest'
    'PSGalleryModule::PSScriptAnalyzer'         = 'latest'
    'PSGalleryModule::Pester'                   = 'latest'
    'PSGalleryModule::PSGitHub'                 = 'latest'
    'PSGalleryModule::PSFramework'              = 'latest'
    'PSGalleryModule::PSTeams'                  = 'latest'
    # 'EnsureRequiredAWSToolsModulesAreInstalled' = @{
    #     DependencyType = 'Command'
    #     Source         = "Install-AWSToolsModule 'AWS.Tools.Common', 'AWS.Tools.EC2','AWS.Tools.SimpleSystemsManagement' -MinimumVersion 4.0.6 -CleanUp -Confirm:`$false -Scope CurrentUser"
    #     DependsOn      = 'AWS.Tools.Installer'
    # }
}
