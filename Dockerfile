# Python
FROM python:3.13.7-slim-trixie AS python

# Install online-judge-tools
RUN python -m pip install online-judge-tools aclogin

# Node.js
FROM node:24.8.0-trixie-slim AS node

# Install atcoder-cli
RUN npm install -g atcoder-cli

# runner
FROM ubuntu:24.04 AS runner
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
RUN apt-get update && apt-get install -y sudo --no-install-recommends && \
    useradd -m --uid 1001 --shell /usr/bin/fish user && \
    usermod -aG sudo user && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Change the user
USER user
WORKDIR /home/user/work

COPY --chown=user:user ./config.fish /home/user/.config/fish/config.fish

CMD ["/usr/bin/fish"]
