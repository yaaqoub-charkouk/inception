FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN wget https://github.com/portainer/portainer/releases/download/2.27.9/portainer-2.27.9-linux-amd64.tar.gz && \
    tar -xzf portainer-2.27.9-linux-amd64.tar.gz && \
    rm portainer-2.27.9-linux-amd64.tar.gz

EXPOSE 9443

ENTRYPOINT ["/opt/portainer/portainer"]