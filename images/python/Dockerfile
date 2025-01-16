ARG VARIANT=3-bookworm
FROM mcr.microsoft.com/devcontainers/python:${VARIANT}

RUN set -e; \
    su vscode -c "mkdir -p /home/vscode/.vscode-server /home/vscode/.vscode-server-insiders"; \
    apt-get update; \
    apt-get install -y --upgrade --no-install-recommends ca-certificates; \
    rm -rf /var/lib/apt/lists/*; \
    pip3 --disable-pip-version-check --no-cache-dir install poetry; \
    curl -sSL https://github.com/fatindeed/dotfiles-go/raw/main/install.sh | bash;