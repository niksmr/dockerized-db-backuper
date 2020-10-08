#!/bin/sh

php-fpm -D
nginx -g 'pid /tmp/nginx.pid;'
crond -f