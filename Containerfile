ARG FEDORA_VERSION=44

FROM quay.io/bootc-devel/fedora-bootc-${FEDORA_VERSION}-minimal

LABEL org.opencontainers.image.title="RakuOS Base"
LABEL org.opencontainers.image.description="Minimal Fedora bootc base for RakuOS"
LABEL org.opencontainers.image.source="https://github.com/krism-eu/rakuos-base"

RUN dnf5 -y \
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
    && dnf5 clean all \
    && rm -rf \
        /var/cache/dnf \
        /var/cache/libdnf5 \
        /var/log/dnf5.log \
        /run/dnf \
        /run/mdadm

RUN systemctl set-default graphical.target

RUN bootc container lint

LABEL org.opencontainers.image.version="0.1"

CMD ["/sbin/init"]
