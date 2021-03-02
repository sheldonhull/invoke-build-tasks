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
