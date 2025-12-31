FROM alpine:latest

ARG TARGETARCH

WORKDIR /app

RUN apk update \
    && apk upgrade --no-cache \
    && apk add --no-cache ca-certificates ca-certificates-bundle unzip curl bash dos2unix tzdata iptables redsocks \
    && update-ca-certificates

COPY source/aarch64/Packetshare /tmp/Packetshare_arm64

COPY source/i386/Packetshare /tmp/Packetshare_amd64

RUN if [ "$TARGETARCH" = "arm64" ]; then \
        cp /tmp/Packetshare_arm64 /app/Packetshare && chmod +x /app/Packetshare; \
    elif [ "$TARGETARCH" = "amd64" ]; then \
        cp /tmp/Packetshare_amd64 /app/Packetshare && chmod +x /app/Packetshare; \
    else \
        echo "Unsupported architecture: $TARGETARCH" && exit 1; \
    fi \
    && rm -rf /tmp/Packetshare_*

RUN touch /app/.run_On_Docker

COPY entrypoint.sh /app/entrypoint.sh

RUN dos2unix /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
