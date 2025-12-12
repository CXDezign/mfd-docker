# Description

Run Dockerised Printer server to share USB printers over the network. \
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
| `--name`      | `container_name:` | `cups`                      | Preferred Docker container name. |
| `--device`    | `devices:`        | `/dev/bus/usb:/dev/bus/usb` | Add host device (USB printer/scanner) to container. Default passes the whole USB bus in case the USB port on your device changes. Change to a fixed USB port if it will remain unchanged, example: `/dev/bus/usb/001/005`. |
| `-v`          | `volumes:`        | `cups`                      | Persistent Docker container volume for CUPS configuration files (migration or backup purposes). |
| `-p`          | `ports:`          | `631`                       | CUPS network port. |
| `-e USERNAME` | `USERNAME`        | `username`                  | Environment username. |
| `-e PASSWORD` | `PASSWORD`        | `password`                  | Environment password. |
| `-e TIMEZONE` | `TIMEZONE`        | `Europe/Warsaw`             | Environment timezone. Use your preferred [TZ identifier](https://wikipedia.org/wiki/List_of_tz_database_time_zones#List). |

## Docker Run
```bash
docker run -d --name cups \
    --restart unless-stopped \
    --device /dev/bus/usb \
    -p 631:631 \
    -v /etc/cups:/etc/cups \
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
        container_name: cups
        restart: unless-stopped
        ports:
            - 631:631
        devices:
            - /dev/bus/usb:/dev/bus/usb
        environment:
            - USERNAME="username"
            - PASSWORD="password"
            - TIMEZONE="Europe/Warsaw"
        volumes:
            - /etc/cups:/etc/cups
```

## CUPS Dashboard
Access the CUPS dashboard using the IP address of your server:

http://192.168.###.###:631
