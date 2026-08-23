ARG FEDORA_VERSION=44

FROM quay.io/bootc-devel/fedora-bootc-44-minimal

LABEL org.opencontainers.image.title="RakuOS Base"
LABEL org.opencontainers.image.description="Minimal Fedora bootc base for RakuOS"
LABEL org.opencontainers.image.source="https://github.com/krism-eu/rakuos-base"

RUN dnf -y \
        --setopt=install_weak_deps=false \
        install \
        NetworkManager \
        udisks2 \
        linux-firmware \
        glibc-langpack-en \
        glibc-langpack-it \
        pipewire \
        pipewire-alsa \
        pipewire-pulseaudio \
        wireplumber \
        mt7xxx-firmware \
        mesa-vulkan-drivers \
        mesa-va-drivers \
        podman \
        bash-completion \
        fzf \
        openssh-server \
    && dnf clean all \
    && rm -rf /var/cache/dnf

COPY system_files /

RUN find /usr/libexec/rakuos -type f -exec chmod 0755 {} \; 2>/dev/null || true
RUN chmod 0755 /usr/bin/rakuos 2>/dev/null || true

RUN systemctl set-default graphical.target

COPY build_files/validate.sh /usr/local/libexec/rakuos-base-validate
RUN chmod 0755 /usr/local/libexec/rakuos-base-validate

RUN /usr/local/libexec/rakuos-base-validate

RUN bootc container lint
