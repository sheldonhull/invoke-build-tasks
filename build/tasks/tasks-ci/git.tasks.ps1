#Synopsis: Run quick commit action, for example, to allow updated formatting to be reapplied by CICD tool to all files after check-in, even if someone forgot to run this manually.
Task git-commit-push {
    git commit -am"ci: [$(git branch --show-current)] ci commit"
    git push
}
#Synopsis: used for quick fixes to existing commit
task git-add-fixup {
    # add this git alias    fixup = "!f() { TARGET=$(git rev-parse "$1"); git commit --fixup=$TARGET ${@:2} && EDITOR=true git rebase -i --autostash --autosquash $TARGET^; }; f"
    # https://blog.filippo.io/git-fixup-amending-an-older-commit/
    git add .
    git commit --fixup
}

#Synopsis: quick commit and push. Use git town ideally
task git_quick_commit_and_push {
    Write-Build Gray 'Quick Commit for Personal Branch [before merge squash and cleanup]'
    git add .
    git commit -am"$(git branch --show-current) : $((Invoke-Generate '[adjective]-[noun]').ToLower()) : dev commit #tobesquashed"
    git pull --rebase
    git push
    Write-Build Gray 'All your work has been pushed to current branch'
}

#Synopsis: If the CI job has changes, this will allow the CI job to commit back those linting or build artifacts to the job
Task git-ci-commit-push {
    Write-Build DarkGray ''
    $UserName = $(git log -1 --pretty=format:"%an")
    $UserEmail = $(git log -1 --pretty=format:"%ae")

    Write-Build Green "`$UserName    : [$UserName]"
    Write-Build Green "`$UserEmail   : [$UserEmail]"

    $status = git status --porcelain
    Write-Build DarkGray "Status: `t[`n`t$($status -split '  ' -join "`n`t")`n]"
    if (-not $status)
    {
        Write-Build DarkYellow 'No changes detected for ci, exiting task'
        return
    }


    git add .
    git -c user.name="$UserName" -c user.email="$UserEmail" commit -m"ci: agent automated commit [ci skip]"
    $BranchRef = $ENV:BUILD_SOURCEBRANCH ?? $(git branch --show-current)

    Write-Build Green "Current BranchRef: $BranchRef"
    if ($ENV:BUILD_SOURCEBRANCH)
    {
        Write-Build DarkGray "running push from detatched head with following command: git push $ENV:BUILD_REPOSITORY_URI HEAD:refs/heads/$ENV:BUILD_SOURCEBRANCHNAME"
        git push $ENV:BUILD_REPOSITORY_URI HEAD:refs/heads/$ENV:BUILD_SOURCEBRANCHNAME
        return
    }
    git push

}
