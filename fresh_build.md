# Merritt Build

The [bin/fresh_build.sh](bin/fresh_build.sh) script performs the following actions
- Clone merritt-docker which contains submodules that link to all other Merritt code modules
- Clone submodules
- Checkout submoule branches identified in [build-config.yml](build-config.yml)
- Run docker and maven builds

```
fresh_build.sh 
  -h; display usage message
  -B merritt-docker-branch to check out; defaut: main
  -C build-config-profile-name entry, see build-config.yml for options; default: main
  -m maven-profile to use for maven builts, options: uc3, ingest, inventory, store, audit, replic; default: uc3
  -p tag-name-for-published-artifacts, part of generated war files; default: testall
  -t checkout-repo, branch or tag to checkout when buiding a specific maven profiile, detault: main
  -w workidir, working directory in which build will run
    default: /apps/dpr2/merritt-workspace/daily-builds/[merritt-docker-branch].[build-config-profile-name]/merritt-docker
      if path contains 'merritt-workspace/daily-builds', the directory will be recreated
  -j workidir, Jenkins working directory in which build will run.  Jenkins will not create a 'merritt-docker' directory for clone
  -e; email build results
```

## Jeninks pipeline
- [Jenkinsfile](Jenkinsfile)

## Dependencies required for the script to run
- ECR Access
- docker and docker-compose
- maven
- trivy
- python3 (for pyyaml)

## Runtime Options

- Daily build/scan ALL Merritt docker images
  - `fresh_build.sh -e`
  - same as the following
  - `fresh_build.sh -B main -C main -m uc3 -e`
- Daily build/scan ALL Merritt docker images defined in branch "foo"
  - `fresh_build.sh -B foo`
- Daily build/scan ALL Merritt docker images defined in build config "bar" residing in merritt-docker branch "foo"
  - `fresh_build.sh -B foo -C bar`
  - a build config of "bar" must be added to build-config.yml
- Build my local workspace (all services)
  - `fresh_build.sh -C main-buildonly -w $PWD`
- Stage deploy build for all dependencies of core/cloud/zoo 
  - Current: Jenkins mrt-core-int-test-all 
  - `fresh_build.sh -C main-test -p tag`
- Stage deploy build for all dependencies of core/cloud/zoo defined in build config "bar" residing in merritt-docker branch "foo"
  - Current: Jenkins mrt-core-int-test-all 
  - `fresh_build.sh -B foo -C bar -p tag`
  - a build config of "bar" must be added to build-config.yml

## Runtime Options for a Specific microservice
- Build tagged ingest
  - Current:  Jenkins mrt-ingest-refactor
  - `fresh_build.sh -C main-test -m ingest -t tag`
- Build branch ingest
  - Current:  Jenkins mrt-ingest-refactor-dev
  - `fresh_build.sh -C main-test -m ingest -t branch`
- Build tagged store
  - Current:  Jenkins mrt-store-refactor
  - `fresh_build.sh -C main-test -m store -t tag`
- Build branch store
  - Current:  Jenkins mrt-store-refactor-dev
  - `fresh_build.sh -C main-test -m store -t branch`
- Build tagged inventory
  - Current:  Jenkins mrt-inventory-refactor
  - `fresh_build.sh -C main-test -m inventory -t tag`
- Build branch inventory
  - Current:  Jenkins mrt-inventory-refactor-dev
  - `fresh_build.sh -C main-test -m inventory -t branch`
- Build tagged audit
  - Current:  Jenkins mrt-audit-refactor
  - `fresh_build.sh -C main-test -m audit -t tag`
- Build branch audit
  - Current:  Jenkins mrt-audit-refactor-dev
  - `fresh_build.sh -C main-test -m audit -t branch`
- Build tagged replic
  - Current:  Jenkins mrt-replic-refactor
  - `fresh_build.sh -C main-test -m replic -t tag`
- Build branch replic
  - Current:  Jenkins mrt-replic-refactor-dev
  - `fresh_build.sh -C main-test -m replic -t branch`

## Existing Jobs to Retire
- Rebuild docker integration test images 
  - Current: Jenkins Docker Images for Integration Testing
  - RETIRE - see Build/test all dependencies
- Rebuild docker images for Merritt libraries
  - Current: dep_build.sh 
  - RETIRE - now a part of build jobs

## Jobs that are not rolled into the new build script
- Dependency analyze job 
  - Current: Jenkins mrt-core-dependencies-all 
  - RETIRE Jenkins Job
  - Current and future: `dependencies.sh`
- Compare deps for WAR and IT WAR 
  - Curent and future: `it_analyze.sh`

## Code to retire
- https://github.com/CDLUC3/mrt-jenkins/
- https://github.com/CDLUC3/mrt-cloud/blob/main/Jenkinsfile
- https://github.com/CDLUC3/mrt-ingest/blob/main/Jenkinsfile
- https://github.com/CDLUC3/mrt-inventory/blob/main/Jenkinsfile
- https://github.com/CDLUC3/mrt-store/blob/main/Jenkinsfile
- https://github.com/CDLUC3/mrt-audit/blob/main/Jenkinsfile
- https://github.com/CDLUC3/mrt-replic/blob/main/Jenkinsfile
- https://github.com/CDLUC3/mrt-jenkins/blob/main/TestAll.Jenkinsfile
- https://github.com/CDLUC3/mrt-jenkins/blob/main/DependencyAll.Jenkinsfile
- https://github.com/CDLUC3/mrt-jenkins/tree/main/jenkins-config (obsolete pipeline configs)
