##########################################################################
# List Any Composite "Jobs" for this category at the top for easy review #
##########################################################################
Task job-docker-codespaces-rebuild @{
    Jobs = 'docker-codespaces-pull', 'docker-codespaces-build'
}
#Synopsis: Pull latest docker image for codespace
Task docker-codespaces-pull {
    &docker --pull -f '.devcontainer/Dockerfile'
}

#Synposis: Run docker build to ensure codespace container can be successfully built by docker
Task docker-codespaces-build {
    &docker build --pull --rm -f '.devcontainer/Dockerfile' -t invokebuildtasks:latest '.devcontainer'
}
