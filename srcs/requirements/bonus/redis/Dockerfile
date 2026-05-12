FROM debian:bookworm

RUN apk update && apk add --no-cache redis

EXPOSE 6379

ENTRYPOINT ["redis-server"]