#!/bin/sh

# This script makes sure the confd-generated config is valid

# Set this to blank so it doesn't try to bind but just processes the erb file
MULTIBINDER_SOCK=

# multibinder-haproxy-erb really wants it to end in erb
rm -f /tmp/check_config.erb
cp $1 /tmp/check_config.erb
echo "[gasbuddy/haproxy] checking configuration"
exec /usr/bin/multibinder-haproxy-erb haproxy -c -f /tmp/check_config.erb
