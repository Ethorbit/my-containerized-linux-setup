# Parent: ubuntu:22.04
FROM ghcr.io/selkies-project/nvidia-egl-desktop:22.04-20240425164112 AS base
USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y &&\
    echo "Removing unwanted bloat.." &&\
    apt purge -y printer-driver-cups-pdf \
        python3-cups \
        '^libreoffice.*$' \
        okular \
        '^cups-.*$' \
        lutris \
        '^wine.*$' &&\
    echo "Adding tools.." &&\
    apt-get install -y podman flatpak git wget curl

#FROM base AS nix
#COPY nix-2.22.0.sh /install-nix.sh
#RUN /install-nix.sh --daemon && rm /install-nix.sh

ENV DEBIAN_FRONTEND=readline
USER user
