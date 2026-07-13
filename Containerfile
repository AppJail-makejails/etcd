ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/core:${FREEBSD_RELEASE}

ARG ETCDVER
ARG NO_PKGCLEAN

LABEL org.opencontainers.image.title="etcd" \
    org.opencontainers.image.description="Highly-available key value store and service discovery" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/etcd" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/etcd" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe; \
    \
    pkg update; \
    pkg install -U coreos-etcd${ETCDVER}; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/* /var/db/pkg/repos/*; \
    fi

VOLUME ["/data"]

EXPOSE 2379 2380

COPY entrypoint.sh /

WORKDIR /data

RUN chmod +x /entrypoint.sh && \
    mkdir -p /data && \
    chmod 700 /data

ENTRYPOINT ["/entrypoint.sh"]
