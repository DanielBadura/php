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
        php7.2 \
        php7.2-fpm \
        php7.2-cli \
        php7.2-intl \
        php7.2-pdo \
        php7.2-zip \
        php7.2-xml \
        php7.2-mbstring \
        php7.2-json \
        php7.2-curl \
        php7.2-pdo \
        php7.2-mysql \
        php7.2-opcache \
        php7.2-apcu \
        php7.2-gd \
        php7.2-soap \
        php7.2-xdebug \
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
COPY docker/fpm-www.conf /etc/php/7.2/fpm/pool.d/www.conf

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
