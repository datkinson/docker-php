FROM debian
MAINTAINER Daniel Atkinson <hourd.tasa@gmail.com>

RUN echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list \
  && \
  echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list \
  && \
  apt-get update \
  && \
  apt-get install -y --fix-missing \
  wget \
  && \
  wget https://www.dotdeb.org/dotdeb.gpg \
  && \
  apt-key add dotdeb.gpg \
  && \
  rm dotdeb.gpg \
  && \
  apt-get update \
  && \
  apt-get install -y --fix-missing \
  aptitude \
  bash \
  vim \
  libssh2-php \
  ssh \
  git \
  nodejs \
  apache2 \
  supervisor \
  libapache2-mod-php7.0 \
  php7.0-json \
  php7.0-mysql \
  php7.0-mcrypt \
  php7.0-sqlite3 \
  php7.0-curl \
  php7.0-gd \
  php7.0-ldap \
  && \
  rm -rf /var/lib/apt/lists/* \
  && \
  ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load \
  && \
  mkdir -p /etc/nginx/sites-enabled /var/run/php-fpm /var/log/supervisor /var/lock/apache2 /var/run/apache2

ADD .docker/apache/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf

VOLUME ["/var/www", "/etc/nginx/sites-enabled"]

ADD supervisor.ini /etc/supervisor.d/supervisor.ini
ADD .docker/php/php.ini /etc/php/php.ini

EXPOSE 80

WORKDIR /var/www

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor.d/supervisor.ini"]
