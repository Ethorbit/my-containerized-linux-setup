FROM debian:12 AS install
RUN apt update &&\
    apt-get install -y flatpak \
	snapd
FROM install AS apps
COPY ./scripts/persist.sh /
COPY ./scripts/apps.debian.sh /
RUN chmod +x /persist.sh &&\
    chmod +x /apps.debian.sh
