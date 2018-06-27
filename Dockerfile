FROM php:7.2-cli
ENV PHPREDIS_VERSION 4.0.2
ENV READIS_VERSION 2.2.0
# System update and necessary software
RUN apt-get update && apt-get install git libicu-dev g++ procps -y
# Install xDebug
RUN pecl install xdebug \
   && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20170718/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini
# Install intl-extension
RUN docker-php-ext-install intl
# Install redis extension
RUN mkdir -p /usr/src/php/ext/redis \
   && curl -L https://github.com/phpredis/phpredis/archive/${PHPREDIS_VERSION}.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
   && echo 'redis' >> /usr/src/php-available-exts \
   && docker-php-ext-install redis
# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
   && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
   && php composer-setup.php --install-dir=/bin --filename=composer \
   && php -r "unlink('composer-setup.php');"
# Install readis
RUN git clone https://github.com/hollodotme/readis.git /code \
   && cd /code \
   && git checkout v${READIS_VERSION} \
   && composer install -a --no-dev --no-interaction
# Clean up
RUN apt-get autoremove --purge git -y && apt-get autoclean -y && apt-get clean
# Startup command
EXPOSE 80
CMD ["php", "-S", "0.0.0.0:80", "-t", "/code/public"]
