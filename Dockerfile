FROM tiredofit/nginx-php-fpm:7.3
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

ENV SSP_VERSION=1.3 \
    PHP_ENABLE_LDAP=TRUE \
    PHP_ENABLE_CREATE_SAMPLE_PHP=FALSE \
    NGINX_WEBROOT="/www/ssp" \
    ZABBIX_HOSTNAME=ssp-app

### Dependency Installation
  RUN set -x && \
  	  apk update && \
      apk upgrade && \
      mkdir -p /assets/install && \
      echo '** Downloading Self Service Password version '${SSP_VERSION} && \
      curl -sSL -o /assets/install/v${SSP_VERSION}.tar.gz https://github.com/ltb-project/self-service-password/archive/v${SSP_VERSION}.tar.gz && \
      rm -rf /var/cache/apk/*

### Files Addition
  ADD install /
