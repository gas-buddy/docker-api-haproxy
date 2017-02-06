#!/bin/sh

MULTIBINDER_SOCK=

echo "[haproxy-confd] checking configuration"

exec /usr/bin/multibinder-haproxy-erb haproxy -c -f /tmp/check_config.erb