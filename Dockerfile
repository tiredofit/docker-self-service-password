ARG PHP_VERSION=7.4
ARG DISTRO="alpine"

FROM docker.io/tiredofit/nginx-php-fpm:${PHP_VERSION}-${DISTRO}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ENV SSP_VERSION=1.3 \
    PHP_ENABLE_LDAP=TRUE \
    PHP_ENABLE_CREATE_SAMPLE_PHP=FALSE \
    NGINX_SITE_ENABLED=ssp \
    NGINX_WEBROOT="/www/ssp" \
    IMAGE_NAME="tiredofit/self-service-password" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-self-service-password/"

 RUN source /assets/functions/00-container && \
     set -x && \
     package update && \
     package upgrade && \
     mkdir -p /assets/install && \
     curl -sSL -o /assets/install/v${SSP_VERSION}.tar.gz https://github.com/ltb-project/self-service-password/archive/v${SSP_VERSION}.tar.gz && \
     package cleanup

ADD install /
