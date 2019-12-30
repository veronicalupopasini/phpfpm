#!/usr/bin/env bash

sed -i -e "s/REMOTE_HOST/${DOCKER_HOST_IP}/" /usr/local/etc/php/conf.d/php.ini
sed -i -e "s/REMOTE_PORT/${DOCKER_HOST_PORT}/" /usr/local/etc/php/conf.d/php.ini
sed -i -e "s/ENABLE_XDEBUG/${ENABLE_XDEBUG}/" /usr/local/etc/php/conf.d/php.ini

/usr/bin/supervisord
