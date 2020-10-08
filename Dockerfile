FROM php:7.4.11-fpm-alpine3.12

RUN apk add --no-cache \
    libjpeg-turbo-dev \
    libpng-dev \
    autoconf \
    g++ \
    gcc \
    libc-dev \
    zip \
    libzip-dev \
    make \
    mysql-client \
    postgresql \
    mongodb-tools

RUN docker-php-ext-install pdo pdo_mysql bcmath zip opcache pcntl \
    && docker-php-ext-configure gd --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd\
    && docker-php-ext-enable opcache

RUN echo "* * * * * php /var/www/html/artisan schedule:run 2>&1" | crontab -

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY /start.sh /
RUN chmod +x /start.sh

COPY ./composer.* /var/www/html/
WORKDIR /var/www/html
RUN (php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');"\
    && php composer.phar install --no-scripts --no-autoloader --no-progress)

COPY app /var/www/html/app
COPY bootstrap /var/www/html/bootstrap
COPY config /var/www/html/config
COPY database /var/www/html/database
COPY public /var/www/html/public
COPY resources /var/www/html/resources
COPY routes /var/www/html/routes
COPY storage /var/www/html/storage
COPY tests /var/www/html/tests
COPY artisan /var/www/html
COPY server.php /var/www/html

RUN php composer.phar dump-autoload --optimize
RUN php artisan storage:link
RUN chgrp -R www-data storage storage/logs bootstrap/cache && chmod -R ug+rwx storage storage/logs bootstrap/cache

ARG hash=arg_hash_undef
ENV BACKUPER_HASH=$hash

CMD ["/start.sh"]