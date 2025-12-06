FROM debian:unstable-slim

# Environment Variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TIMEZONE="Europe/Warsaw"
ENV USERNAME=username
ENV PASSWORD=password

# Labels
LABEL org.opencontainers.image.source="https://github.com/CXDezign/cups-docker"
LABEL org.opencontainers.image.description="Dockerized CUPS Print Server"
LABEL org.opencontainers.image.author="CXDezign <contact@cxdezign.com>"
LABEL org.opencontainers.image.url="https://github.com/CXDezign/cups-docker/blob/main/README.md"
LABEL org.opencontainers.image.licenses=MIT

# Dependencies (Packages & Drivers)
#RUN printf '%s\n' \
#  'deb http://deb.debian.org/debian trixie main contrib non-free' \
#  'deb http://deb.debian.org/debian trixie-updates main contrib non-free' \
#  'deb http://security.debian.org/debian-security trixie-security main contrib non-free' \
#  > /etc/apt/sources.list.d/debian.list
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
                foomatic-db-engine \
                foomatic-db-compressed-ppds \
                openprinting-ppds \
                hpijs-ppds \
                hp-ppd \
                hplip

# CUPS Default Configuration
RUN /usr/sbin/cupsd \
  && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
  && cupsctl --remote-admin --remote-any --share-printers \
  && kill $(cat /var/run/cups/cupsd.pid)
#RUN sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf
#RUN sed -i 's/Browsing Off/Browsing On/' /etc/cups/cupsd.conf
#RUN sed -i 's/<Location \/>/<Location \/>\n  Allow All/' /etc/cups/cupsd.conf
#RUN sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow All\n  Require user @SYSTEM/' /etc/cups/cupsd.conf
#RUN sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow All/' /etc/cups/cupsd.conf
RUN echo "ServerAlias *" >> /etc/cups/cupsd.conf
RUN echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf

# Entrypoint
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]

# Backup
RUN cp -rp /etc/cups /etc/cups.bak

# Service CUPS
RUN service cups restart

# Volume
VOLUME [ "/etc/cups" ]

# Ports
EXPOSE 631
