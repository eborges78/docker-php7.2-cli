FROM alpine:3.9
LABEL maintainer="Emmanuel BORGES <contact@eborges.fr>"

RUN apk update && apk upgrade
RUN apk add git curl bash nano vim unzip zlib-dev \
php7 yarn php7-cli php7-pear php7-opcache g++ make php7-dev php7-phar php7-memcached php7-apcu php7-ssh2 php7-xmlwriter  \
php7-gd php7-mysqli php7-zlib php7-curl php7-pdo_mysql php7-ftp php7-ctype php7-xmlreader \
php7-openssl php7-redis php7-mbstring php7-xml php7-dom php7-simplexml php7-sockets \
php7-tokenizer php7-bcmath php7-gettext php7-intl php7-pdo_sqlite php7-soap \
php7-json php7-iconv php7-xdebug php7-zip php7-amqp php7-mcrypt php7-session php7-simplexml

RUN set -ex; \
    pecl install -f igbinary; \
    echo 'extension=igbinary.so' > /etc/php7/conf.d/igbinary.ini; \
    pecl install -f mongodb; \
    echo 'extension=mongodb.so' > /etc/php7/conf.d/mongodb.ini;

# add composer if necessary
RUN curl -fSL https://getcomposer.org/installer -o composer-setup.php \
&& php composer-setup.php --install-dir=bin --filename=composer \
&& rm composer-setup.php

# add blackfire if necessary
RUN curl -fSL https://packages.blackfire.io/binaries/blackfire-php/1.23.1/blackfire-php-linux_amd64-php-71.so -o blackfire.so \
&& mv blackfire.so /usr/lib/php7/modules/blackfire.so \
&& printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > /etc/php7/conf.d/90-blackfire.ini

# enable xdebug if necessary
RUN echo 'zend_extension=xdebug.so' > /etc/php7/conf.d/xdebug.ini
RUN echo "xdebug.remote_enable = 1" | tee -a /etc/php7/conf.d/docker-php-ext-xdebug.ini
RUN echo "memory_limit = \"-1\"" | tee -a /etc/php7/conf.d/memory-limit.ini
RUN echo "date.timezone = Europe/Paris" > /etc/php7/conf.d/date.ini

# Permissions
RUN chmod -Rf 0777 /var/log/
RUN chmod a+x /bin/composer

# Run entrypoint
WORKDIR /var/www/html
