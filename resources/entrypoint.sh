#!/usr/bin/env bash

sed -i -e "s/REMOTE_HOST/${DOCKER_HOST_IP}/" /etc/php/7.3/mods-available/custom.ini
sed -i -e "s/REMOTE_PORT/${DOCKER_HOST_PORT}/" /etc/php/7.3/mods-available/custom.ini
sed -i -e "s/ENABLE_XDEBUG/${ENABLE_XDEBUG}/" /etc/php/7.3/mods-available/custom.ini
sed -i -e "s/MAX_UPLOAD_SIZE/${MAX_UPLOAD_SIZE}/" /etc/php/7.3/mods-available/custom.ini

/usr/sbin/php-fpm7.3 -F -R -O 2>&1
