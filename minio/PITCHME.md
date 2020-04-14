#### Adding Minio to Merritt Docker

A Merritt Development environment exists in Docker
- https://github.com/cdluc3/merritt-docker
- [Merritt Docker - CDL Network](http://uc3-mrtdocker2-stg.cdlib.org:8089/)

+++

#### Merritt Development Environment

- Has its own database (metadata)
- Has its own storage service (digital files)
  - Pairtree - A legacy storage service created by CDL
  - **Minio - S3 compatible storage solution**
- Currently reuses the staging LDAP server for permissions

+++

#### What is Minio?

- Minio: https://min.io/
- Offer S3 compatible storage at a lower const
- Merritt uses Minio offered by SDSC
- Minio is available as a docker image!
  - https://hub.docker.com/r/minio/minio/

+++

#### Why Integrate with the Docker Stack?

- Merritt and Dryad are making use of presigned URL's
  - simplify system throughput
  - supported by AWS S3, Minio, and Wasabi storage  
- Need a compatible service in the docker stack to test this functionality  

+++

#### Exploring a Minio backed Merritt Collection in Docker
(need Merritt permissions)

- [Merritt Collection Page](http://uc3-mrtdocker2-stg.cdlib.org:8089/m/cdl_dryaddev)

+++

#### Exploring the Storage Service

- [Minio Container UI](http://uc3-mrtdocker2-stg.cdlib.org:8088/minio/login)

+++

#### Docker Configuration

- [Docker Compose](https://github.com/CDLUC3/merritt-docker/blob/master/mrt-services/docker-compose.yml#L140-L163)

+++

#### Minio Container

```yaml
# For pre-signed URL testing, you must create an entry in your /etc/hosts file to redirect my-minio-localhost-alias:9000 to localhost:9000.
minio:
  container_name: minio
  image: minio/minio
  ports:
  - published: 9000
    target: 9000
  command: server /data
  networks:
    merrittnet:
      aliases:
      - my-minio-localhost-alias
      - ${HOSTNAME}
```

+++

#### Minio Configuration

```yaml
# When initializing the minio container for the first time, you will need to create an initial bucket named my-bucket.
minio-mc:
  container_name: minio-mc
  image: minio/mc
  entrypoint: >
    /bin/sh -c "
    sleep 15;
    mc config host add docker http://minio:9000 minioadmin minioadmin;
    mc mb docker/my-bucket;
    "
  networks:
    merrittnet:
```

+++

#### Minio Node Table for localhost

```
node.1=8012|pair-docker
node.2=7001|pair-docker
node.3=7777|minio-docker|my-bucket

serviceType=minio
endPoint=http://my-minio-localhost-alias:9000
accessKey=minioadmin
secretKey=minioadmin
```

+++

#### Minio Node Table for ec2

```
node.1=8012|pair-docker
node.2=7001|pair-docker
node.3=7777|minio-docker-ec2|my-bucket

serviceType=minio
endPoint=http://uc3-mrtdocker2-stg.cdlib.org:8088
accessKey=minioadmin
secretKey=minioadmin
```

+++

#### Hostname Troubleshooting with the Minio Container

- https://stackoverflow.com/a/61214488/3846548
