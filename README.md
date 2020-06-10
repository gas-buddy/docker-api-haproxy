gasbuddy/haproxy-multibinder-confd
==================================

A containerized unit of [haproxy](http://www.haproxy.org/) +
[confd](https://github.com/kelseyhightower/confd) +
[multibinder](https://github.com/github/multibinder) to provide
ultra high availability scalable proxy services.

The proxy uses an etcd cluster to build a dynamic set of
front ends and back ends (and connections between them). Whenever them
configuration is changed, the proxy will gracefully reload with
no dropped connections.

Paths
=====
`haproxy-multibinder-confd` expects the configuration to reside under the `/proxy` key.

Setup
=====

You'll need an etcd cluster. For development and testing, you can just
run one:

```
export HostIP=...put your host ip address here...
docker run -d -v /usr/share/ca-certificates/:/etc/ssl/certs \
 --name etcd0 --network=tooling_gb_internal quay.io/coreos/etcd etcd \
 -name etcd0 \
 -advertise-client-urls http://{$HostIP}:2379,http://{$HostIP}:4001 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -initial-advertise-peer-urls http://{$HostIP}:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -initial-cluster-token etcd-cluster-1 \
 -initial-cluster etcd0=http://{$HostIP}:2380 \
 -initial-cluster-state new
```
