#!/bin/sh

if [ -z "$ETCD_NODE" ]
then
  echo "Missing ETCD_NODE env var"
  exit -1
fi

/sbin/syslogd -O /dev/stdout

set +eo pipefail

echo "[gasbuddy/haproxy] booting container. ETCD: $ETCD_NODE"

function config_fail()
{
	echo "Failed to start due to config error"
	exit -1
}

echo "[gasbuddy/haproxy] Running multibinder deamon"
/usr/bin/multibinder "$MULTIBINDER_SOCK" &

# Loop until confd has updated the haproxy config
n=0
until confd -onetime -node "$ETCD_NODE"; do
  if [ "$n" -eq "4" ];  then config_fail; fi
  echo "[gasbuddy/haproxy] waiting for confd to refresh haproxy.cfg"
  n=$((n+1))
  sleep $n
done

echo "[gasbuddy/haproxy] Initial HAProxy config created. Starting multibinder-haproxy and confd"
/usr/bin/multibinder-haproxy-wrapper haproxy -Ds -f /usr/local/etc/haproxy/haproxy.cfg.erb -p $HAPROXY_PID &
echo $! > $MULTIBINDER_PID

exec confd -watch=true -node "$ETCD_NODE"
