FROM archlinux:latest AS archlinux
RUN pacman -Syu --noconfirm

FROM archlinux AS nvidia_drivers
ARG NVIDIA
ARG NVIDIA_VERSION
COPY ./scripts/install-nvidia-drivers.sh /
RUN [ "${NVIDIA}" -ge 1 ] &&\
	pacman -S --noconfirm pkgconf &&\
	/install-nvidia-drivers.sh "${NVIDIA_VERSION}" &&\
	pacman -R --noconfirm pkgconf && rm /install-nvidia-drivers.sh

FROM nvidia_drivers AS xstarter
COPY ./scripts/install-xstarter.sh /
RUN pacman -Syy --noconfirm git cmake make gcc pkgconf libinih &&\
    /install-xstarter.sh && rm /install-xstarter.sh &&\
    pacman -R --noconfirm git cmake make gcc pkgconf libinih
