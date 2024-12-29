ARG VARIANT=1.23-bookworm
FROM mcr.microsoft.com/devcontainers/go:${VARIANT}

RUN set -e; \
    su vscode -c "mkdir -p /home/vscode/.vscode-server /home/vscode/.vscode-server-insiders"; \
    go install github.com/cweill/gotests/gotests@latest; \
    go install github.com/fatindeed/dotfiles-go/dotfiles@latest;