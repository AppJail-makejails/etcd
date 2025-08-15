# etcd

A highly-available key value store for shared configuration and service discovery. etcd is inspired by zookeeper and doozer, with a focus on:

* Simple: curl'able user facing API (HTTP+JSON)
* Secure: optional SSL client cert authentication
* Fast: benchmarked 1000s of writes/s per instance
* Reliable: Properly distributed using Raft

Etcd is written in Go and uses the raft consensus algorithm to manage a highly-available replicated log.

github.com/coreos/etcd

<img src="https://i.pinimg.com/736x/54/94/1c/54941cd5b3d08746117f42ebaec895cd.jpg" alt="etcd logo" width="30%" height="auto">

## How to use this Makejail

```sh
hostip=127.0.0.1

appjail makejail \
    -j etcd \
    -f gh+AppJail-makejails/etcd \
    -o alias \
    -o ip4_inherit
appjail start \
    -V ETCD_NAME=etcd0 \
    -V ETCD_ADVERTISE_CLIENT_URLS=http://$hostip:2379 \
    -V ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379 \
    -V ETCD_INITIAL_ADVERTISE_PEER_URLS=http://$hostip:2380 \
    -V ETCD_LISTEN_PEER_URLS=http://0.0.0.0:2380 \
    -V ETCD_INITIAL_CLUSTER_TOKEN=etcd-cluster-1 \
    -V ETCD_INITIAL_CLUSTER="etcd0=http://$hostip:2380" \
    -V ETCD_INITIAL_CLUSTER_STATE=new \
    etcd
```

### Arguments

* `etcd_ajspec` (default: `gh+AppJail-makejails/etcd`): Entry point where the `appjail-ajspec(5)` file is located.
* `etcd_tag` (default: `13.5`): see [#tags](#tags).

### Volumes

| Name      | Owner | Group | Perm | Type | Mountpoint  |
| --------- | ----- | ----- | ---- | ---- | ----------- |
| etcd-data | 1001  | 1001  |  -   |  -   | /etcd       |

### Healthcheckers

* `check_jail`:
  - **description**: Check if the jail is running and restart it if it is not.
  - **options**:
    - `health_cmd`: `host:appjail status -q %j`
    - `recover_cmd`: `host:appjail restart %j`
* `check_pid`:
  - **description**: Check if the PID file exists and the process is still running and restart the jail if it does not.
  - **options**:
    - `health_cmd`: `jail:/healthcheckers/pid_file.sh`
    - `recover_cmd`: `host:appjail restart %j`

## Tags

| Tag                  | Arch    | Version            | Type   | `etcd_version` |
| -------------------- | --------| ------------------ | ------ | -------------- |
| `13.5`           | `amd64` | `13.5-RELEASE` | `thin` |       -        |
| `13.5-34` | `amd64` | `13.5-RELEASE` | `thin` |  `34`   |
| `13.5-35` | `amd64` | `13.5-RELEASE` | `thin` |  `35`   |
| `13.5-36` | `amd64` | `13.5-RELEASE` | `thin` |  `36`   |
| `14.3`           | `amd64` | `14.3-RELEASE` | `thin` |       -        |
| `14.3-34` | `amd64` | `14.3-RELEASE` | `thin` |  `34`   |
| `14.3-35` | `amd64` | `14.3-RELEASE` | `thin` |  `35`   |
| `14.3-36` | `amd64` | `14.3-RELEASE` | `thin` |  `36`   |
