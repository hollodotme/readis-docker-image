FROM php:8.0-cli-alpine AS builder

RUN set -ex \
    && apk update && apk upgrade --available \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/ gnu-libiconv=1.15-r3
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN set -ex \
    && install-php-extensions intl-stable redis-stable \
    && rm -f /usr/local/bin/install-php-extensions

FROM builder AS readis
ARG READIS_VERSION="v2.2.2"

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN set -ex \
    && mkdir -p "/code" \
	&& curl -fsSL "https://github.com/hollodotme/readis/archive/${READIS_VERSION}.tar.gz" | tar xvz -C "/code" --strip 1 \
    && cd "/code" \
    && /usr/bin/composer install -a --no-dev --no-interaction --ignore-platform-req=ext-xdebug \
    && rm -f /usr/bin/composer \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

EXPOSE 80

CMD ["php", "-S", "0.0.0.0:80", "-t", "/code/public"]