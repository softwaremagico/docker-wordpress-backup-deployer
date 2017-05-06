#!/bin/bash

# terminate on errors
set -e

# Check if volume is empty
#if [ ! "$(ls -A "/var/www/wp-content" 2>/dev/null)" ]; then
    echo 'Setting up wp-content volume'
    # Copy wp-content from Wordpress src to volume
    cp -r /usr/src/wordpress/wp-content /var/www/
    chown -R nobody.nobody /var/www

    # Generate secrets
    curl -f https://api.wordpress.org/secret-key/1.1/salt/ >> /usr/src/wordpress/wp-secrets.php
    
    #Start mysql 
    /etc/init.d/mysqld start
    
    # Generate database passwords
    MYSQL_RANDOM_ROOT_PASSWORD=`pwgen -s 40 1`
    MYSQL_WORDPRESS_USER="wordpress"
    MYSQL_WORDPRESS_USER_PASSWORD=`pwgen -s 40 1`
    MYSQL_WORDPRESS_DATABASE="wordpress"
    DOMAIN="localhost"
    
    #Create mysql user
    mysql -e "CREATE DATABASE ${MYSQL_WORDPRESS_DATABASE};"
    mysql -e "CREATE USER ${MYSQL_WORDPRESS_USER}@localhost IDENTIFIED BY '${MYSQL_WORDPRESS_USER_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_WORDPRESS_DATABASE}.* TO '${MYSQL_WORDPRESS_USER}'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"
    
    #Set root password
    mysqladmin -u root password $MYSQL_RANDOM_ROOT_PASSWORD
    echo "GENERATED ROOT PASSWORD AS '$MYSQL_RANDOM_ROOT_PASSWORD'"            
    echo "GENERATED WORDPRESS USER PASSWORD AS '$MYSQL_WORDPRESS_USER_PASSWORD'" 
    
    #Update configuration files
    echo "define('DB_USER', '${MYSQL_WORDPRESS_USER}');" >> /usr/src/wordpress/wp-secrets.php
    echo "define('DB_PASSWORD', '${MYSQL_WORDPRESS_USER_PASSWORD}');" >> /usr/src/wordpress/wp-secrets.php
    echo "define('DB_HOST', 'localhost');" >> /usr/src/wordpress/wp-secrets.php
    echo "define('DB_NAME', '${MYSQL_WORDPRESS_DATABASE}');" >> /usr/src/wordpress/wp-secrets.php
    echo "define('DB_CHARSET', 'utf8');" >> /usr/src/wordpress/wp-secrets.php
    echo "define('DB_COLLATE', '');" >> /usr/src/wordpress/wp-secrets.php
    
    #Restore backup
    sed -i "1 s/^/USE ${MYSQL_WORDPRESS_DATABASE};\n/" /usr/src/wordpress/database_backup.sql
    sed -i -e "s/\(1, '\''siteurl'\'', '\''.*'\'', '\''yes'\''\)/1, '\''siteurl'\'', '\''${DOMAIN}'\'', '\''yes'\''/g" /usr/src/wordpress/database_backup.sql
    sed -i -e "s/\(36, '\''home'\'', '\''.*'\'', '\''yes'\''\)/36, '\''home'\'', '\''${DOMAIN}'\'', '\''yes'\''/g" /usr/src/wordpress/database_backup.sql
    mysql -uroot -p${MYSQL_RANDOM_ROOT_PASSWORD} < /usr/src/wordpress/database_backup.sql
    rm -f /usr/src/wordpress/database_backup.sql
    
#fi
exec "$@"
