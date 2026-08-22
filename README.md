# RakuOS Base

Minimal Fedora bootc base image for RakuOS.

## Base

- Fedora bootc 44
- AMD graphics stack
- PipeWire and WirePlumber
- Podman
- Btrfs/Snapper tools
- Italian and English locales

## Intentionally excluded

- i686 packages
- gaming packages
- NVIDIA packages
- VM guest tools
- Firefox RPM
- unnecessary Intel hardware packages

The image is built and published through GitHub Actions.
