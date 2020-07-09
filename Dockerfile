FROM haproxy:2.2.0-alpine

# You almost certainly want to set these
ENV ETCD_BASE_KEY /proxy

# Not usually something you set
ENV CONFD_VERSION 0.16.0
ENV HAPROXY_PID /var/run/haproxy.pid

ADD https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 \
    /usr/local/bin/confd

RUN chmod u+x /usr/local/bin/confd

ADD entrypoint.sh /docker-entrypoint.sh
ADD confd /etc/confd/

ENTRYPOINT ["./docker-entrypoint.sh"]
