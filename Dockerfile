FROM haproxy:1.8-alpine

# You almost certainly want to set these
ENV ETCD_NODE http://127.0.0.1:2379
ENV HAPROXY_PROCESSES 2
ENV SYSLOG_SERVER localhost

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
