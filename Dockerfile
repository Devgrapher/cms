FROM php:7.1-apache
MAINTAINER Kang Ki Tae <kt.kang@ridi.com>

COPY docs/docker/apache/*.conf /etc/apache2/sites-available/

RUN docker-php-source extract \
&& curl -sL https://deb.nodesource.com/setup_6.x | bash - \
&& curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/bin/composer \
&& apt-get update \
&& apt-get install vim git nodejs libmcrypt-dev libldap2-dev -y \
&& apt-get autoclean -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
&& npm install -g bower \
&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
&& docker-php-ext-install ldap pdo pdo_mysql \
&& docker-php-source delete \
&& a2enmod rewrite \
&& a2dissite 000-default \
&& a2ensite ridibooks

EXPOSE 80

COPY . /var/www/html
WORKDIR /var/www/html
RUN make
