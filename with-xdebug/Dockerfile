FROM registry.gitlab.com/made-dev/docker-images/alpine-nginx-php8:latest

LABEL org.opencontainers.image.source="https://github.com/made/docker_alpine-node"

ARG XDEBUG_VERSION='3.0.2'

USER root

# install all the phpize dependencies and the specified xdebug version
RUN apk --no-cache add \
    autoconf=2.69-r3 \
    dpkg-dev=1.20.6-r0 \
    dpkg=1.20.6-r0 \
    file=5.39-r0 \
    g++=10.2.1_pre1-r3 \
    gcc=10.2.1_pre1-r3 \
    libc-dev=0.7.2-r3 \
    make=4.3-r0 \
    pkgconf=1.7.3-r0 \
    re2c=1.3-r1 \
    && pecl install xdebug-${XDEBUG_VERSION} \
    && docker-php-ext-enable xdebug

COPY ./config/xdebug.ini ${PHP_INI_DIR}/conf.d/xdebug.ini

USER nginx

