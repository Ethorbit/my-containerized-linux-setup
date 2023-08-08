FROM debian:12 AS debian
RUN apt-get update &&\
    apt-get install -y curl

FROM debian AS nvidia_drivers
ARG NVIDIA
ARG NVIDIA_VERSION
COPY ./scripts/install-nvidia-drivers.sh /
RUN [ "${NVIDIA}" -ge 1 ] &&\
	apt-get install -y pkgconf kmod &&\
	/install-nvidia-drivers.sh "${NVIDIA_VERSION}" &&\
	apt-get remove -y pkgconf kmod && rm /install-nvidia-drivers.sh

FROM nvidia_drivers AS xstarter
COPY ./scripts/install-xstarter.sh /
RUN apt-get install -y git cmake make gcc g++ pkgconf libncurses-dev libinih-dev &&\
    /install-xstarter.sh && rm /install-xstarter.sh &&\
    apt-get remove -y git cmake make gcc g++ pkgconf libncurses-dev libinih-dev
