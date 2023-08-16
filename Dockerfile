FROM haproxy:2.2-alpine

# You almost certainly want to set these
ENV ETCD_BASE_KEY /proxy

# Not usually something you set
ENV HAPROXY_PID /var/run/haproxy.pid

ADD confd/src/bin/confd-linux /usr/local/bin/confd

RUN chmod u+x /usr/local/bin/confd

ADD entrypoint.sh /docker-entrypoint.sh
ADD confd /etc/confd/

ENTRYPOINT ["./docker-entrypoint.sh"]
