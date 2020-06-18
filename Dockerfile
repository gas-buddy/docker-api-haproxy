FROM haproxy:2.1.7-alpine

# You almost certainly want to set these
ENV HAPROXY_PROCESSES 2
ENV SYSLOG_SERVER localhost
ENV ETCD_BASE_KEY /proxy

# Not usually something you set
ENV CONFD_VERSION 0.16.0
ENV HAPROXY_PID /var/run/haproxy.pid

ADD https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 \
    /usr/local/bin/confd

RUN addgroup haproxy-app && adduser -SDHG haproxy-app haproxy-app

RUN chmod u+x /usr/local/bin/confd

ADD entrypoint.sh /docker-entrypoint.sh
ADD confd /etc/confd/

ENTRYPOINT ["./docker-entrypoint.sh"]
