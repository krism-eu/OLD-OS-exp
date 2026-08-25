ARG BASE_IMAGE_TAG="${BASE_IMAGE_TAG:-latest}"

FROM scratch AS ctx
COPY build_files /
COPY protected-packages.txt /

FROM ghcr.io/rakuos/rakuos-base:${BASE_IMAGE_TAG}

LABEL org.opencontainers.image.title="myrakuOS KDE Plasma"
LABEL org.opencontainers.image.description="KDE Plasma slim su RakuOS (AMD)"
LABEL org.opencontainers.image.version="1.0"

COPY system_files /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache/dnf,sharing=locked \
    --mount=type=cache,dst=/var/lib/dnf,sharing=locked \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    /ctx/post-build.sh && \
    /ctx/post-build-overlay.sh

RUN bootc container lint
