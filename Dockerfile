FROM docker.io/tiredofit/nginx-php-fpm:7.4
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

ENV SSP_VERSION=1.3 \
    PHP_ENABLE_LDAP=TRUE \
    PHP_ENABLE_CREATE_SAMPLE_PHP=FALSE \
    NGINX_SITES_ENABLED=ssp \
    NGINX_WEBROOT="/www/ssp" \
    IMAGE_NAME="tiredofit/self-service-password" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-self-service-password/"

### Dependency Installation
 RUN set -x && \
     apk update && \
     apk upgrade && \
     mkdir -p /assets/install && \
     curl -sSL -o /assets/install/v${SSP_VERSION}.tar.gz https://github.com/ltb-project/self-service-password/archive/v${SSP_VERSION}.tar.gz && \
     rm -rf /var/cache/apk/*

### Files Addition
ADD install /
