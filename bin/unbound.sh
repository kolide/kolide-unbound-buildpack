#!/usr/bin/env bash

# Grab Heroku's Private Space DNS servers from /etc/resolv.conf
PRIVATE_SPACE_DNS_SERVERS=$(grep '^nameserver' /etc/resolv.conf | cut -d' ' -f2)

# Default to using these DNS servers in unbound
CONF_FILE=/app/.apt/etc/unbound/unbound.conf
echo -e "forward-zone:" >> $CONF_FILE
echo -e "    name: \"*\"" >> $CONF_FILE
for row in $(grep '^nameserver' /etc/resolv.conf | cut -d' ' -f2); do
    echo -e "    forward-addr: $row" >> $CONF_FILE
done
echo -e "    forward-no-cache: yes" >> $CONF_FILE

# Update /etc/resolv.conf to use unbound instead of the Private Space DNS
awk '!/nameserver/' /etc/resolv.conf > /etc/resolv.conf.new
echo "nameserver 127.0.0.1" >> /etc/resolv.conf.new
mv /etc/resolv.conf /etc/resolv.conf.bak
mv /etc/resolv.conf.new /etc/resolv.conf

# Start unbound
/app/.apt/usr/sbin/unbound -c -vvv /app/.apt/etc/unbound/unbound.conf
