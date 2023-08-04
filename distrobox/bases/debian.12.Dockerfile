FROM debian:12 AS debian
RUN apt-get update &&\
    apt-get install -y curl kmod

FROM debian AS nvidia_drivers
ARG NVIDIA
ARG NVIDIA_VERSION
COPY ./scripts/install-nvidia-drivers.sh /
RUN [ "${NVIDIA}" -ge 1 ] && /install-nvidia-drivers.sh "${NVIDIA_VERSION}"

#    curl -fsSl -o nvidia.run \
#        "https://download.nvidia.com/XFree86/Linux-$(uname -m)/${NVIDIA_VERSION}/NVIDIA-Linux-$(uname -m)-${NVIDIA_VERSION}.run" &&\
#    TERM=xterm sh nvidia.run -s --no-kernel-modules --no-opengl-files
