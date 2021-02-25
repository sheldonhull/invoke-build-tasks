# Synopsis: Generate an asciidoc file of the build tasks included in this project for friendly reference and review.
Task docs-generate-invoke-build-docs {
    ## $result =  Invoke-Build ? -File (Join-Path $BuildRoot '/build/tasks.build.ps1'
    $null = New-Item (Join-Path $BuildRoot 'docs') -ItemType Directory -Force
    $result = Invoke-Build ? -File (Join-Path $BuildRoot 'tasks.build.ps1')
    $TargetFile = Join-Path $BuildRoot 'docs/task-helper-docs.adoc'
    [string[]]$output = $result | Sort-Object Jobs -Descending | ForEach-Object {
        $i = $_
        "|$($i.Jobs.Count -gt 1)|$($i.Name)|$($i.Synopsis)|$(($i.Jobs.Count -ge 2) ? ($i.Jobs -join ',') : '')"
    }

    '= Task Helper Reference' | Out-File $TargetFile -Force

    @'

This is a reference for what tasks are included in this project that can be invoked easily by Task Explorer in Visual Studio Code or by running:

== More Detail

[source,powershell]
----
Invoke-Build ./build/build.ps1 -Task Tidy
----

[cols=4]
[%header]
[caption="Invoke Build Tasks "]
|===
|Is This A Job|Task Name|Task Description|Task List
'@ | Out-File $TargetFile -Append
    $output -join "`n" | Out-File $TargetFile -Append

    '|===' | Out-File $TargetFile -Append
}
