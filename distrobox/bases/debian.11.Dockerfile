FROM debian:12 AS debian
RUN apt-get update &&\
    apt-get install -y curl kmod

FROM debian AS nvidia_drivers
ARG NVIDIA
ARG NVIDIA_VERSION
COPY ./scripts/install-nvidia-drivers.sh /
RUN [ "${NVIDIA}" -ge 1 ] && /install-nvidia-drivers.sh "${NVIDIA_VERSION}"
