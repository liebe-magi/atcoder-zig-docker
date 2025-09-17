# Python
FROM python:3.11.4-slim-bookworm AS python

# Install online-judge-tools
RUN python -m pip install online-judge-tools

# Node.js
FROM node:18.20.1-bookworm-slim AS node

# Install atcoder-cli
RUN npm install -g atcoder-cli

# runner
FROM ubuntu:22.04 AS runner
LABEL maintainer="liebe_magi"

WORKDIR /opt

# Copy from Python
COPY --from=python /usr/local/include /usr/local/include
COPY --from=python /usr/local/lib /usr/local/lib
COPY --from=python /usr/local/bin /usr/local/bin

# Copy from Node.js
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/bin /usr/local/bin

# Install packages
RUN apt-get update && \
    apt-get install -y fish wget curl unzip ca-certificates git xz-utils --no-install-recommends && \
    curl -sS https://starship.rs/install.sh | sh -s -- --yes

# Install Zig
ENV AC_ZIG_VERSION=0.15.1
RUN wget -q https://ziglang.org/download/${AC_ZIG_VERSION}/zig-x86_64-linux-${AC_ZIG_VERSION}.tar.xz && \
    tar -C /opt -xf zig-x86_64-linux-${AC_ZIG_VERSION}.tar.xz && \
    ln -s /opt/zig-x86_64-linux-${AC_ZIG_VERSION}/zig /usr/local/bin/zig && \
    rm zig-x86_64-linux-${AC_ZIG_VERSION}.tar.xz

# Clean up
RUN apt-get autoremove && \
    apt-get autoclean && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user
ARG USER_ID=1000 GROUP_ID=1000
RUN groupadd -g ${GROUP_ID} user && \
    useradd -m --no-log-init --system --uid ${USER_ID} user -g user -G sudo -s /usr/bin/fish && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Change the user
USER user
WORKDIR /home/user/work

COPY --chown=${USER_ID}:${GROUP_ID} ./config.fish /home/user/.config/fish/config.fish

CMD ["/usr/bin/fish"]
