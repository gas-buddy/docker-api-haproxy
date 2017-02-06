#!/bin/sh

PID=/var/run/multibinder.pid

echo "[haproxy-confd] run-or-reload called"

if [ -f "$PID" ]; then
  echo "[haproxy-confd] sending USR2 to multibinder"
  kill -USR2 `cat /var/run/multibinder.pid`
fi
