# Merritt Docker Images and Orchestration

This library is part of the [Merritt Preservation System](https://github.com/CDLUC3/mrt-doc).

The purpose of this repository is to build docker images for local developer
testing of the [Merritt system](https://github.com/cdluc3/mrt-doc/wiki).

#### Diagram

![](https://github.com/CDLUC3/mrt-doc/raw/main/diagrams/docker.mmd.svg)



## Quick Start Guide

### Installation

Log into one of our uc3-mrt-docker-dev hosts.  Run the following commands as normal user.

1. Ensure user writable directory from which to do initial cloning:
   ```
   cd /dpr2/merritt-workspace
   mkdir $USER
   cd $USER
   ```

1. Clone merritt-docker repo and pull in submodules:
   ```
   $BRANCH=java-refactor.ashley
   git clone git@github.com:CDLUC3/merritt-docker.git -b $BRANCH \
     --remote-submodules --recurse-submodules
   ```

1. Build dependencies:
   ```
   cd merritt-docker
   bin/dep_build.sh
   ```


### Usage

1. Set up docker environment vars:
   ```
   source bin/docker_environment.sh
   ```

1. Run core merritt services:
   ```
   cd mrt-services
   docker-compose build
   docker-compose -p merritt up -d
   docker-compose -p merritt down
   ```

For more detailed usage instructions see [Running Merritt Docker](#Running Merritt Docker) below.



## Overview

UC3 maintains a set of EC2 docker hosts for development use.  See [UC3 Service
Inventory](https://uc3-service-inventory.cdlib.org/index.html?table_name=host&column=fqsn&item=uc3-mrt-docker-dev)


### Security

The IAS team has provisioned these to allow us to run docker commands without
root privileges and to limit access by code running in containers to system
resources on the Docker host.

- UC3 developers are members of group `docker.`
- Docker storage lives under `/dpr2/merritt-workspace.`
- UIDs/GIDs are remapped to prevent container users gaining access
  to privileged resources on Docker hosts.  See:
  [Docker User Namespace Mapping](#Docker User Namespace Mapping) for more info.
- IP addresses for containers are drawn from a custom cidr block to prevent
  overlap with real IPs in the CDL network ("10.10.0.0/16).
- Containers which expose network ports are limited to a set of allowed
  ports (8080:8099).  If we need more ports, we can ask IAS to expand this set.


### Dependencies

The following dependencies are needed to build and run this repo.  The goal is
to build a version of the system that can be run entirely from Docker.

- Docker and Docker Compose install
- Access to the CDL maven repo for a couple of pre-built jars
  - TODO: build these from source in the Dockerfile
- CDL LDAP access
- A local maven repo build of mrt-conf jar files
- Access to storage services
- Access to config properties
  - SSM ParameterStore


### Component Overview

The [mrt-services/docker.html](mrt-services/docker.html) is served by the UI and it provides access to individual containers.

| Component   | Image Name | Where the component runs | Notes |
| ----------- | ---------- | ------------------------ | ----- |
| Zookeeper   | zookeeper | Docker | |
| OpenDJ      | ldap      | Docker | |
| MySQL       | cdluc3/mrt-database | Docker | |
| UI          | cdluc3/mrt-dashboard | Docker | |
| Ingest      | cdluc3/mrt-ingest | Docker | |
| Storage     | cdluc3/mrt-storage | Docker | |
| Inventory   | cdluc3/mrt-inventory | Docker | |
| OAI         | cdluc3/mrt-oai | Docker | Runs with Dryad |
| Sword       | cdluc3/mrt-sword | Docker | Runs with Dryad |
| Dryad UI    | cdluc3/mrt-dryad | Docker | |
| Dryad MySQL | mysql:5.7 | Docker | Populated with Rails Migration Script |
| Dryad SOLR  | cdluc3/dryad-solr | Docker | |
| Audit       | cdluc3/mrt-audit | Docker | No-op by default, runs in audit-replic stack |
| Replic      | cdluc3/mrt-audit | Dockdr | No-op by default, runs in audit-replic stack |
| Merritt Init| cdluc3/mrt-init | Docker | Init OAI and inventory services.  Run Dryad notifier. |
| Apache      | cdluc3/mrt-apache | Docker | Simulates character encoding settings in Merritt Apache |
| Minio       | minio/minio | Docker | Containerized storage service - for testing presigned functionality |
| Minio Cmd   | minio/mc | Docker | Initialized bucket in Minio container |
| ALB Simulator | cdluc3/simulate-lambda-alb | Docker | Simulates an ALB running in front of a Lambda for Collection Admin |
| Collection Admin | ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/uc3-mrt-colladmin-lambda | Docker | Merritt collection admin tool |
| Opensearch Dashboard |opensearchproject/opensearch-dashboards | Docker | Full ELK stack for indexing and querying container logs. |


### Current Port Usage
- 8080: Ingest
- 8081: Store
- 8082: Inventory
- 8083: OAI
- 8084: Sword
- 8085: Dryad Solr
- 8086: UI
- 8087: Dryad UI
- 8088: Minio
- 8089: CDL Reserved, do not use
- 8090: Lambda Container, Collection Admin
- 8091: ALB Simulator in front of Lambda Container
- 8092: Replic
- 8093: Audit
- 8094: Opensearch Dashboards
- 8095:
- 8096:
- 8097:
- 8098:
- 8099: Apache



### Elastic Container Repository (ECR)

Most docker-compose scripts in this project rely on AWS Elastic Container
Repository (ECR) for publishing and loading custom docker images.  To 
make use of ECR you must set up the following shell enviromnent vars:
```
export AWS_ACCOUNT_ID=`aws sts get-caller-identity| jq -r .Account`
export AWS_REGION=us-west-2
export ECR_REGISTRY=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
```

You also must set up docker login credentials with our ECR instance.  This
credential occationally must be renewed from time to time:
```
aws ecr get-login-password --region ${AWS_REGION} | \
  docker login --username AWS \
    --password-stdin ${ECR_REGISTRY}
```



### Git Submodules

This repository uses [git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
to pull in git repositories for all micro-services and dependencies which will
be used to run a full stack of Merritt Services.

If you followed the [Installation](#Installation) instructions at the start
of this README, all submodules will have been pulled into your working tree.

To refresh submodule code from upstream repositories:
```
git submodule update --remote
```

See [Working with Git Submodules](#Working with Git Submodules) below for a detailed tutorial and examples.






## Working with Git Submodules

### Quick command reference

```
man git-submodule		# man page
git submodule			# same as `git submodule status`
git submodule status		# list configured submodules
git submodule summary		# show commits in submodule working trees which are not yet recorded in super project

git submodule add -b main --name mrt-integ-tests git@github.com:cdluc3/mrt-integ-tests.git mrt-integ-tests
                        	# add a new submodule to '.gitmodules':
				#   [submodule "mrt-integ-tests"]
				#           path = mrt-integ-tests
				#           url = git@github.com:cdluc3/mrt-integ-tests.git
				#           branch = main
git submodule init mrt-integ-tests
			 	# register new submodule. submodule code will not get pulled
				# into working tree if not registered

git submodule update		# clone/pull code from registerd submodules into defined path
git submodule update --remote	# update using the status of the submodule’s remote-tracking branch
git submodule update --remote --no-fetch 
				# check for updates, but don't fetch new objects from the remote site
```



### Configuring submodules in the super project

The git submodules for this project are configured in file `.gitmodules`.
Here we specify the repository url, branch and the location (path) where
submodule code will be cloned relative to the root of the super project.

Specifying `branch` on all submodules lets us configure different upstream
branches for particular submodules depending on the branch of the super
project.  For example, while refactoring our java builds, the 'java-refactor'
branch in the super project is configured to pull in code from a
'java-refactor' branch for those repos that have been refactored:

```
agould@uc3-mrtdocker02x2-dev:/dpr2/merritt-workspace/agould/merritt-docker> head .gitmodules 
[submodule "mrt-services/dep_core/mrt-core2"]
        path = mrt-services/dep_core/mrt-core2
        url = git@github.com:cdluc3/mrt-core2
        branch = java-refactor
[submodule "mrt-services/ingest/mrt-ingest"]
        path = mrt-services/ingest/mrt-ingest
        url = git@github.com:cdluc3/mrt-ingest
        branch = main
```

To add a new submodule:
```
agould@uc3-mrtdocker02x2-dev:/dpr2/merritt-workspace/agould/merritt-docker> git submodule add \
  -b main --name mrt-integ-tests git@github.com:cdluc3/mrt-integ-tests.git mrt-integ-tests

agould@uc3-mrtdocker02x2-dev:/dpr2/merritt-workspace/agould/merritt-docker> tail -4 .gitmodules
[submodule "mrt-integ-tests"]
        path = mrt-integ-tests
        url = git@github.com:cdluc3/mrt-integ-tests.git
        branch = main
```



### Initializing Submodules

After cloning this repository (or after adding a new submodule) submodules must
be initialized (or registered).  Unregistered submodules are prefixed by a
minus ('-') when running `git submodule status`:
```
merritt-docker> git submodule status
-7aa272c2d81f0a4223e2917d84e042421364dc92 mrt-dependencies/cdl-zk-queue
-0ac8054d899d6e5b7ebb3d46964d406421a1af12 mrt-dependencies/mrt-cloud
-f224861914a480d8bbd1795ab46452444dd72489 mrt-dependencies/mrt-core2
-6a5de6f0fa61d6879e05872883d87bae30b6061e mrt-dependencies/mrt-ingest
[cut]
```

Uninitialized submodules cannot be updated:
```
merritt-docker> git submodule update mrt-dependencies/cdl-zk-queue
Submodule path 'mrt-dependencies/cdl-zk-queue' not initialized
Maybe you want to use 'update --init'?
```

Run `git submodule init` to initialize/register configured submodules:
```
merritt-docker> git submodule init
Submodule 'mrt-dependencies/cdl-zk-queue' (git@github.com:cdluc3/cdl-zk-queue) registered for path 'mrt-dependencies/cdl-zk-queue'
Submodule 'mrt-dependencies/mrt-cloud' (git@github.com:CDLUC3/mrt-cloud) registered for path 'mrt-dependencies/mrt-cloud'
Submodule 'mrt-dependencies/mrt-core2' (git@github.com:cdluc3/mrt-core2) registered for path 'mrt-dependencies/mrt-core2'
Submodule 'mrt-dependencies/mrt-ingest' (git@github.com:cdluc3/mrt-ingest) registered for path 'mrt-dependencies/mrt-ingest'
[cut]
```

It is also possible to de-initialize a particular submodule.  Uninitialized
submodules are ignored when running `git submodule update` for the whole super
project.  This is useful if you are actively developing code within a submodule
and do not want your topic branch to be reverted to the branch configured in
the super project:
```
merritt-docker> git submodule deinit mrt-services/dep_cdlzk/cdl-zk-queue
Cleared directory 'mrt-services/dep_cdlzk/cdl-zk-queue'
Submodule 'mrt-services/dep_cdlzk/cdl-zk-queue' (git@github.com:cdluc3/cdl-zk-queue) unregistered for path 'mrt-services/dep_cdlzk/cdl-zk-queue'
merritt-docker> git submodule status mrt-services/dep_cdlzk/cdl-zk-queue
-b7d9dbf0c4cf29cfa7892e1e52b47b83a113dccc mrt-services/dep_cdlzk/cdl-zk-queue
```



### Updating Submodules

When the super project is initially cloned and even after submodules are
initialized, the directories configured as submodule paths are created, but are
empty.  To populate submodule code run `git submodule update`.  This command
clones submodule code into configured paths within the working tree of the
super project and checks out the commit referenced by the configured branch.




merritt-docker> git submodule update 
Submodule path 'mrt-integ-tests': checked out '3ee46e20621cfaacd75193c56ec58160e2bcb370'
Submodule path 'mrt-services/store/mrt-store': checked out '2231237e0e01188ba4bfacfc817f45853a052777'



### Checking submodule status

The `git submodule status` command lists all configured submodules.  For each one it
lists the currently checked out commit hash, the path relative to the
super project root directory where the submodule code will be cloned, and either
the tag or branch referencing the checked out commit.

Each listing can be prefixed with on of:
- '-': the submodule is not initialized
- '+': the currently checked out submodule commit does not match what's recorded in the super project
- 'U': the submodule has merge conflicts.

In the below example `mrt-integ-tests, mrt-store` have local commits which have
not been recorded in the super project.   `dryad-app, mrt-oai, mrt-sword` are
registerd, which means they will not get pulled into working tree when running
`git submodule update` - i.e. they are being ignored.

``
agould@uc3-mrtdocker02x2-dev:/dpr2/merritt-workspace/agould/merritt-docker> git submodule
+4af817151cdeac252ee66cb5353295105d9986a0 mrt-integ-tests (heads/main)
 56e633f98031be191f2e27a982e6d5ca1501e0ee mrt-services/audit/mrt-audit (sprint-65-4-g56e633f)
 b7d9dbf0c4cf29cfa7892e1e52b47b83a113dccc mrt-services/dep_cdlzk/cdl-zk-queue (sprint-65-8-gb7d9dbf)
 c76edd6b3c6eb183f4015c224d9ff30bb777f02f mrt-services/dep_cloud/mrt-cloud (sprint-65-1-gc76edd6)
 2d17fb9806f18b29321a906a0b81b133e8cca53b mrt-services/dep_core/mrt-core2 (sprint-65-3-g2d17fb9)
 dc430176853925ccb0e2b9c6b28933d6013e9e54 mrt-services/dep_zoo/mrt-zoo (sprint-65)
-407b806305b3a79e8d9bb826fd08d5592112bb88 mrt-services/dryad/dryad-app (v0.7.17a-26-g407b80630)
 fa969c5acceef9586dea30fa1098e6c5209861c9 mrt-services/ingest/mrt-ingest (sprint-64-main-30-gfa969c5)
 d35df074b79f98a8be84d27fe0c59397b2787ee2 mrt-services/inventory/mrt-inventory (sprint-64-3-gd35df07)
 239c258b66c3bd0005f59a4aaa482bdf92ec4c93 mrt-services/mrt-admin-lambda (sprint-65-main-18-g239c258)
-b0b601c7e3ccb187c7273e9a0def396aaf74c323 mrt-services/oai/mrt-oai (sprint-65)
 8cc0e38d3b31aaa444748386adc497c5fe923071 mrt-services/replic/mrt-replic (sprint-64-7-g8cc0e38)
+b182d03d4f4c0df679372549997239735a95d155 mrt-services/store/mrt-store (sprint-65-15-gb182d03)
-2d1a521ae02571f4bde85701411f09c781a69a9a mrt-services/sword/mrt-sword (sprint-65)
 dffd8a712a6ec2ac2ab3c30395cb8600ec682bf7 mrt-services/ui/mrt-dashboard (sprint-65-main)
```


Running `git status` also shows which submodules are out-of-sync with what is
recorded in the super project.
```
agould@uc3-mrtdocker02x2-dev:/dpr2/merritt-workspace/agould/merritt-docker> git status
On branch opensearch

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   mrt-integ-tests (new commits)
        modified:   mrt-services/store/mrt-store (new commits)
```


The `git submodule summary` command shows which commits differ:
```
agould@uc3-mrtdocker02x2-dev:/dpr2/merritt-workspace/agould/merritt-docker> git submodule summary 
* mrt-integ-tests 3ee46e2...8e9733d (3):
  > refine perms
  > fix download folder accessibility
  > fix integ tests

* mrt-services/store/mrt-store 2231237...8a924e6 (13):
  < tag or branch name
  < MAVEN_HOME
  < troubleshoot
  < ${maven.home}/conf/settings.xml
  < /dev/null settings file
  < search for settings.xml
```






## Build and Start Services in VSCode

See [.vscode/settings.json](.vscode/settings.json) for build and stack initiation configurations.

## Build instructions

Services

```bash
cd mrt-services
docker-compose build
```

### Service Start

```bash
docker-compose -p merritt up
```

To verify running processes and ports
```bash
docker ps -a
```

To view persistent volumes
```bash
docker volume ls
```

To view logs for a specific container
```bash
docker logs ingest
```

Tail view logs for a specific container
```bash
docker logs -f inventory
```

To view the docker network
```bash
docker network ls
```

### Service Stop

```bash
docker-compose -p merritt down
```

## Other useful tasks

### List Zookeeper Queues
`docker exec -it zoo zkCli.sh ls /`

### Dump the ingest queue
`docker exec -it zoo listIngest.sh`

### Dump the inventory queue
`docker exec -it zoo listInventory.sh`

### Mysql Session
`docker exec -it db-container mysql -u user --password=password --database=db-name`


## Repo Init

```
git submodule update --remote --recursive --init -- .
git submodule update --remote --recursive -- .
```

## Running Merritt Docker


### Running docker-compose

Set up docker environment vars:
```
source bin/docker_environment.sh
```

Run core merritt services:
```
cd mrt-services
docker-compose build
docker-compose -p merritt up -d
docker-compose -p merritt down
```

Rebuild and run after minor changes to an image:
```
docker-compose -p merritt up -d --build
```

Run Merrit with Dryad:
```
docker-compose -p merritt -f docker-compose.yml -f dryad.yml up -d --build
docker-compose -p merritt -f docker-compose.yml -f dryad.yml down
```

Run Merrit with Opensearch:
```
docker-compose -p merritt -f docker-compose.yml -f opensearch.yml up -d --build
docker-compose -p merritt -f docker-compose.yml -f opensearch.yml down
```


### Helper docker-compose Files

| Goal | File | Comment |
| -- | -- | -- |
| Debug java applications | in Eclipse | Use JPDA Debug on Port 8000 |
|  | in VSCode | Launch a remote debugger [launch.json](launch.json) |
|  | [debug-ingest.yml](mrt-services/debug-ingest.yml) |  |
|  | [debug-inventory.yml](mrt-services/debug-inventory.yml) |
|  | [debug-oai.yml](mrt-services/debug-oai.yml) |
|  | [debug-storage.yml](mrt-services/debug-storage.yml) |
| UI Testing from mrt-dashboard branch | [ui.yml](mrt-services/ui.yml) | Selectively mount code directories from mrt-dashboard to the UI container |
| EC2 Config | [ec2.yml](mrt-services/ec2.yml) | Volume and hostname overrides EC2 dns and paths |
| Localhost Config | [local.yml](mrt-services/local.yml) | hostname |
| Dryad | [dryad.yml](mrt-services/dryad.yml) | Configuration of Dryad services and Merritt services only used by Dryad |
| Dryad Volume Config | [use-volume-dryad.yml](mrt-services/use-volume-dryad.yml) | In addition to the 3 Merritt volumes, persist Dryad mysql and Dryad solr to a Docker volume |
| Audit Replic | [audit-replic.yml](mrt-services/audit-replic.yml) | Configuration of Audit Replic services for Merritt |
| Opensearch Dashboards | [opensearch.yml](mrt-services/opensearch.yml) | Configuration of Full Opensearch stack |
