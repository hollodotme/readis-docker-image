![Docker Image Publishing](https://github.com/hollodotme/readis-docker-image/workflows/Docker%20Image%20Publishing/badge.svg)

# re<sup>a</sup>dis docker image

## Description

Official docker image for [re<sup>a</sup>dis](https://github.com/hollodotme/readis).

## Installation

```bash
docker pull hollodotme/readis
```

For all available tags have a look at https://hub.docker.com/r/hollodotme/readis/tags/

## Usage

Simplest way to use the image is [docker-compose](https://docs.docker.com/compose/).

First create the two necessary PHP config files for re<sup>a</sup>dis:

**`config/app.php`**
```php
<?php declare(strict_types=1);

return [
    'baseUrl' => 'http://localhost:80/',
];
```

**`config/servers.php`**
```php
<?php declare(strict_types=1);

return [
	[
		'name'          => 'Redis-Server 1',
		'host'          => 'your_redis_server',
		'port'          => 6379,
		'auth'          => null,
		'timeout'       => 2.5,
		'retryInterval' => 100,
		'databaseMap'   => [],
	],
];
```

For more information about the configuration files, have a look at 
the [re<sup>a</sup>dis documentation](https://github.com/hollodotme/readis/blob/master/README.md).

**Please note:** The `host` value in the `servers.php` is the same as the redis service `container_name` 
in the following `docker-compose.yml`.  

Now create a `docker-compose.yml` to combine a default redis server instance with re<sup>a</sup>dis:

```yml
version: '3'
services:
  redis:
    container_name: your_redis_server
    image: redis:3
  readis:
    container_name: your_readis
    image: hollodotme/readis
    ports:
      - 80:80
    volumes:
      - ./config:/code/config:ro
    depends_on:
      - redis
```

**Please note:** The whole config folder was mounted into the re<sup>a</sup>dis container, so your config files take effect.

Finally `run docker-compose up -d` to fire up both containers. 
As soon as the containers are running, visit http://localhost:80/.

## Contributing

Contributions are welcome and will be fully credited. Please see the [contribution guide](.github/CONTRIBUTING.md) for details.
