#!/usr/bin/env bash

# Grab Heroku's Private Space DNS servers from /etc/resolv.conf
PRIVATE_SPACE_DNS_SERVERS=$(grep '^nameserver' /etc/resolv.conf | cut -d' ' -f2)

# Default to using these DNS servers in unbound
CONF_FILE=/app/.apt/etc/unbound/unbound.conf
echo -e "forward-zone:" >> $CONF_FILE
echo -e "    name: \"*\"" >> $CONF_FILE
for row in $(grep '^nameserver' /etc/resolv.conf | cut -d' ' -f2); do
    if [ "$row" != "127.0.0.1" ]; then
        echo -e "    forward-addr: $row" >> $CONF_FILE
    fi
done
echo -e "    forward-no-cache: yes" >> $CONF_FILE

# Create a new resolv file using unbound instead of the Private Space DNS
awk '!/nameserver/' /etc/resolv.conf > /app/resolv.conf
echo "nameserver 127.0.0.1" >> /app/resolv.conf

# Start unbound
/app/.apt/usr/sbin/unbound -vvv -c /app/.apt/etc/unbound/unbound.conf
