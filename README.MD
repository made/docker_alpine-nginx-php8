# Alpine production docker image with nginx and php 8

This is the production image containing

- nginx
- php-fpm-8

## Supported ENV and ARG

All variables are optional.

| Stage | Variable              | Description                               | Default                         |
| ----- | --------------------- | ----------------------------------------- | ------------------------------- |
| BUILD | COMPOSER_VERSION      | Set version of composer to install        | 2.0.8-r0                        |
| BUILD | NGINX_VERSION         | Set version of nginx to install           | 1.18.0-r13                      |
| BUILD | NPM_VERSION           | Set version of npm to install             | 14.15.4-r0                      |
| RUN   | PROJECT_ROOT          | Define the directory of the project       | /var/www/html                   |
| RUN   | DOCUMENT_ROOT         | Define the directory of the public web    | /var/www/html                   |
| RUN   | APP_ENV               | Set application environment               | prod                            |
| RUN   | APP_DEBUG             | Set application debug                     | false                           |
| RUN   | LOG_LEVEL             | Set application log level                 | warn                            |
| RUN   | PHP_MEMORY_LIMIT      | Set the memory_limit in php.ini           | 128M                            |

The `*_VERSION`environment variables specify the version, which is installed from the alpine package manager. So no
breaking changes can destory a build, a specific version is used here.

The environment variables `APP_DEBUG`, `LOG_LEVEL` have to also be implemented into the application to be used.

## Available binary scripts

### run-git-clone

This command clones as the user nginx, which has the web access and all necessary permissions and configuration for.
Make sure, the ssh key to pull the repository is added.
You have to pass the url of the repository as argument.

### run-composer-install

As per default this script uses `APP_ENV` to get its environment.  
Only if `APP_ENV` is set to `prod` composer installs as recommended for productive environments.

### run-npm-install

As per default this script uses `APP_ENV` to get its environment. If you define the environment variable `NODE_ENV` it
overrides the environment for all npm scripts. if NODE_ENV and APP_ENV is undefined the fallback is dev.

### run-gulp

Running gulp tasks is easy, just execute `run-gulp`.    
The default name of the gulp command is `default`. But you can override this by adding a parameter.    
Let's say you want to run the gulp task `compile-images`, then you just have to run `run-gulp compile-images`.

## Run the Container using the built image

```bash
# Running the container
docker run --rm -it \
  --volume /usr/local/var/www/made/document-generator-playground/:/var/www/html \
  -p 8999:8000 \ 
  -e DOCUMENT_ROOT=/var/www/html/public \
  -e PHP_MEMORY_LIMIT=512M \
  --name foo \
  registry.made.dev/docker/alpine-nginx-php8
```

### Symfony

Make sure to pass the env `DOCUMENT_ROOT=/var/www/html/public` because the index.php is in the public folder.    
PROJECT_ENV stays the same.

## Sources

- [PHP FPM and nginx error logging to stdout](https://gist.github.com/joerx/87c6755023d2817154b41264311fcfe6)
- [Inspiration](https://gist.github.com/md5/d9206eacb5a0ff5d6be0)
- [PID issue in certain nginx image versions](https://github.com/gliderlabs/docker-alpine/issues/185)
- [Connect Nginx to php-fpm](https://www.tecmint.com/connect-nginx-to-php-fpm/)
- [Connection refused while connecting to upstream](https://serverfault.com/questions/317393/connect-failed-111-connection-refused-while-connecting-to-upstream)
- [Mounted volumes not correct permissions](https://github.com/nginxinc/docker-nginx/issues/177)
- [Dockerise PHP application with nginx and php-fpm](http://geekyplatypus.com/dockerise-your-php-application-with-nginx-and-php7-fpm/)
- [supervisor example configuration](https://github.com/makasim/docker-nginx-php-fpm-supervisor/blob/master/supervisor.conf)
- [Nginx 403 Forbidden](https://stackoverflow.com/a/38046124)
- [Primary script unknown](https://serverfault.com/questions/517190/nginx-1-fastcgi-sent-in-stderr-primary-script-unknown)
- [Nginx 404 Not found](https://serverfault.com/questions/610944/nginx-throws-404-only-on-php-scripts-using-php-fpm)
