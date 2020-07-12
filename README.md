# statik-docker-alpine

This is a repository containing a `Dockerfile` that can be used to build the
static site generator [Statik](https://github.com/thanethomson/statik).

I haven't taken the time to figure out how to get this onto DockerHub.  Sorry.

## Details

* Statik version: 0.23.0 via PyPI
* Base image: [python:3.7.8-alpine3.12](https://hub.docker.com/_/python)
* Container directory: `/app`
* Container UID/GID: `1000:1000`
* Container exposed TCP port: 8000
* `bash`, `curl`, `git`, and `wget` are included to aid in troubleshooting

The container should be run with non-root credentials (read: the container
should be run as your own UID/GID), due to use of a volume map.  This ensures
files created within the container will have your UID/GID on the host side.
**Docker containers using volume maps should not normally be run as root!**
I try my best to comply with many different "best practises" for Docker
when applicable:

* https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
* https://snyk.io/blog/10-docker-image-security-best-practices/
* https://developers.redhat.com/blog/2016/02/24/10-things-to-avoid-in-docker-containers/

# Building

```
$ git clone https://github.com/koitsu/statik-docker-alpine.git
$ cd statik-docker-alpine
$ docker build --rm -t statik-docker-alpine:latest .
```

# Usage Examples

```
$ cd my-statik-site
$ docker run --rm -it -u $(id -u):$(id -g) -v $PWD:/app statik-docker-alpine:latest statik --help
$ docker run --rm -it -u $(id -u):$(id -g) -v $PWD:/app statik-docker-alpine:latest statik --quickstart
$ cd blog
$ docker run --rm -it -u $(id -u):$(id -g) -v $PWD:/app -p 8000:8000 statik-docker-alpine:latest statik serve --host 0.0.0.0 --watch --no-browser
^C
$ docker run --rm -it -u $(id -u):$(id -g) -v $PWD:/app statik-docker-alpine:latest bash
```
