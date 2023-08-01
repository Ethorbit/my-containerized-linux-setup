FROM debian:12 AS install
RUN apt update &&\
    apt-get install -y flatpak \
	snapd
FROM install AS apps
ENV DISTRO=debian
COPY ./scripts/persist.sh /
COPY ./scripts/apps.sh /
COPY ./services/apps.service /etc/systemd/system/
RUN chmod +x /persist.sh &&\
    chmod +x /apps.sh &&\
    systemctl enable apps.service
