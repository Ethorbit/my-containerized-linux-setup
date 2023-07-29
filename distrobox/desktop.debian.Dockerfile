FROM debian:12 AS install
ARG DEBIAN_FRONTEND=noninteractive
ARG PIPX_HOME=/opt/pipx
ARG PIPX_BIN_DIR=/usr/local/bin
RUN apt-get update &&\
    apt-get install -y systemd \
    x11-xserver-utils \
    xinit \
    xinput \
    imwheel \
    pulseaudio \
    pulseeffects \
    lightdm \
    lightdm-gtk-greeter \
    light-locker \
    i3-wm \
    polybar \
    dunst \
    picom \
    rofi \
    flameshot \
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
COPY ./scripts/persist.sh /
COPY ./scripts/desktop.debian/start.sh /
RUN chmod +x /persist.sh &&\
    chmod +x /start.sh
VOLUME /volume
