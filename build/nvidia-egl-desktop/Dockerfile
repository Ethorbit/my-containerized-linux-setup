# Parent: ubuntu:22.04
FROM ghcr.io/selkies-project/nvidia-egl-desktop:22.04-20240425164112 AS base
USER root
#ARG KERNEL_VERSION
ENV DEBIAN_FRONTEND=noninteractive
ENV XSESSION_START_COMMAND="/usr/bin/startplasma-x11"
ENV XDG_RUNTIME_DIR=
ENV EDITOR="vim"
ENV VISUAL="vim"
#apt-get install -y linux-tools-${KERNEL_VERSION} &&\
RUN echo 'export XDG_RUNTIME_DIR=/run/user/$(id -u)' >> /home/user/.bashrc &&\
    apt-get update -y &&\
    echo "Removing unwanted bloat.." &&\
    apt purge -y \
        nano \
        printer-driver-cups-pdf \
        python3-cups \
        '^libreoffice.*$' \
        okular \
        '^cups-.*$' \
        lutris \
        '^wine.*$' &&\
    echo "Adding tools.." &&\
    apt-get install -y \
        flatpak \
        git \
        wget \
        curl \
        iputils-ping \
        lsof &&\
    echo "Adding FlatHub remote.." &&\
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Basically a port of nestybox/ubuntu-jammy-systemd-docker:latest
# with a few changes to get it compatible with parent
FROM base AS sysbox-systemd-docker
RUN echo "Installing systemd" &&\
    apt-get install -y \
    systemd \
    systemd-sysv \
    libsystemd0 \
    dbus \
    ca-certificates \
    iptables \
    iproute2 \
    locales \
    kmod \
    udev &&\
    echo "ReadKMsg=no" >> /etc/systemd/journald.conf &&\
    echo "Masking systemd stuff" &&\
    systemctl mask \
    systemd-udevd.service \
    systemd-udevd-kernel.socket \
    systemd-udevd-control.socket \
    systemd-modules-load.service \
    sys-kernel-debug.mount \
    sys-kernel-tracing.mount \
    systemd-resolved.service \
    systemd-logind.service \
    upower.service \
    systemd-hostnamed.service \
    systemd-localed.service \
    systemd-timedated.service &&\
    echo "Installing docker" &&\
    curl -fsSL https://get.docker.com -o get-docker.sh &&\
    sh get-docker.sh &&\
    usermod -a -G docker user &&\
    echo "Installing SSH server" &&\
    apt-get install -y openssh-server &&\
    mkdir /home/user/.ssh &&\
    chown user:user /home/user/.ssh &&\
    echo "Cleanup" &&\
    apt-get clean -y &&\
    rm -rf \
    /var/cache/debconf/* \
    /var/lib/apt/lists/* \
    /var/log/* \
    /tmp/* \
    /var/tmp/* \
    /usr/share/doc/* \
    /usr/share/man/* \
    /usr/share/local/*
COPY ./systemd/overrides/accounts-daemon.service /etc/systemd/system/accounts-daemon.service
ADD https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker /etc/bash_completion.d/docker.sh
STOPSIGNAL SIGRTMIN+3
EXPOSE 22/tcp

FROM sysbox-systemd-docker AS nix
#COPY nix-2.22.0.sh /install-nix.sh
#RUN /install-nix.sh --daemon && rm /install-nix.sh

FROM nix AS supervisor-replacement
COPY ./systemd/user@1000.service /etc/systemd/system/user@1000.service
COPY ./systemd/entrypoint.service /etc/systemd/system/entrypoint.service
COPY ./systemd/pulseaudio.service /etc/systemd/system/pulseaudio.service
COPY ./systemd/selkies-gstreamer.service /etc/systemd/system/selkies-gstreamer.service
RUN echo "Removing supervisor" &&\
    systemctl mask supervisor.service &&\
    rm /etc/supervisord.conf &&\
    apt purge -y supervisor &&\
    echo "Creating env files for our services and scripts" &&\
    touch /etc/default/entrypoint &&\
    touch /etc/default/pulseaudio &&\
    touch /etc/default/selkies-gstreamer &&\
    chown user:user \
        /etc/default/pulseaudio \
        /etc/default/selkies-gstreamer &&\
    chmod 600 \
        /etc/default/entrypoint \
        /etc/default/pulseaudio \
        /etc/default/selkies-gstreamer &&\
    echo "Altering parent selkies-gstreamer script to source its env file" &&\
    sed -i '2s|^|source /etc/default/selkies-gstreamer|' \
        /etc/selkies-gstreamer-entrypoint.sh &&\
    echo "Enabling supervisor replacement services" &&\
    mkdir -p /etc/systemd/system/multi-user.wants/ &&\
    systemctl enable \
        user@1000.service \
        entrypoint.service \
        pulseaudio.service \
        selkies-gstreamer.service &&\
    echo "hiding Operation not Permitted errors caused by entrypoint's password change" &&\
    echo "Set disable_coredump false" >> /etc/sudo.conf
ENTRYPOINT [ "/usr/local/sbin/entrypoint.sh" ]
CMD [ "bash" ]

FROM supervisor-replacement AS bin
COPY ./bin/* /usr/local/bin
COPY ./sbin/* /usr/local/sbin
RUN chmod +x -R /usr/local/bin/ /usr/local/sbin/
ENV DEBIAN_FRONTEND=readline

# Default is already KDE Plasma
FROM bin AS kdeplasma

#FROM bin AS no-kde
# ...

#FROM no-kde AS xfce
# ...

#FROM no-kde AS cinnamon
# ...

#FROM no-kde AS gnome
# ...

#FROM no-kde AS i3wm
# ...
