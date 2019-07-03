FROM ubuntu:bionic

ENV TERM xterm
ENV MAX_UPLOAD_SIZE 50M
ENV DEBIAN_FRONTEND noninteractive

# Provision

ADD /resources/* /resources/
WORKDIR /resources

RUN apt-get -y update \
    && apt-get -y install curl wget software-properties-common \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get -y update \
    && apt-get -y --force-yes install \
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

WORKDIR /resources

COPY /resources/php.ini /etc/php/7.3/mods-available/custom.ini
RUN phpenmod custom

RUN cat /resources/www.conf >> /etc/php/7.3/fpm/pool.d/www.conf

COPY /resources/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN curl -sS https://getcomposer.org/installer | php \
    && chmod +x composer.phar \
    && mv composer.phar /usr/bin/composer

RUN chmod u+x /resources/entrypoint.sh

RUN mkdir /run/php
ENV BOOTSTRAP_SCRIPT ""

# Security Updates

RUN unattended-upgrades -d

# Copy Application Sources

RUN mkdir /app
WORKDIR /app

VOLUME ["/app"]

# Default Command and Expose ports

CMD ["bash", "/resources/entrypoint.sh"]

EXPOSE 9000
