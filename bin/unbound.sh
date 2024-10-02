#!/usr/bin/env bash

# Grab Heroku's Private Space DNS servers from /etc/resolv.conf
PRIVATE_SPACE_DNS_SERVERS=$(grep '^nameserver' /etc/resolv.conf | cut -d' ' -f2)

# Default to using these DNS servers in unbound
/usr/local/sbin/unbound-control forward_add "*" $PRIVATE_SPACE_DNS_SERVERS

# Update /etc/resolv.conf to use unbound instead of the Private Space DNS
awk '!/nameserver/' /etc/resolv.conf > /etc/resolv.conf.new
echo "nameserver 127.0.0.1" >> /etc/resolv.conf.new
mv /etc/resolv.conf /etc/resolv.conf.bak
mv /etc/resolv.conf.new /etc/resolv.conf

# Start unbound
/usr/local/sbin/unbound -c /etc/unbound/unbound.conf
