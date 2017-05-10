FROM php:7.1-apache
MAINTAINER Kang Ki Tae <kt.kang@ridi.com>

COPY docs/docker/apache/*.conf /etc/apache2/sites-available/

RUN docker-php-source extract \
&& apt-get update \
&& apt-get install libmcrypt-dev libldap2-dev vim -y \
&& rm -rf /var/lib/apt/lists/* \
&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
&& docker-php-ext-install ldap pdo pdo_mysql \
&& docker-php-source delete \
&& a2enmod rewrite \
&& a2dissite 000-default \
&& a2ensite ridibooks

EXPOSE 80

COPY . /var/www/html

