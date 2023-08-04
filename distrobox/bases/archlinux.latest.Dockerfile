FROM archlinux:latest AS archlinux
RUN pacman -Syu --noconfirm

FROM archlinux AS nvidia_drivers
ARG NVIDIA
ARG NVIDIA_VERSION
COPY ./scripts/install-nvidia-drivers.sh /
RUN [ "${NVIDIA}" -ge 1 ] && /install-nvidia-drivers.sh "${NVIDIA_VERSION}"
