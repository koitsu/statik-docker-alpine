FROM python:3.7.8-alpine3.12

RUN set -e -x \
&& addgroup -g 1000 -S statik \
&& adduser -u 1000 -D -S -G statik statik \
&& apk update \
&& apk add bash curl git libpq wget \
&& apk add --virtual build-deps build-base python3-dev libffi-dev openssl-dev postgresql-dev \
&& PIP_NO_CACHE_DIR=1 pip3 install statik==0.23.0 Pygments==2.6.1 \
&& apk del --purge build-deps \
&& rm -fr /var/cache/apk/*

USER statik:statik
WORKDIR /app
EXPOSE 8000
CMD ["statik"]
