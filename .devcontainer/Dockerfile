# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.158.0/containers/codespaces-linux/.devcontainer/base.Dockerfile
FROM homebrew/brew:latest AS DOCKERBREW
FROM mcr.microsoft.com/vscode/devcontainers/universal:1-focal AS BASE

# ** [Optional] Uncomment this section to install additional packages. **
# USER root
#
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>
#
# USER codespace
USER root
RUN useradd -m -s /bin/bash linuxbrew && \
    echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

USER linuxbrew
COPY --from=DOCKERBREW /home/linuxbrew/.linuxbrew /home/linuxbrew/.linuxbrew

USER codespace
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
RUN echo "Verifying brew installed" && brew --version
RUN curl -s "https://raw.githubusercontent.com/owenrumney/squealer/main/scripts/install.sh" | bash
ENV SHELL=/opt/microsoft/powershell/7/pwsh
