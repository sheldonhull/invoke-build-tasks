# Synopsis: Use docker driven command to generate a changelog that takes into account the pull request history to build a changelog markdown file
task changelog-github {

    docker run -it -e CHANGELOG_GITHUB_TOKEN=$ENV:GITHUB_TOKEN --rm -v ${pwd}:/usr/local/src/your-app ferrarimarco/github-changelog-generator --user $ENV:GITHUB_ORG --project $ENV:REPO

}
