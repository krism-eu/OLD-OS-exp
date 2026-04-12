# Install packages for installation
dnf5 install -y anaconda-live libblockdev-{btrfs,lvm,dm}

#remove rakuos-welcome automatic launch for live environment
rm -f /etc/xdg/autostart/rakuos-welcome.desktop