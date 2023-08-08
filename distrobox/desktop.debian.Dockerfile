FROM my-base:debian-12 AS install
ARG DEBIAN_FRONTEND=noninteractive
ARG PIPX_HOME=/opt/pipx
ARG PIPX_BIN_DIR=/usr/local/bin
RUN echo 'deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware' | tee -a /etc/apt/sources.list &&\
    apt-get update &&\
    apt-get install -y systemd \
    ssh-client \
    x11-xserver-utils \
    dbus-x11 \
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
    flameshot \
    kitty \
    neovim \
    ranger \
    iotop \
    feh \
    wget \
    curl \
    jq \
    pipx &&\
    pipx install autotiling &&\
    pipx install i3-resurrect

FROM install AS desktop
ENV DISTRO=debian
COPY ./scripts/persist.sh /
COPY ./scripts/desktop.sh /
COPY ./services/desktop.service /etc/systemd/system/
RUN chmod +x /persist.sh &&\
    chmod +x /desktop.sh &&\
    systemctl enable desktop.service
VOLUME /volume
