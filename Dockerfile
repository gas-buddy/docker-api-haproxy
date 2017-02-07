FROM haproxy:1.7-alpine

# You almost certainly want to set these
ENV ETCD_NODE http://etcd0:4001/
ENV HAPROXY_PROCESSES 2
ENV SYSLOG_SERVER localhost

# Not usually something you set
ENV CONFD_VERSION 0.11.0
ENV MULTIBINDER_SOCK /var/run/multibinder.sock
ENV MULTIBINDER_PID /var/run/multibinder.pid
ENV HAPROXY_PID /var/run/haproxy.pid

ADD https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 \
    /usr/local/bin/confd

RUN addgroup haproxy-app && adduser -SDHG haproxy-app haproxy-app

RUN chmod u+x /usr/local/bin/confd && \
    apk add --no-cache ruby ruby-bundler ruby-json && \
    gem install multibinder --no-ri --no-rdoc

ADD entrypoint.sh /docker-entrypoint.sh
ADD scripts /scripts/
ADD confd /etc/confd/

ENTRYPOINT ["./docker-entrypoint.sh"]
