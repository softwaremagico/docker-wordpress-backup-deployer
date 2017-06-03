FROM alpine:latest
LABEL Maintainer="Jorge Hortelano" \
      Description="Lightweight WordPress container with Nginx 1.10 & PHP-FPM 7.1 & MariaDB based on Alpine Linux."
 
# Install packages from testing repo's
RUN apk --no-cache add php7 php7-fpm php7-mysqli php7-json php7-openssl php7-curl \
    php7-zlib php7-xml php7-phar php7-intl php7-dom php7-xmlreader php7-ctype \
    php7-mbstring php7-gd nginx supervisor curl bash pwgen mysql mysql-client

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf
COPY config/php.ini /etc/php7/conf.d/zzz_custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# wp-content volume
VOLUME /var/www/wp-content
WORKDIR /var/www/wp-content
RUN chown -R nobody.nobody /var/www

#MySQL
RUN /usr/bin/mysql_install_db --user=mysql \
    && cp /usr/share/mysql/mysql.server /etc/init.d/mysqld

# Wordpress
ENV WORDPRESS_VERSION 4.7.5
ENV WORDPRESS_SHA1 fbe0ee1d9010265be200fe50b86f341587187302

# Upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
RUN mkdir -p /usr/src \
        && curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
	&& echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
	&& tar -xzf wordpress.tar.gz -C /usr/src/ \
	&& rm wordpress.tar.gz \
	&& chown -R nobody.nobody /usr/src/wordpress

# WP config
COPY config/wp-config.php /usr/src/wordpress
RUN chown nobody.nobody /usr/src/wordpress/wp-config.php && chmod 640 /usr/src/wordpress/wp-config.php

# Append WP secrets
COPY config/wp-secrets.php /usr/src/wordpress
COPY app/backup.sh /backup.sh
RUN chown nobody.nobody /usr/src/wordpress/wp-secrets.php \
    && chmod 640 /usr/src/wordpress/wp-secrets.php \
    && chmod 640 /backup.sh \

#Copy backup
ADD *wordpress_backup*.tar.gz /tmp/backup
RUN rm -f /tmp/backup/wp-config.php \
    && rm -f /tmp/backup/wp-secrets.php \
    && cp -rf /tmp/backup/* /usr/src/wordpress/ \
    && rm -rf /tmp/backup \
    && gunzip -c /usr/src/wordpress/*.sql.gz > /usr/src/wordpress/database_backup.sql \
    && rm -f /usr/src/wordpress/*.sql.gz

# Entrypoint to copy wp-content
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

EXPOSE 80

#MySQL VOLUME
VOLUME /var/lib/mysql

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]


