FROM tiredofit/nginx-php-fpm:7.0-latest
MAINTAINER Dave Conroy <dave at tiredofit dot ca>

### Dependency Installation
  RUN apk update && \
      apk add \
             git \
             && \
      rm -rf /var/cache/apk/*


### Files Addition
  ADD install /
