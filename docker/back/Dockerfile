FROM alpine

EXPOSE 80

ARG PHP_FPM_USER
ARG PHP_FPM_GROUP
ARG PHP_FPM_LISTEN_MODE
ARG PHP_MEMORY_LIMIT
ARG PHP_MAX_UPLOAD
ARG PHP_MAX_FILE_UPLOAD
ARG PHP_MAX_POST
ARG PHP_DISPLAY_ERRORS
ARG PHP_DISPLAY_STARTUP_ERRORS
ARG PHP_ERROR_REPORTING
ARG PHP_CGI_FIX_PATHINFO
ARG TIMEZONE

# General packages
RUN apk update \
  && apk add bash \
  && apk add wget \
  && apk add curl \
  && apk add git \
  && apk add openrc \
  && apk add supervisor

# Nginx configuration
RUN apk add nginx \
  && mkdir -p /run/nginx \
  && adduser ${PHP_FPM_USER} -DG ${PHP_FPM_GROUP} \
  && chown -R ${PHP_FPM_USER}:${PHP_FPM_GROUP} /var/www \
  && mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig

COPY ./nginx /etc/nginx
RUN ln -s /etc/nginx/sites-available/*.conf /etc/nginx/sites-enabled/

# PHP configuration
RUN apk add php8 \
  && apk add php8-fpm \
  && apk add php8-phar \
  && apk add php8-mbstring \
  && apk add php8-soap \
  && apk add php8-openssl \
  && apk add php8-gmp \
  && apk add php8-pdo_odbc \
  && apk add php8-json \
  && apk add php8-dom \
  && apk add php8-pdo \
  && apk add php8-zip \
  && apk add php8-mysqli \
  && apk add php8-sqlite3 \
  && apk add php8-pdo_pgsql \
  && apk add php8-bcmath \
  && apk add php8-gd \
  && apk add php8-odbc \
  && apk add php8-pdo_mysql \
  && apk add php8-pdo_sqlite \
  && apk add php8-gettext \
  && apk add php8-xmlreader \
  && apk add php8-bz2 \
  && apk add php8-iconv \
  && apk add php8-pdo_dblib \
  && apk add php8-curl \
  && apk add php8-ctype \
  && apk add php8-session \
  && apk add php8-tokenizer \
  && apk add php8-simplexml \
  && apk add php8-xml 
# Edit www.conf with ENV vars
RUN sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /etc/php8/php-fpm.d/www.conf \
  && sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /etc/php8/php-fpm.d/www.conf \
  && sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /etc/php8/php-fpm.d/www.conf \
  && sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /etc/php8/php-fpm.d/www.conf \
  && sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /etc/php8/php-fpm.d/www.conf \
  && sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /etc/php8/php-fpm.d/www.conf
# Edit php.ini with ENV vars
RUN sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /etc/php8/php.ini \
  && sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /etc/php8/php.ini \
  && sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" /etc/php8/php.ini \
  && sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php8/php.ini \
  && sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php8/php.ini \
  && sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php8/php.ini \
  && sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php8/php.ini \
  && sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php8/php.ini
# Timezone conf
RUN apk add tzdata \
  && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && echo "${TIMEZONE}" > /etc/timezone \
  && sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php8/php.ini

# Composer install
RUN curl -sS https://getcomposer.org/installer | php8 -- --install-dir=/usr/local/bin --filename=composer 

# Symfony CLI install 
RUN wget https://get.symfony.com/cli/installer -O - | bash \
  && mv /root/.symfony/bin/symfony /usr/local/bin/symfony

# Supervisor conf to run Nginx and PHP-FPM 
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /var/www/back

COPY ./entrypoint.sh /usr/local/bin/entrypoint
ENTRYPOINT [ "entrypoint" ]