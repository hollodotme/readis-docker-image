FROM php:7.3-cli
ENV PHPREDIS_VERSION 4.2.0
ENV READIS_VERSION 2.2.1
# System update and necessary software
RUN apt-get update && apt-get install git libicu-dev g++ procps -y
# Install intl-extension
RUN docker-php-ext-install intl
# Install redis extension
RUN mkdir -p /usr/src/php/ext/redis \
   && curl -L https://github.com/phpredis/phpredis/archive/${PHPREDIS_VERSION}.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
   && echo 'redis' >> /usr/src/php-available-exts \
   && docker-php-ext-install redis
# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
   && php -r "if (hash_file('sha384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
   && php composer-setup.php --install-dir=/bin --filename=composer \
   && php -r "unlink('composer-setup.php');"
# Install readis
RUN git clone https://github.com/hollodotme/readis.git /code \
   && cd /code \
   && git checkout v${READIS_VERSION} \
   && composer install -a --no-dev --no-interaction
# Clean up
RUN apt-get autoremove --purge git -y \
   && apt-get autoclean -y \
   && apt-get clean -s \
   && rm -f /bin/composer
# Startup command
EXPOSE 80
CMD ["php", "-S", "0.0.0.0:80", "-t", "/code/public"]
