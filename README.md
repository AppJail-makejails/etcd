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
appjail makejail \
    -j etcd \
    -f gh+AppJail-makejails/etcd \
    -o virtualnet=":<random> default" \
    -o nat
```

### Arguments

* `etcd_ajspec` (default: `gh+AppJail-makejails/etcd`): Entry point where the `appjail-ajspec(5)` file is located.
* `etcd_tag` (default: `13.4`): see [#tags](#tags).

## Tags

| Tag           | Arch    | Version            | Type   |
| ------------- | --------| ------------------ | ------ |
| `13.4`    | `amd64` | `13.4-RELEASE` | `thin` |
| `13.4-31` | `amd64` | `13.4-RELEASE` | `thin` |
| `13.4-32` | `amd64` | `13.4-RELEASE` | `thin` |
| `13.4-33` | `amd64` | `13.4-RELEASE` | `thin` |
| `13.4-34` | `amd64` | `13.4-RELEASE` | `thin` |
| `14.2`    | `amd64` | `14.2-RELEASE` | `thin` |
| `14.2-31` | `amd64` | `14.2-RELEASE` | `thin` |
| `14.2-32` | `amd64` | `14.2-RELEASE` | `thin` |
| `14.2-33` | `amd64` | `14.2-RELEASE` | `thin` |
| `14.2-34` | `amd64` | `14.2-RELEASE` | `thin` |
