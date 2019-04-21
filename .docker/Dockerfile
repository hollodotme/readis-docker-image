FROM php:7.3-cli-alpine
ENV PHPREDIS_VERSION 4.3.0
ENV READIS_VERSION 2.2.1
# System update and necessary software
RUN apk update && apk upgrade && apk add --no-cache $PHPIZE_DEPS git icu-dev g++ procps
# Install intl-extension
RUN docker-php-ext-install intl
# Install redis extension
RUN mkdir -p /usr/src/php/ext/redis \
   && curl -L https://github.com/phpredis/phpredis/archive/${PHPREDIS_VERSION}.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
   && echo 'redis' >> /usr/src/php-available-exts \
   && docker-php-ext-install redis
COPY composer/install_composer.sh /install_composer.sh
# Install composer
RUN sh /install_composer.sh --install-dir=/bin --filename=composer
# Install readis
RUN git clone https://github.com/hollodotme/readis.git /code \
   && cd /code \
   && git checkout v${READIS_VERSION} \
   && composer install -a --no-dev --no-interaction
# Clean up
RUN apk del $PHPIZE_DEPS git g++ \
   && rm -f /bin/composer \
   && rm -f /install_composer.sh \
   && rm -rf /var/cache/apk/*
# Startup command
EXPOSE 80
CMD ["php", "-S", "0.0.0.0:80", "-t", "/code/public"]
