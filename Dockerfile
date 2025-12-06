FROM debian:trixie-slim

# ENV Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TIMEZONE="Europe/Warsaw"
ENV USERNAME=username
ENV PASSWORD=password

LABEL org.opencontainers.image.source="https://github.com/CXDezign/cups-docker"
LABEL org.opencontainers.image.description="Dockerized CUPS Print Server"
LABEL org.opencontainers.image.author="CXDezign <contact@cxdezign.com>"
LABEL org.opencontainers.image.url="https://github.com/CXDezign/cups-docker/blob/main/README.md"
LABEL org.opencontainers.image.licenses=MIT

# Dependencies
RUN apt update -qqy
RUN apt upgrade -qqy
RUN apt install -y \
                cups \
                hplip \
                samba

EXPOSE 631
EXPOSE 5353/udp

# Baked-in config file changes
RUN sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf
RUN sed -i 's/Browsing Off/Browsing On/' /etc/cups/cupsd.conf
RUN sed -i 's/<Location \/>/<Location \/>\n  Allow All/' /etc/cups/cupsd.conf
RUN sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow All\n  Require user @SYSTEM/' /etc/cups/cupsd.conf
RUN sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow All/' /etc/cups/cupsd.conf
RUN echo "ServerAlias *" >> /etc/cups/cupsd.conf
RUN echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf
RUN sudo systemctl restart cups

# Back up cups configs in case user does not add their own
RUN cp -rp /etc/cups /etc/cups-bak
VOLUME [ "/etc/cups" ]

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
