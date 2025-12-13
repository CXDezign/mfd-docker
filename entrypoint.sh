#!/bin/bash -ex

# Environment Variables
set -e

# PPDs
mv ./ppd/cnijfilter2_6.80-1_${TARGET_ARCH}.deb /tmp/cnijfilter2.deb
apt install -y /tmp/cnijfilter2.deb

# Default Configuration
/usr/sbin/cupsd \
  && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
  && cupsctl --remote-admin --remote-any --share-printers \
  && kill $(cat /var/run/cups/cupsd.pid)
echo "ServerAlias *" >> /etc/cups/cupsd.conf
echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf

# Environment Configuration
if [ $(grep -ci $USERNAME /etc/shadow) -eq 0 ]; then
    # User Configuration
    useradd -r -G lpadmin -M $USERNAME
    echo $USERNAME:$PASSWORD | chpasswd

    # Timezone Configuration
    ln -fs /usr/share/zoneinfo/$TIMEZONE /etc/localtime
    dpkg-reconfigure --frontend noninteractive tzdata
fi

# Restore Configurations
if [ ! -f /etc/cups/cupsd.conf ]; then
    cp -rpn /etc/cups.bak/* /etc/cups/
fi

# Execute
exec /usr/sbin/cupsd -f
