FROM php:8.0.1-fpm-alpine3.13

LABEL maintainer="Made Team <contact@made.dev>"

# Build arguments which are only needed during the build of this base image (BUILD).
# Can be overriden by passing them as --build-args
ARG COMPOSER_VERSION='2.0.8-r0'
ARG NGINX_VERSION='1.18.0-r13'
ARG NPM_VERSION='14.15.4-r0'
ARG SUPERVISOR_VERSION='4.2.1-r0'
ARG SUDO_VERSION='1.9.5p2-r0'

ARG USER='nginx'

# Default ENV variables. These can be overridden by passing ENV when running the container (RUN).
ENV APP_ENV=prod \
    APP_DEBUG=false \
    LOG_LEVEL=warn \
    PROJECT_ROOT='/var/www/html' \
    DOCUMENT_ROOT='/var/www/html' \
    PATH="$PATH:/var/scripts"

RUN apk update && apk --no-cache add \
    composer=${COMPOSER_VERSION} \
    nginx=${NGINX_VERSION} \
    npm=${NPM_VERSION} \
    supervisor=${SUPERVISOR_VERSION} \
    sudo=${SUDO_VERSION}

    # To install php extensions use -> docker-php-ext-install
    # @see https://github.com/mlocati/docker-php-extension-installer

# Copy over the configuration files
COPY ./scripts /var/scripts
COPY ./config/php/php-docker.ini $PHP_INI_DIR/conf.d/php-docker.ini
COPY ./config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./config/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /run/nginx \
    && chown -R $USER:$USER /run/nginx \
    && chmod -R a+x /var/scripts \
    && mkdir -p $PROJECT_ROOT \
    && mkdir -p /var/cache/nginx

# Make sure files/folders needed by the processes are accessable when they run under the nginx user
RUN chown -R nginx:nginx $PROJECT_ROOT && \
  chown -R nginx:nginx /var/lib/nginx && \
  chown -R nginx:nginx /var/cache/nginx && \
  chown -R nginx:nginx /var/log/nginx && \
  chown -R nginx:nginx /etc/nginx/ && \
  touch /run/nginx.pid && \
  touch /run/supervisord.pid && \
  chown nginx:nginx /run/nginx.pid && \
  chown nginx:nginx /run/supervisord.pid && \
  echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER && \
  chmod 0440 /etc/sudoers.d/$USER

USER $USER

# Preparing the environment
WORKDIR ${PROJECT_ROOT}

# Expose the ports the application should be reachable on
# To actually publish the port when running the container, use the -p flag on docker run to publish
EXPOSE 8000

# Startup script
CMD [ "startup" ]
