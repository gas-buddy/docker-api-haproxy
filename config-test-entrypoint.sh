#!/usr/bin/env sh

set -ex

confd \
    -confdir /etc/confd/ \
    -config-file confd/confd.toml \
    -onetime \
    -sync-only \
    -log-level info \
    -node "${ETCD_ENDPOINT}"

cat /usr/local/etc/haproxy/haproxy.cfg
haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg

$@
