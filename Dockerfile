FROM haproxy:1.7-alpine

ENV CONFD_VERSION 0.11.0
ENV ETCD_NODE http://etcd0:4001/
ENV MULTIBINDER_SOCK /var/run/multibinder.sock

ADD https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 \
    /usr/local/bin/confd

RUN addgroup haproxy-app && adduser -SDHG haproxy-app haproxy-app

RUN chmod u+x /usr/local/bin/confd && \
    apk add --no-cache ruby ruby-bundler ruby-json tini su-exec && \
    gem install multibinder --no-ri --no-rdoc

ADD entrypoint.sh /entrypoint.sh
ADD run-or-reload.sh /run-or-reload.sh
ADD confd /etc/confd

ENTRYPOINT ["./entrypoint.sh"]
