# WordPress Docker Container with MariaDB

Complete docker container with Nginx 1.10 & PHP-FPM 7.1 & MariaDB

_WordPress version currently installed:_ **4.7.4**

## Copy Backup
I use BackWPup plugin for my backups. Copy your backup file in format `*.sql.gz`  in the docker folder and create the docker container. The backup file will be uncompressed, copied and installed into the wordpress docker container. 

## Create

	docker build docker-wordpress-mysql -t wordpress

## Usage
    docker run -d -p 80:80 -v /local/folder:/var/www/wp-content wordpress
    
Or without a volume
    
    docker run -d -p 80:80 wordpress
    
## Database password
The database password for root and wordpress user are randmly generated on each container generation. For checking it
    docker logs <container>

And find this lines
    GENERATED ROOT PASSWORD AS 'x7tiZcRi7DhZGc3B2mDy4Qb9rOheQX8Qfubd9ZZr'
    GENERATED WORDPRESS USER PASSWORD AS 'amOICpa05KYHzaipnaXANxAeg0XgWqHrO4d9ARWD'

### Forked from
* https://github.com/jorgehortelano/docker-wordpress-mysql
