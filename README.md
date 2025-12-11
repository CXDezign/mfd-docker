# Description

Run Dockerised Print & Scan MFD on a server to share USB printers & scanners over the network. \
Built to be used with Raspberry Pi's. \
Tested and confirmed to be working on:
- Raspberry Pi 5 (`arm64/AArch64`)

Image package available from:
  - [Docker Hub](https://hub.docker.com/repository/docker/cxdezign/cups): `cxdezign/cups`

# Usage
Use either **Docker Run** or **Docker Compose** to run the Docker image in a container with customised parameters.

## Parameters & Environment Variables
| Flag          | Parameter         | Default                     | Description |
| ------------- | ----------------- | --------------------------- | ----------- |
| `--name`      | `container_name:` | `mfd`                       | Preferred Docker container name. |
| `--device`    | `devices:`        | `/dev/bus/usb:/dev/bus/usb` | Add host device (USB printer/scanner) to container. Default passes the whole USB bus in case the USB port on your device changes. Change to a fixed USB port if it will remain unchanged, example: `/dev/bus/usb/001/005`. |
| `-v`          | `volumes:`        | `cups`, `sane.d`            | Persistent Docker container volume for CUPS & SANE configuration files (migration or backup purposes). |
| `-p`          | `ports:`          | `631`, `6566`               | CUPS & SANE network ports. |
| `-e USERNAME` | `USERNAME`        | `username`                  | Environment username. |
| `-e PASSWORD` | `PASSWORD`        | `password`                  | Environment password. |
| `-e TIMEZONE` | `TIMEZONE`        | `Europe/Warsaw`             | Environment timezone. Use your preferred [TZ identifier](https://wikipedia.org/wiki/List_of_tz_database_time_zones#List). |

## Docker Run
```bash
docker run -d --name mfd \
    --restart unless-stopped \
    --device /dev/bus/usb \
    -p 631:631 \
    -p 6566:6566 \
    -v /etc/cups:/etc/cups \
    -v /etc/sane.d:/etc/sane.d \
    -e USERNAME="username" \
    -e PASSWORD="password" \
    -e TIMEZONE="Europe/Warsaw" \
    cxdezign/cups
```

## Docker Compose
```yaml
services:
    cups:
        image: cxdezign/cups
        container_name: mfd
        restart: unless-stopped
        ports:
            - 631:631
            - 6566:6566
        devices:
            - /dev/bus/usb:/dev/bus/usb
        environment:
            - USERNAME="username"
            - PASSWORD="password"
            - TIMEZONE="Europe/Warsaw"
        volumes:
            - /etc/cups:/etc/cups
            - /etc/sane.d:/etc/sane.d
```

## CUPS Dashboard
Access the CUPS dashboard using the IP address of your server:

http://192.168.###.###:631
