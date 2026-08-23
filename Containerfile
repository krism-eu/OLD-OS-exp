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



RUN systemctl set-default graphical.target



RUN bootc container lint
