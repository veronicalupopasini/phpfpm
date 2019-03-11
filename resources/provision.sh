#!/usr/bin/env sh

cd /resources

apt-get -y update
apt-get -y install curl wget software-properties-common
##ppas
add-apt-repository -y ppa:ondrej/php

apt-get -y update

apt-get -y --force-yes install \
   php7.3 \
   php7.3-fpm \
   php7.3-cli \
   php7.3-pgsql \
   php7.3-gd \
   php7.3-curl \
   php7.3-zip \
   php7.3-mbstring \
   php7.3-xdebug \
   php7.3-readline \
   php7.3-sqlite3 \
   php7.3-common \
   php7.3-intl \
   php7.3-xmlrpc \
   php7.3-xml \
   php7.3-dev \
   php-pear \
   php-mongodb \
   php-redis \
   php7.3-apcu \
   php7.3-sybase \
   unattended-upgrades \
   git \
   build-essential

#php.ini
cp /resources/php.ini /etc/php/7.3/mods-available/custom.ini
phpenmod custom

#fpm-pool
cat /resources/www.conf >> /etc/php/7.3/fpm/pool.d/www.conf

#composer
curl -sS https://getcomposer.org/installer | php
chmod +x composer.phar
mv composer.phar /usr/bin/composer
