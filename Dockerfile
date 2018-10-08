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
        php7.0 \
        php7.0-fpm \
        php7.0-cli \
        php7.0-intl \
        php7.0-pdo \
        php7.0-zip \
        php7.0-xml \
        php7.0-mbstring \
        php7.0-json \
        php7.0-curl \
        php7.0-pdo \
        php7.0-mysql \
        php7.0-opcache \
        php7.0-apcu \
        php7.0-gd \
        php7.0-soap \
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
COPY docker/fpm-www.conf /etc/php/7.0/fpm/pool.d/www.conf

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
