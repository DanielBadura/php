FROM phusion/baseimage

ARG DEBIAN_FRONTEND=noninteractive

# set environments
RUN echo prod > /etc/container_environment/APP_ENV
RUN echo Europe/Berlin > /etc/container_environment/TZ

# install common tools & tzdata
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        software-properties-common \
        tzdata \
        && \
    rm -r /var/lib/apt/lists/*

# install php
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        php7.1 \
        php7.1-fpm \
        php7.1-cli \
        php7.1-intl \
        php7.1-pdo \
        php7.1-zip \
        php7.1-xml \
        php7.1-mbstring \
        php7.1-json \
        php7.1-curl \
        php7.1-pdo \
        php7.1-mysql \
        php7.1-opcache \
        php7.1-apcu \
        php7.1-gd \
        php7.1-soap \
        php7.1-xdebug \
        && \
    rm -r /var/lib/apt/lists/*

# install & setup nginx
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        nginx \
        && \
    rm -r /var/lib/apt/lists/*

# setup php-fpm
RUN mkdir /etc/service/php-fpm
COPY docker/php-fpm.sh /etc/service/php-fpm/run
RUN chmod +x /etc/service/php-fpm/run

RUN mkdir /run/php
COPY docker/fpm-www.conf /etc/php/7.1/fpm/pool.d/www.conf

# setup nginx
RUN mkdir /etc/service/nginx
COPY docker/nginx.sh /etc/service/nginx/run
RUN chmod +x /etc/service/nginx/run

COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/nginx.vhost /etc/nginx/vhosts.d/app.conf

# copy project
COPY . /srv/share
RUN mkdir /srv/share/var
RUN chown www-data:www-data /srv/share/var

EXPOSE 80
