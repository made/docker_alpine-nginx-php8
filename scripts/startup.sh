#!/bin/sh

# PHP Memory limit settings
if [ -n "$PHP_MEMORY_LIMIT" ];then
  # Check if memory_limit already exists. If so, then relpace the value.
  # Otherwise just echo the line into the file.
  result=$(sudo grep "^[^#;]"  "$PHP_INI_DIR"/conf.d/php-docker.ini | grep -c memory_limit)
  if [ "$result" -gt "0" ]; then
    sudo sed -i "s/^memory_limit.*/memory_limit=$PHP_MEMORY_LIMIT/g" "$PHP_INI_DIR"/conf.d/php-docker.ini
  else
    echo "memory_limit=$PHP_MEMORY_LIMIT" | sudo tee -a "$PHP_INI_DIR"/conf.d/php-docker.ini > /dev/null
  fi
fi

# If the ENV DOCUMENT_ROOT has been set, then it should be overriden in the nginx config.
test "$DOCUMENT_ROOT" && echo "$DOCUMENT_ROOT"
if [ -n "$DOCUMENT_ROOT" ]; then
  REPLACE="$(echo "$DOCUMENT_ROOT" | sed 's/\//\\\//g')"
  sudo sed -i "s/\/var\/www\/html[^\"]*/$REPLACE;/g" /etc/nginx/nginx.conf
fi

# Fix the owner group/user of the PROJECT_ROOT
sudo chown -R www-data:www-data $PROJECT_ROOT

# Now run supervisor
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

