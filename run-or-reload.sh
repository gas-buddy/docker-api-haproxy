#!/bin/sh

PID=/var/run/multibinder.pid

echo "[haproxy-confd] run-or-reload called"

if [ -f "$PID" ]; then
  echo "[haproxy-confd] sending USR2 to multibinder"
  kill -USR2 `cat $PID`
else
  echo "[haproxy-confd] running haproxy wrapper"
  nohup /usr/bin/multibinder-haproxy-wrapper haproxy -Ds -f /usr/local/etc/haproxy/haproxy.cfg.erb -p /var/run/haproxy.pid -V &
  echo $! > $PID
fi
