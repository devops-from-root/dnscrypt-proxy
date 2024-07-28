FROM ghcr.io/devops-from-root/alpine:main
#FROM debian:latest

RUN apk update \
 && apk add --no-cache curl grep tar gzip netcat-openbsd bind-tools
#RUN apt-get update \
# && DEBIAN_FRONTEND=noninteractive apt-get install -y curl tar gzip netcat-openbsd dnsutils \
# && rm -rf /var/lib/apt/lists/*
 
RUN curl -s https://api.github.com/repos/DNSCrypt/dnscrypt-proxy/releases/latest \
    | grep -oP '"browser_download_url": "\K(.*?dnscrypt-proxy-linux_x86_64-.*?\.gz)(?=")' \
    | head -n 1 \
    | xargs -I{} curl -L -o /tmp/dnscrypt-proxy.gz {} \
 && tar -xzf /tmp/dnscrypt-proxy.gz -C /opt \
 && mv /opt/linux-x86_64 /opt/dnscrypt-proxy \
 && rm /tmp/dnscrypt-proxy.gz

WORKDIR /opt/dnscrypt-proxy

RUN cp example-dnscrypt-proxy.toml dnscrypt-proxy.toml \
 && sed -i "s/listen_addresses = \['127.0.0.1:53'\]/listen_addresses = \['0.0.0.0:53'\]/" dnscrypt-proxy.toml

ENTRYPOINT ["./dnscrypt-proxy", "-config", "dnscrypt-proxy.toml"]
