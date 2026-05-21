FROM ubuntu:24.04

LABEL org.opencontainers.image.title="SURIMI-terminal"
LABEL org.opencontainers.image.description="Browser terminal sidecar for SURIMI EDITO catalog services. ttyd + tmux + kubectl + helm + bash. Used as a co-pod with SURIMI-mcp for in-cluster admin and debugging."
LABEL org.opencontainers.image.source="https://github.com/Official-EwE/SURIMI-terminal"
LABEL org.opencontainers.image.url="https://www.surimi-project.eu/"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.vendor="SURIMI Project"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends \
    ttyd tmux htop curl wget git ca-certificates openssh-server sudo \
    python3 python3-pip jq dnsutils net-tools iputils-ping vim-tiny \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

RUN useradd -m -s /bin/bash onyxia \
    && echo "onyxia ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/onyxia \
    && mkdir -p /run/sshd /home/onyxia/.ssh \
    && ssh-keygen -A \
    && printf 'set -g mouse on\nset -g history-limit 50000\nset -g default-terminal "screen-256color"\n' > /home/onyxia/.tmux.conf \
    && chown -R onyxia:onyxia /home/onyxia

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 7681 22

ENTRYPOINT ["/entrypoint.sh"]
