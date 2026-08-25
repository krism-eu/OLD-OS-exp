ARG FEDORA_VERSION="${FEDORA_VERSION:-44}"
ENV FEDORA_VERSION=${FEDORA_VERSION}

FROM scratch AS ctx
COPY build_files /

FROM quay.io/fedora-ostree-desktops/base-atomic:${FEDORA_VERSION}

RUN mkdir -p /var/nix && ln -s /var/nix /nix
COPY system_files /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && /ctx/drivers.sh && /ctx/post-build.sh && /ctx/post-build-overlay.sh

RUN bootc container lint
