# Alpine production docker image with nginx and php 8

:warning: This image is still in a very early release and my contain bugs or future versions contain breaking changes.
It is not completely done. So if you use it, use it with caution.
But we are accepting issues and suggestions already
:warning:

This is the production image containing

- alpine
- nginx
- php-fpm-8
- composer

## Supported ENV and ARG

All variables are optional.

| Stage | Variable              | Description                               | Default                         |
| ----- | --------------------- | ----------------------------------------- | ------------------------------- |
| BUILD | COMPOSER_VERSION      | Set version of composer to install        | 2.0.8-r0                        |
| BUILD | NGINX_VERSION         | Set version of nginx to install           | 1.18.0-r13                      |
| BUILD | SUPERVISOR_VERSION    | Set version of supervisor to install      | 4.2.1-r0                        |
| BUILD | SUDO_VERSION          | Set version of sudo to install            | 1.9.5p2-r0                      |
| RUN   | PROJECT_ROOT          | Define the directory of the project       | /var/www/html                   |
| RUN   | DOCUMENT_ROOT         | Define the directory of the public web    | /var/www/html                   |
| RUN   | APP_ENV               | Set application environment               | prod                            |
| RUN   | APP_DEBUG             | Set application debug                     | false                           |
| RUN   | LOG_LEVEL             | Set application log level                 | warn                            |
| RUN   | PHP_MEMORY_LIMIT      | Set the memory_limit in php.ini           | 128M                            |

The `*_VERSION`environment variables specify the version, which is installed from the [alpine package manager](https://pkgs.alpinelinux.org/packages). So no
breaking changes can destroy a build, a specific version is used here.

The environment variables `APP_DEBUG`, `LOG_LEVEL` have to also be implemented into the application to be used.

## BUILD
### Multi-Stage Build (for CI/CD)
Here an example multi-stage with node.    
Since node is always optional and not necessary in every php project, it's not included in the base image.    
To use node within your application image builds, you can follow the below steps.

````dockerfile
FROM node:<version> AS node
COPY ["package.json", "package.json.lock", "./"]
# run npm ci.
RUN npm ci


FROM this-image
# Copy project files of app into the container.
COPY ./ ./ 
# Then copy node_modules from the node build phase into the current workdir
COPY --from=node ./node_modules ./node_modules
# Install php dependencies
RUN composer install --no-ansi --no-dev --no-interaction --no-suggest --optimize-autoloader
# And do some other things you need.
...
````

## RUN
You can easily run scripts within your container.
The workspace is automatically set to the project root.    
Also the user running commands from outside the container has all necessary permissions and groups.

### Execute commands in a running docker container
```shell
# These is just an example
docker exec -it <container-name> composer install --optimize-autoload
```

## Symfony
Make sure to pass the env `DOCUMENT_ROOT=/var/www/html/public` because the index.php is in the public folder.    
`PROJECT_ROOT` stays the same.


## Troubleshooting

### A directory or file which has been created during a build is missing in the final image.
1. Check the path and source in the Dockerfile (COPY)
2. When using docker-compose, ensure you are not mounting a volume over a root directory of the copied 
files. Because mounting happens after the build, the all directory/files within a mounted target will be overridden.
   
