# WordPress Docker Container with MariaDB

Complete docker container with Nginx 1.10 & PHP-FPM 7.1 & MariaDB

Lightweight WordPress container with Nginx 1.10 & PHP-FPM 7.1 based on Alpine Linux.

_WordPress version currently installed:_ **4.7.4**


[![Docker Pulls](https://img.shields.io/docker/pulls/trafex/wordpress.svg)](https://hub.docker.com/r/trafex/wordpress/) [![](https://images.microbadger.com/badges/image/trafex/wordpress.svg)](https://microbadger.com/images/trafex/wordpress "Get your own image badge on microbadger.com")

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
