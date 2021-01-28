# Alpine production docker image with nginx and php 8

:warning: This image should not be used yet. It is not completely done. :warning:

This is the production image containing

- alpine
- nginx
- php-fpm-8
- composer
- npm

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
breaking changes can destroy a build, a specific version is used here.

The environment variables `APP_DEBUG`, `LOG_LEVEL` have to also be implemented into the application to be used.

## Available binary scripts

### run-git-clone
This command clones as the user nginx, which has the web access and all necessary permissions and configuration for.
You have to pass the url of the repository as argument.    
`run-git-clone <url>`

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

## Symfony
Make sure to pass the env `DOCUMENT_ROOT=/var/www/html/public` because the index.php is in the public folder.    
`PROJECT_ROOT` stays the same.
