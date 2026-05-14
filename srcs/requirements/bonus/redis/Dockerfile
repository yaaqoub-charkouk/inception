FROM debian:bookworm

RUN apt-get update && apt-get install -y redis-server && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 6379

ENTRYPOINT ["redis-server", "--protected-mode", "no"]
