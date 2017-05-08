# Docker container for quick deploying of a Wordpress backup.

Complete docker container with Nginx 1.10 & PHP-FPM 7.1 & MariaDB based on Alpine Linux.
It automatically deploys a backup file from Wordpress and updates all settings.

## Backup
Copy the backup file with format <name>_wordpress_backup_<date>.tar.gz in this container folder. Build the container and run it. The backup file will be uncompressed, copied and installed into the wordpress docker container. 

## Build

    docker build docker-wordpress-mysql -t wordpress

## Usage
    docker run -d --name wordpress -p 80:80 -e "DOMAIN=http://site.com" -v /local/folder:/var/www/wp-content wordpress
    
Or without a volume
    
    docker run -d --name wordpress -p 80:80 -e "DOMAIN=http://site.com" --restart always wordpress
    
Where "http://site.com" is the domain (or IP) that points to this docker container. 
    
## Database password
The database password for root and wordpress user are randomly generated each time you create a new container. For checking it use

    docker logs <container>

And find some lines like these:

    GENERATED ROOT PASSWORD AS 'x7tiZcRi7DhZGc3B2mDy4Qb9rOheQX8Qfubd9ZZr'
    
    GENERATED WORDPRESS USER PASSWORD AS 'amOICpa05KYHzaipnaXANxAeg0XgWqHrO4d9ARWD'

### Forked from
* https://github.com/jorgehortelano/docker-wordpress-mysql
