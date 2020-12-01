FROM amd64/php:8.0-cli-alpine
ARG PHPREDIS_VERSION="5.3.2"
ARG READIS_VERSION="v2.2.2"

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN set -ex \
	&& apk update \
	&& apk upgrade --available \
	&& apk add --no-cache $PHPIZE_DEPS icu-dev \
	&& docker-php-ext-install intl \
	&& mkdir -p "/usr/src/php/ext/redis" \
    && curl -fsSL "https://github.com/phpredis/phpredis/archive/${PHPREDIS_VERSION}.tar.gz" | tar xvz -C "/usr/src/php/ext/redis" --strip 1 \
    && echo 'redis' >> "/usr/src/php-available-exts" \
    && docker-php-ext-install redis \
    && rm -rf "/usr/src/php/ext/redis" \
    && mkdir -p "/code" \
	&& curl -fsSL "https://github.com/hollodotme/readis/archive/${READIS_VERSION}.tar.gz" | tar xvz -C "/code" --strip 1 \
    && cd "/code" \
    && /usr/bin/composer install -a --no-dev --no-interaction --ignore-platform-req=ext-xdebug \
    && apk del $PHPIZE_DEPS \
    && rm -f /usr/bin/composer \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

EXPOSE 80

CMD ["php", "-S", "0.0.0.0:80", "-t", "/code/public"]
