# etcd

A highly-available key value store for shared configuration and service discovery. etcd is inspired by zookeeper and doozer, with a focus on:

* Simple: curl'able user facing API (HTTP+JSON)
* Secure: optional SSL client cert authentication
* Fast: benchmarked 1000s of writes/s per instance
* Reliable: Properly distributed using Raft

Etcd is written in Go and uses the raft consensus algorithm to manage a highly-available replicated log.

etcd.io

<img src="https://camo.githubusercontent.com/fe737347e56d56ae0044dc906f2e748bb917d367164e0fbd90858abaf9c9dcff/68747470733a2f2f692e70696e696d672e636f6d2f373336782f35342f39342f31632f35343934316364356233643038373436313137663432656261656338393563642e6a7067" width="30%" height="auto" alt="etcd logo">

## How to use this Makejail

### Running a single node etcd

Use the host IP address when configuring etcd:

```console
$ export NODE1=192.168.0.139
```

Create a directory to store etcd data:

```console
$ # Be sure that DATA_DIR is an absolute path!
$ export DATA_DIR="/var/appjail-volumes/etcd/data"
$ mkdir -p "${DATA_DIR}"
```

Profit!

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o alias \
    -o ip4_inherit \
    -o fstab="${DATA_DIR} /data" \
    ghcr.io/appjail-makejails/etcd:15.1-36 node1 \
    --data-dir=/data --name node1 \
    --initial-advertise-peer-urls http://${NODE1}:2380 --listen-peer-urls http://${NODE1}:2380 \
    --advertise-client-urls http://${NODE1}:2379 --listen-client-urls http://${NODE1}:2379 \
    --initial-cluster node1=http://${NODE1}:2380
```

List the cluster member:

```console
$ etcdctl --endpoints=http://${NODE1}:2379 member list
```

### Running a 3 node etcd cluster

```sh
#!/bin/sh

set -e

REGISTRY=ghcr.io/appjail-makejails/etcd

ETCD_VERSION=15.1-36
TOKEN=my-etcd-token
CLUSTER_STATE=new
EXT_IF=lan0
NAME_1=etcd-node-0
NAME_2=etcd-node-1
NAME_3=etcd-node-2
HOST_1=192.168.0.140
HOST_2=192.168.0.141
HOST_3=192.168.0.142
CIDR=24
CLUSTER=${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_3}=http://${HOST_3}:2380
DATA_DIR=/var/appjail-volumes/etcd/data

mkdir -p "${DATA_DIR}"

# For node 1
THIS_NAME=${NAME_1}
THIS_IP=${HOST_1}
appjail oci run -Pd \
  -o overwrite=force \
  -o alias="${EXT_IF}" \
  -o ip4="${THIS_IP}/${CIDR}" \
  -o fstab="${DATA_DIR} /data" \
  ${REGISTRY}:${ETCD_VERSION} ${THIS_NAME} \
  --data-dir=/data --name ${THIS_NAME} \
  --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster ${CLUSTER} \
  --initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}

# For node 2
THIS_NAME=${NAME_2}
THIS_IP=${HOST_2}
appjail oci run -Pd \
  -o overwrite=force \
  -o alias="${EXT_IF}" \
  -o ip4="${THIS_IP}/${CIDR}" \
  -o fstab="${DATA_DIR} /data" \
  ${REGISTRY}:${ETCD_VERSION} ${THIS_NAME} \
  --data-dir=/data --name ${THIS_NAME} \
  --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster ${CLUSTER} \
  --initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}

# For node 3
THIS_NAME=${NAME_3}
THIS_IP=${HOST_3}
appjail oci run -Pd \
  -o overwrite=force \
  -o alias="${EXT_IF}" \
  -o ip4="${THIS_IP}/${CIDR}" \
  -o fstab="${DATA_DIR} /data" \
  ${REGISTRY}:${ETCD_VERSION} ${THIS_NAME} \
  --data-dir=/data --name ${THIS_NAME} \
  --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster ${CLUSTER} \
  --initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}
```

Profit!

```console
$ appjail oci exec etcd-node-0 etcdctl put foo bar
```

### Arguments (stage: build)

* `etcd_from` (default: `ghcr.io/appjail-makejails/etcd`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `etcd_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

### Environment (OCI image)

* `PGID` (default: `1000`): Equivalent to `PUID` but for the Process Group ID.
* `PUID` (default: `1000`): Process User ID for the container's main process, allowing you to match the owner of files written to mounted host volumes to your host system's user. Writable volumes are changed based on this environment variable.

### Volumes

| Name | Owner | Group | Perm | Type | Mountpoint |
| --- | --- | --- | --- | --- | --- |
| appjail-263aca83a3-data | `${PUID}` | `${PGID}` | - | - | /data |

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1-2
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-34
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        ETCDVER: "34"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-35
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        ETCDVER: "35"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-36
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
        ETCDVER: "36"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```
