FROM nikolaik/python-nodejs:python3.11-nodejs20-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    jq \
    sudo \
    ca-certificates \
    gnupg \
    nano \
    vim \
    less \
    && mkdir -p -m 755 /etc/apt/keyrings \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir google-generativeai google-genai requests beautifulsoup4

RUN npm install -g @google/gemini-cli

RUN export TARGET_USER=$(getent passwd 1000 | cut -d: -f1) \
    && echo "${TARGET_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && mkdir -p /app/workspace \
    && chown -R ${TARGET_USER}:${TARGET_USER} /app

COPY --chown=1000:1000 entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

USER 1000
ENV EDITOR=nano
WORKDIR /app/workspace

ENTRYPOINT ["entrypoint.sh"]
CMD ["/bin/bash"]
