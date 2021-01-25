FROM registry.gitlab.com/made-dev/docker-images/alpine-nginx-php8:0.1.1

ARG XDEBUG_VERSION=3.0.2

USER root

# install all the phpize dependencies and the specified xdebug version
RUN apk add --no-cache $PHPIZE_DEPS \
    && pecl install xdebug-$XDEBUG_VERSION \
    && docker-php-ext-enable xdebug

COPY ./config/xdebug.ini $PHP_INI_DIR/conf.d/xdebug.ini

USER nginx

