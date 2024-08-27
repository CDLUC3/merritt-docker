Docker User Namespace Mapping
=============================

https://docs.docker.com/engine/security/userns-remap/

For security reasons, IAS configures Merritt-docker hosts to remap user
namespace so that users in containers cannot access root owned resources on
docker host.  This is configured by applying the `userns-remap` param in
`/etc/docker/daemon.json` and setting uid/gid values in files 
`/etc/subuid, /etc/subgid`.

```
~> cat /etc/docker/daemon.json
{
    "userns-remap": "dpr2",
    "data-root": "/apps/dpr2/docker-system-storage",
    "default-address-pools": [ {"base":"10.10.0.0/16","size":24} ]
}

~> cat /etc/subuid 
dpr2:5071:65536

~> cat /etc/subgid
dpr2:5071:65536
```

The above configuration makes it so the UID of a user inside a docker container
with UID 100 will be remapped to UID 5171 on the docker host based on the value
set in `/etc/subuid` (100 + 5071).  More to the point, if we set `user: root`
in a `docker-compose.yml` config file, the docker host remaps this to 5071
(dpr2). Any host resources not accessible by dpr2 UID will not be accessible in
the container, even if we do a volume mapping.

I run up against this when trying to deploy a full ELK stack in merritt-docker.
I want to run a Filebeats image which has the magic ability to autodetect and
forward to logstash the output streams of all running containers on the docker
host.  It does this by setting up a volume bind mount to `/var/run/docker.sock`

From `merritt-docker/mrt-services/opensearch.yml`:
```
  filebeat:
    image: ${ECR_REGISTRY}/filebeat:dev
    container_name: filebeat
    build:
      context: opensearch/filebeat
      dockerfile: Dockerfile
    user: root
    volumes:
    - /var/run/docker.sock:/var/run/docker.sock:ro
    - /apps/dpr2/docker-system-storage/containers:/var/lib/docker/containers:ro
```

The permissions for `/var/lib/docker.sock` on the docker host are thus:
```
~> ll /var/run/docker.sock 
srw-rw---- 1 root docker 0 Feb 11 08:23 /var/run/docker.sock
```

After user namespace remapping, the root user inside my filebeats container has
an effective id of `5071:5071` or `dpr2:dpr2`. Filebeat container halts
because it does not have read access to `/var/lib/docker.sock`:
```
/etc/docker> docker logs filebeat/
[cut]
2022-02-11T17:38:43.816Z        ERROR   instance/beat.go:1015   Exiting: error in autodiscover provider settings: error setting up docker autodiscover provider: Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/info": dial unix /var/run/docker.sock: connect: permission denied
```

The solution Joe and I came up with is to change the group namespace mapping to
match that of the docker group, since docker group has read access to
`/var/run/docker.sock` on the docker host.

Now uid 0 inside the container maps to 5071 (dpr2 user) on the host, and gid 0
inside the container maps to 5161 (docker group) on the host, and so root
inside the container gains read access to `/var/run/docker.sock` by virtue
group read permissions on the docker host:

```
[root@docker ~]# cat /etc/docker/daemon.json
{
    "userns-remap": "dpr2:docker",
    "data-root": "/apps/dpr2/docker-system-storage",
    "default-address-pools": [ {"base":"10.10.0.0/16","size":24} ]
}
[root@docker ~]# cat /etc/subuid
dpr2:5071:65536

[root@docker ~]# cat /etc/subgid
dpr2:5161:65536
```


### Docker Data Path Gotcha

A by-prodoct of user namespace remapping is docker renames data directory where
it keeps docker images and containers.  Normally this is `/var/lib/docker/`.
In our environment it is under `/apps/dpr2/docker-system-storage/`.  However,
when user namespace remapping is in play docker adds a path component based on
`subuid:subgid` to the base docker data directory:

```
/apps/dpr2/docker-system-storage/5071:5161/
```

When we changed the value in `/etc/subgid`, docker created a whole new data area.
As a result we each had to rebuild all our docker images.


