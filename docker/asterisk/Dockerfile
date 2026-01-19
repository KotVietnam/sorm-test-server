FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        asterisk \
        asterisk-ooh323 \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 5060/udp 5060/tcp 1720/tcp 4569/udp 2427/udp 2000/tcp 10000-10050/udp

CMD ["asterisk", "-f"]
