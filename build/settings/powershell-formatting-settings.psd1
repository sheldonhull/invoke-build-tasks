@{
    # IncludeRules = @(
    #     'PSPlaceOpenBrace',
    #     'PSPlaceCloseBrace',
    #     'PSUseConsistentWhitespace',
    #     'PSUseConsistentIndentation',
    #     'PSAlignAssignmentStatement'
    # )
    # Only diagnostic records of the specified severity will be generated.
    # Uncomment the following line if you only want Errors and Warnings but
    # not Information diagnostic records.
    #Severity = @('Error','Warning')
    # Analyze **only** the following rules. Use IncludeRules when you want
    # to invoke only a small subset of the defualt rules.
    # IncludeRules = @(
    #     'PSAvoidDefaultValueSwitchParameter',
    #     'PSMisleadingBacktick',
    #     'PSMissingModuleManifestField',
    #     'PSReservedCmdletChar',
    #     'PSReservedParams',
    #     'PSShouldProcess',
    #     'PSUseApprovedVerbs',
    #     'PSAvoidUsingCmdletAliases',
    #     'PSUseDeclaredVarsMoreThanAssignments'
    # )
    # Do not analyze the following rules. Use ExcludeRules when you have
    # commented out the IncludeRules settings above and want to include all
    # the default rules except for those you exclude below.
    # Note: if a rule is in both IncludeRules and ExcludeRules, the rule
    # will be excluded.
    ExcludeRules = @(
        #'PSAvoidGlobalVars',
        'PSAvoidUsingWriteHost',
        'PSAvoidUsingUserNameAndPassWordParams',
        'PSAvoidUsingConvertToSecureStringWithPlainText'
    )
       # You can use rule configuration to configure rules that support it:
    #Rules = @{
    # PSAvoidUsingCmdletAliases = @{
    # Whitelist = @("cd")
    # }
    #}
    Rules        = @{
        PSPlaceOpenBrace           = @{
            Enable             = $true
            OnSameLine         = $false
            NewLineAfter       = $true
            IgnoreOneLineBlock = $true
        }

        PSPlaceCloseBrace          = @{
            Enable             = $true
            NewLineAfter       = $true
            IgnoreOneLineBlock = $true
            NoEmptyLineBefore  = $false
        }

        PSUseConsistentIndentation = @{
            Enable          = $true
            Kind            = 'space'
            IndentationSize = 4
        }

        PSUseConsistentWhitespace  = @{
            Enable         = $true
            CheckOpenBrace = $true
            CheckOpenParen = $true
            CheckOperator  = $true
            CheckSeparator = $true
        }

        PSAlignAssignmentStatement = @{
            Enable         = $true
            CheckHashtable = $true
        }
    }
}
