## Running Merritt in Docker

https://github.com/terrywbrady/merritt-docker

+++

## Dependencies for running these containers

https://github.com/terrywbrady/merritt-docker#dependencies

+++

## Git Submodules

+++?code=.gitmodules&lang=plaintext
@[1-12](Build Dependencies - Install JARS to local maven repo)
@[13-27](Microservice Inclusion)

---

## Build dependencies

A base docker image **cdluc3/mrt-dependencies** will be built as a base for other services.
This image contains a populated maven repo.

+++?code=mrt-dependencies/docker-compose.yml&lang=yml
@[9](Image Name)
@[10-12](Dockerfile location)

+++?code=mrt-dependencies/Dockerfile&lang=dockerfile

+++
## List Jar Files in mrt-dependencies

```
docker run --rm -it cdluc3/mrt-dependencies find /root/.m2 -name "*jar"
```
