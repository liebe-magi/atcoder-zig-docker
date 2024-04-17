# Python
FROM python:3.11.4-slim-bookworm as python

# Install online-judge-tools
RUN python -m pip install online-judge-tools

# Node.js
FROM node:18.20.1-bookworm-slim as node

# Install atcoder-cli
RUN npm install -g atcoder-cli

# runner
FROM ubuntu:22.04 as runner
LABEL maintainer "liebe_magi"

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
    apt-get install -y fish g++-12 wget curl unzip ca-certificates --no-install-recommends && \
    curl -sS https://starship.rs/install.sh | sh -s -- --yes

# ac-library
RUN wget https://github.com/atcoder/ac-library/releases/download/v1.5.1/ac-library.zip -O ac-library.zip && \
    unzip ac-library.zip -d ac-library && \
    rm ac-library.zip

# boost
RUN apt-get install -y build-essential --no-install-recommends && \
    wget https://boostorg.jfrog.io/artifactory/main/release/1.82.0/source/boost_1_82_0.tar.gz -O boost_1_82_0.tar.gz && \
    tar xf boost_1_82_0.tar.gz && \
    rm boost_1_82_0.tar.gz && \
    cd boost_1_82_0 && \
    ./bootstrap.sh --with-toolset=gcc --without-libraries=mpi,graph_parallel && \
    ./b2 -j3 toolset=gcc variant=release link=static runtime-link=static cxxflags="-std=c++2b" stage && \
    ./b2 -j3 toolset=gcc variant=release link=static runtime-link=static cxxflags="-std=c++2b" --prefix=/opt/boost/gcc install && \
    cd .. && \
    rm -rf boost_1_82_0

RUN apt-get install -y libgmp3-dev libeigen3-dev=3.4.0-2ubuntu2 --no-install-recommends && \
    apt-get autoremove && \
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