#!/bin/sh

echo "[gasbuddy/haproxy] reload called"

if [ -f "$MULTIBINDER_PID" ]; then
  echo "[gasbuddy/haproxy] sending USR2 to multibinder"
  kill -USR2 `cat $MULTIBINDER_PID`
fi
