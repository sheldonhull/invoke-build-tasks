# PSScriptAnalyzerSettings.psd1
@{
    #Severity     = @('Error', 'Warning')

    ExcludeRules = @(
        'PSAvoidUsingCmdletAliases',
        'PSAvoidUsingWriteHost' #This is ok per using invokebuild, don't want to avoid this for now
    )
}
