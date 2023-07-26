FROM debian:12 AS install
ARG DEBIAN_FRONTEND=noninteractive
ARG PIPX_HOME=/opt/pipx
ARG PIPX_BIN_DIR=/usr/local/bin
RUN apt-get update &&\
    apt-get install -y systemd \
    x11-xserver-utils \
    xinit \
    xinput \
    pulseaudio \
    lightdm \
    lightdm-gtk-greeter \
    i3 \
    polybar \
    picom \
    rofi \
    kitty \
    neovim \
    ranger \
    iotop \
    feh \
    wget \
    jq \
    pipx &&\
    pipx install autotiling &&\
    pipx install i3-resurrect
FROM install AS desktop
RUN echo '#!/bin/bash' >> /desktop.sh &&\
    echo 'systemctl unmask dbus.service' >> /desktop.sh &&\
    echo 'systemctl start dbus.service' >> /desktop.sh &&\
    echo 'while [ -z $(pidof lightdm) ]; do lightdm && sleep 1; done' >> /desktop.sh &&\
    chmod +x /desktop.sh
