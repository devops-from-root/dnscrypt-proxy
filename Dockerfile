FROM debian:latest

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y curl tar gzip netcat-openbsd dnsutils \
 && rm -rf /var/lib/apt/lists/* \
 && curl -s https://api.github.com/repos/DNSCrypt/dnscrypt-proxy/releases/latest \
    | grep -oP '"browser_download_url": "\K(.*?dnscrypt-proxy-linux_x86_64-.*?\.gz)(?=")' \
    | head -n 1 \
    | xargs -I{} curl -L -o /tmp/dnscrypt-proxy.gz {} \
 && tar -xzf /tmp/dnscrypt-proxy.gz -C /opt \
 && mv /opt/linux-x86_64 /opt/dnscrypt-proxy \
 && rm /tmp/dnscrypt-proxy.gz

WORKDIR /opt/dnscrypt-proxy

ENTRYPOINT ["./dnscrypt-proxy", "-config", "example-dnscrypt-proxy.toml"]
