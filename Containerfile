FROM scratch AS ctx

COPY build_files /

FROM ghcr.io/krism-eu/rakuos-base:kde

COPY system_files /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    bash /ctx/build.sh && \
    bash /ctx/post-build.sh && \
    bash /ctx/post-build-overlay.sh

RUN bootc container lint

LABEL org.opencontainers.image.title="RakuOS KDE Custom"
LABEL org.opencontainers.image.description="Custom RakuOS KDE Plasma bootc image"
LABEL org.opencontainers.image.source="https://github.com/krism-eu/rakuos-kde-custom"
LABEL org.opencontainers.image.version="0.1"

CMD ["/sbin/init"]
