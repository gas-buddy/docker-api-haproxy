gasbuddy/api-haproxy
==================================

A containerized unit of [haproxy](http://www.haproxy.org/) +
[confd](https://github.com/kelseyhightower/confd)

This creates a docker container that bundles haproxy and confd. The entrypoint script
- sets an environment variable for a locally-running etcd instance (in our case an etcd node running proxy mode)
- configures confd to check etcd address at first run and to use the keys defined in **confd.toml** to populate the haproxy config file
- starts haproxy using that configured file
- runs confd with the **-watch** flag so that it dynamically reloads haproxy every time a change in the specified etcd keys is detected

Paths
=====
`api-haproxy` expects the configuration to reside under the `/proxy` key.

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
