#!/bin/sh

PID=/var/run/multibinder.pid

if [ -z "$PID" ]; then
  kill -USR2 $PID
else
  /usr/bin/multibinder-haproxy-wrapper haproxy -f /usr/local/etc/haproxy/haproxy.cfg.erb -p /var/run/haproxy.pid -V &
  cat $! > $PID
fi
