FROM debian:bullseye-slim

# 将 apt 源替换为阿里云源
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    apt-utils \
    gnupg \
    bzip2 \
    xz-utils \
    zstd \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /repo

ENTRYPOINT ["/bin/bash", "/repo/repo.sh"]
