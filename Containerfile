FROM ghcr.io/krism-eu/rakuos-base:minimal-base

RUN dnf -y \
    --setopt=install_weak_deps=false \
    install \
    @kde-desktop-environment \
    plasma-login-manager \
    plasma-nm \
    plasma-pa \
    plasma-disks \
    plasma-systemmonitor \
    dolphin \
    konsole \
    kate \
    ark \
    spectacle \
    kde-connect \
    kde-gtk-config \
    kscreen \
    xdg-desktop-portal-kde \
    qt6-qtwayland \
    mesa-dri-drivers \
    vulkan-loader \
    && dnf clean all \
    && rm -rf \
        /var/cache/dnf \
        /var/cache/libdnf5 \
        /var/log/dnf5.log

RUN systemctl set-default graphical.target
RUN systemctl enable plasmalogin.service

RUN bootc container lint

LABEL org.opencontainers.image.title="RakuOS KDE"
LABEL org.opencontainers.image.description="RakuOS KDE Plasma 6.6 image based on the GHCR bootc base"
LABEL org.opencontainers.image.source="https://github.com/krism-eu/rakuos-base"
LABEL org.opencontainers.image.version="0.1"

CMD ["/sbin/init"]
