# Install packages for installation
dnf5 install -y libblockdev-btrfs

#remove rakuos-welcome automatic launch for live environment
rm -f /etc/xdg/autostart/rakuos-welcome.desktop