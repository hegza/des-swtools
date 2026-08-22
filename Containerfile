FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/root/.cargo/bin:${PATH}"

# Install required system packages
RUN apt update \
    && apt install --no-install-recommends -y \
        build-essential \
        ca-certificates \
        curl \
        git \
        libssl-dev \
        libudev-dev \
        pkg-config

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
        | sh -s -- -y --profile minimal \
    && rustup default stable

# Install target programming tools
RUN cargo install --locked esp-generate espflash espmonitor ldproxy

# Get rid of unnecessary extras
RUN rm -rf /var/lib/apt/lists/* \
    && rm -rf /root/.cargo/registry /root/.cargo/git

WORKDIR /workspace

CMD ["bash"]