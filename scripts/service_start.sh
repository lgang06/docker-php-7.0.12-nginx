#!/bin/bash
set -ex
exec `/usr/local/php7/sbin/php-fpm -y /usr/local/php7/etc/php-fpm.conf` && exec `/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf`
exec "$@"
