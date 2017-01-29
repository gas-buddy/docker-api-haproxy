FROM haproxy:1.7-alpine

ENV CONFD_VERSION 0.11.0
ENV ETCD_NODE http://etcd0:4001/
ENV MULTIBINDER_SOCK /var/run/multibinder.sock
ENV LISTEN_PORT 8000

ADD https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 \
    /usr/local/bin/confd

RUN chmod u+x /usr/local/bin/confd && \
    apk add --no-cache ruby ruby-bundler ruby-json && \
    gem install multibinder --no-ri --no-rdoc

ADD entrypoint.sh /entrypoint.sh
ADD confd /etc/confd

ENTRYPOINT ["./entrypoint.sh"]