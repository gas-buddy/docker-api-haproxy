#!/bin/sh

if [ -z "$ETCD_NODE" ]
then
  echo "Missing ETCD_NODE env var"
  exit -1
fi

/sbin/syslogd -O /dev/stdout

set -eo pipefail

echo "[gasbuddy/haproxy-confd] booting container. ETCD: $ETCD_NODE"

function config_fail()
{
	echo "Failed to start due to config error"
	exit -1
}


# Loop until confd has updated the haproxy config
n=0
until confd -onetime -node "$ETCD_NODE"; do
  if [ "$n" -eq "10" ];  then config_fail; fi
  echo "[gasbuddy/haproxy-confd] waiting for confd to refresh haproxy.cfg"
  n=$((n+1))
  sleep $n
done

exec confd -watch=true -node "$ETCD_NODE" &

echo "[gasbuddy/haproxy-confd] Initial HAProxy config created. Starting haproxy and confd"
/usr/local/sbin/haproxy -f /usr/local/etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid
