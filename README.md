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
* Additional programs: `bash`, `curl`, `git`, `wget`
* Additional Python packages:
  * [Pygments](https://pypi.org/project/Pygments/) 2.6.1 via PyPI

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

The below examples all use a simple wrapper script called `statikdocker`
for convenience, and to make the examples shorter in width.  Be sure
to `chmod u+x` the script and place it somewhere in your `$PATH`:

```bash
#!/bin/sh
exec docker run --rm -it \
  -u $(id -u):$(id -g) \
  -v $PWD:/app \
  -p 8000:8000 \
  statik-docker-alpine:latest $*
```

```
$ cd my-site
$ statikdocker statik --help
$ statikdocker statik --quickstart
$ statikdocker statik --host 0.0.0.0 --watch
$ statikdocker bash
```

## Generating Pygments CSS Files

Pygments has
[many visual styles](https://github.com/pygments/pygments/tree/master/pygments/styles)
to choose from when it comes to colourising source code in over 500
programming languages.  You can see them by
[using their demo site](https://pygments.org/demo/).
Once you find one you like, you can generate the applicable CSS file using
[their pygmentize program](https://pygments.org/docs/cmdline/#generating-styles)
using the Docker container.

The below selects the `monokai` visual style, names the CSS class `highlight`, and
outputs the CSS to a file named `highlight.css` in your container directory:

```
$ cd my-site
$ statikdocker pygmentize -S monokai -f html -a .highlight -o highlight.css
```
