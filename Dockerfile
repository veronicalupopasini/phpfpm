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
    && apt-get -y update
RUN apt-get -y --force-yes install \
    php7.2 \
    php7.2-fpm \
    php7.2-cli \
    php7.2-pgsql \
    php7.2-gd \
    php7.2-curl \
    php7.2-zip \
    php7.2-mbstring \
    php7.2-xdebug \
    php7.2-readline \
    php7.2-sqlite3 \
    php7.2-common \
    php7.2-intl \
    php7.2-xmlrpc \
    php7.2-xml \
    php7.2-dev \
    php-pear \
    php-mongodb \
    php-redis \
    php7.2-apcu \
    php7.2-sybase \
    unattended-upgrades \
    git \
    build-essential \
    ksh \
    zip

RUN mkdir /opt/ibm
COPY /resources/v11.1.4fp4a_linuxx64_dsdriver.tar.gz /opt/ibm
WORKDIR /opt/ibm

RUN tar -xvf v11.1.4fp4a_linuxx64_dsdriver.tar.gz
WORKDIR /opt/ibm/dsdriver
RUN chmod 755 installDSDriver\
    && ksh installDSDriver \
    && wget https://pecl.php.net/get/ibm_db2-2.0.6.tgz \
    && tar -xvf ibm_db2-2.0.6.tgz \
    && cd ibm_db2-2.0.6 \
    && phpize --clean \
    && phpize \
    && ./configure --enable-debug -with-IBM_DB2=/opt/ibm/dsdriver \
    && make clean \
    && make \
    && make install \
    && echo "extension=ibm_db2.so" >> /etc/php/7.2/cli/php.ini\
    && echo "extension=ibm_db2.so" >> /etc/php/7.2/fpm/php.ini

WORKDIR /resources

COPY /resources/php.ini /etc/php/7.2/mods-available/custom.ini
RUN phpenmod custom

RUN cat /resources/www.conf >> /etc/php/7.2/fpm/pool.d/www.conf

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
