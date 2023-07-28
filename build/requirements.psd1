@{
    psdepend                            = 'latest'
    PsDependoptions                     = @{
        Version = 'Latest'
        Target  = 'currentuser'
    }

    # 'PSGalleryModule::AWS.Tools.Common'                  = 'latest'
    # 'PSGalleryModule::AWS.Tools.EC2'                     = 'latest'
    # 'PSGalleryModule::AWS.Tools.SimpleSystemsManagement' = 'latest'
    'PSGalleryModule::PSReadLine'       = 'latest'
    'PSGalleryModule::PSScriptAnalyzer' = 'latest'
    'PSGalleryModule::Pester'           = 'latest'
    'PSGalleryModule::PSFramework'      = 'latest'

    # 'PSGalleryModule::PSGitHub'                          = 'latest'
    # 'PSGalleryModule::PSTeams'                           = 'latest'
    # 'PSGalleryModule::PSTeams'                           = 'latest'
    # 'PSGalleryModule::PSSlack'                           = 'latest'
    # 'PSGalleryModule::AWS.Tools.Installer'      = 'latest'
    # 'EnsureRequiredAWSToolsModulesAreInstalled' = @{
    #     DependencyType = 'Command'
    #     Source         = "Install-AWSToolsModule 'AWS.Tools.Common', 'AWS.Tools.EC2','AWS.Tools.SimpleSystemsManagement' -MinimumVersion 4.0.6 -CleanUp -Confirm:`$false -Scope CurrentUser -SkipPublisherCheck -AllowClobber"
    #     DependsOn      = 'AWS.Tools.Installer'
    # }
}
