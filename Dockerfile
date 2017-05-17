FROM php:7.1-apache
MAINTAINER Kang Ki Tae <kt.kang@ridi.com>

COPY docs/docker/apache/*.conf /etc/apache2/sites-available/

RUN docker-php-source extract \

# install common
&& apt-get update \
&& apt-get install wget software-properties-common vim git zlib1g-dev libmcrypt-dev libldap2-dev -y \
&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
&& docker-php-ext-install ldap pdo zip pdo_mysql \

# node && bower
&& curl -sL https://deb.nodesource.com/setup_6.x | bash - \
&& apt-get install nodejs -y \
&& npm install -g bower \

# composer
&& curl -sS https://getcomposer.org/installer | php \
&& mv composer.phar /usr/bin/composer \

# couchbase
&& wget http://packages.couchbase.com/ubuntu/couchbase.key && apt-key add couchbase.key \
&& add-apt-repository 'deb http://packages.couchbase.com/ubuntu trusty trusty/main' \
&& apt-get update \
&& apt-get install -y build-essential libcouchbase2-core libcouchbase-dev libcouchbase2-bin libcouchbase2-libevent \
&& pecl install couchbase-2.2.3 \
&& docker-php-ext-enable couchbase \

# clean
&& apt-get autoclean -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
&& docker-php-source delete \

# enable apache mod and site
&& a2enmod rewrite \
&& a2dissite 000-default \
&& a2ensite ridibooks

EXPOSE 80

COPY . /var/www/html
WORKDIR /var/www/html
RUN make
