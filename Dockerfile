FROM debian:unstable-slim

# Arguments
ARG TARGETPLATFORM
ARG TARGETARCH

# Environment Variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TIMEZONE="Europe/Warsaw"
ENV USERNAME=username
ENV PASSWORD=password

# Labels
LABEL org.opencontainers.image.source="https://github.com/CXDezign/cups-docker"
LABEL org.opencontainers.image.description="Dockerized Printer (CUPS) Server"
LABEL org.opencontainers.image.author="CXDezign <contact@cxdezign.com>"
LABEL org.opencontainers.image.url="https://github.com/CXDezign/cups-docker/blob/main/README.md"
LABEL org.opencontainers.image.licenses=MIT

# PPDs
ADD ./ppd/cnijfilter2_6.80-1_${TARGETARCH}.deb /tmp/cnijfilter2.deb
RUN apt install -y /tmp/cnijfilter2.deb

# Dependencies
RUN apt update -qqy
RUN apt upgrade -qqy
RUN apt install --no-install-recommends -y \
                whois \
                nano \
                usbutils \
                smbclient \
                avahi-utils \
                cups \
                cups-client \
                cups-bsd \
                cups-filters \
                cups-browsed \
                printer-driver-all \
                printer-driver-cups-pdf \
                printer-driver-gutenprint \
                foomatic-db-engine \
                foomatic-db-compressed-ppds \
                openprinting-ppds \
                hpijs-ppds \
                hp-ppd \
                hplip

# Entrypoint
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]

# Backup
RUN cp -rp /etc/cups /etc/cups.bak

# Services
RUN service cups restart

# Volume
VOLUME [ "/etc/cups" ]

# Ports
EXPOSE 631
