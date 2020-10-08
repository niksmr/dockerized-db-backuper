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
    mongodb-tools \
    nginx 


# Fix iconv php
RUN apk add gnu-libiconv --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

RUN docker-php-ext-install pdo pdo_mysql bcmath zip opcache pcntl \
    && docker-php-ext-configure gd --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd\
    && docker-php-ext-enable opcache

RUN echo "* * * * * php /var/www/html/artisan schedule:run 2>&1" | crontab -

COPY ./php.ini $PHP_INI_DIR/conf.d/php.ini
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN rm /etc/nginx/conf.d/default.conf
COPY ./nginx.conf /etc/nginx/conf.d/ivolga.conf
COPY /start.sh /
RUN chmod +x /start.sh

WORKDIR /var/www/html

EXPOSE 5000

CMD ["/start.sh"]