# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.158.0/containers/codespaces-linux/.devcontainer/base.Dockerfile
FROM homebrew/brew:latest AS DOCKERBREW
FROM mcr.microsoft.com/vscode/devcontainers/universal:1-focal AS BASE
ARG USERNAME="codespace"
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
COPY --from=DOCKERBREW /home/linuxbrew/.linuxbrew /usr/local/bin/brew


USER root
RUN chmod -R a+rwx /usr/local/bin/brew
USER $USERNAME
ENV PATH="/usr/local/bin/brew/bin:${PATH}"
RUN echo "Verifying brew installed" && brew --version

RUN sudo sh -c "$(curl -ssL https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

RUN mkdir -p /home/$USERNAME/.vscode-server/extensions \
        /home/$USERNAME/.vscode-server/extensions \
    && chown -R $USERNAME \
        /home/$USERNAME/.vscode-server \
        /home/$USERNAME/.vscode-server

# Task Is a CLI Tool cross platform compatible alternative to Make
RUN sudo sh -c "$(curl -ssL https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

#ENV SHELL=/opt/microsoft/powershell/7/pwsh
# needs github token
#RUN curl -s "https://raw.githubusercontent.com/owenrumney/squealer/main/scripts/install.sh" | bash
