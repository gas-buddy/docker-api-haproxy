#!/bin/sh

if [ -z "$ETCD_NODE" ]
then
  echo "Missing ETCD_NODE env var"
  exit -1
fi

/sbin/syslogd -O /dev/stdout

set +eo pipefail

#confd will start haproxy, since conf will be different than existing (which is null)

echo "[haproxy-confd] booting container. ETCD: $ETCD_NODE"

function config_fail()
{
	echo "Failed to start due to config error"
	exit -1
}

echo "[haproxy-confd] Running multibinder deamon"

/usr/bin/multibinder "$MULTIBINDER_SOCK" &

# Loop until confd has updated the haproxy config
n=0
until confd -log-level=debug -onetime -node "$ETCD_NODE"; do
  if [ "$n" -eq "4" ];  then config_fail; fi
  echo "[haproxy-confd] waiting for confd to refresh haproxy.cfg"
  n=$((n+1))
  sleep $n
done

echo "[haproxy-confd] Initial HAProxy config created. Starting confd"

exec confd -watch=true -log-level=debug -node "$ETCD_NODE"
