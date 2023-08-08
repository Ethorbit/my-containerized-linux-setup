FROM archlinux:base-20230723.0.166908 AS archlinux
RUN pacman -Syy --noconfirm

FROM archlinux AS nvidia_drivers
ARG NVIDIA
ARG NVIDIA_VERSION
COPY ./scripts/install-nvidia-drivers.sh /
RUN [ "${NVIDIA}" -ge 1 ] && /install-nvidia-drivers.sh "${NVIDIA_VERSION}" && rm /install-nvidia-drivers.sh

FROM nvidia_drivers AS xstarter
COPY ./scripts/install-xstarter.sh /
RUN pacman -Syy --noconfirm git cmake make gcc glibc pkgconf libinih &&\
    /install-xstarter.sh && rm /install-xstarter.sh &&\
    pacman -R --noconfirm git cmake make gcc pkgconf libinih
