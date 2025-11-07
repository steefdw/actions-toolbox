FROM debian:stable-20251020-slim

RUN apt-get update  \
    && apt-get -y --no-install-recommends install \
        sudo curl git ca-certificates build-essential \
    && rm -rf /var/lib/apt/lists/*

ARG USERNAME=toolbox
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV MISE_DATA_DIR="/mise"
ENV MISE_CONFIG_DIR="/mise"
ENV MISE_CACHE_DIR="/mise/cache"
ENV MISE_INSTALL_PATH="/usr/local/bin/mise"
ENV MISE_TRUSTED_CONFIG_PATHS="/"
ENV PATH="/mise/shims:$PATH"
ENV MISE_VERSION="v2025.10.21"

RUN curl https://mise.run | sh
#An alternative to calling curl https://mise.run | sh is to use mise generate bootstrap to generate a script that runs and install mise.
#> mise generate bootstrap -l -w

# see https://mise.jdx.dev/continuous-integration.html
#
#Add the .mise/ to your .gitignore and commit the generated ./bin/mise file. You can now use ./bin/mise to install and run mise directly in CI.
#
#script: |
#  ./bin/mise install
#  ./bin/mise x -- npm test

USER $USERNAME
