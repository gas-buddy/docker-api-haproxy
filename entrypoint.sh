#!/bin/sh

if [ -z "$ETCD_NODE" ]
then
  echo "Missing ETCD_NODE env var"
  exit -1
fi

set -eo pipefail

echo '[gasbuddy/api-haproxy] Booting container.'
echo "[gasbuddy/api-haproxy] $(confd -version)"
echo "[gasbuddy/api-haproxy] $(haproxy -v)"
echo "[gasbuddy/api-haproxy] Fetching config from ETCD: $ETCD_NODE"

confd -onetime -sync-only -node "$ETCD_NODE" --backend etcdv3

echo '[gasbuddy/api-haproxy] Initial HAProxy config created. Starting haproxy...'

# Using & instead of -D so that logs go to stdout
/usr/local/sbin/haproxy \
  -f /usr/local/etc/haproxy/haproxy.cfg \
  -W \
  -p $HAPROXY_PID &

echo "[gasbuddy/api-haproxy] Waiting for haproxy to come online..."

while [[ ! -f $HAPROXY_PID ]]; do sleep 1; done

echo "[gasbuddy/api-haproxy] Started haproxy (PID: $(cat $HAPROXY_PID))"
echo '[gasbuddy/api-haproxy] Starting confd...'

confd -watch=true -node "$ETCD_NODE" --backend etcdv3
