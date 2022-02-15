# full stack wordpress for everyone with docker compose

If You want to have wordpress website at short time; Full stack WordPress (webserver apache2(httpd), proxy nginx, database admin phpmyadmin, database mariadb/mysql, ssl letsencrypt, redis cache and backup) with Docker Compose.
Plus, Docker manage by Portainer.

With this project you can quickly run the following:

- [wordPress (php-fpm)](https://hub.docker.com/_/wordpress/)
- [webserver (apache2/httpd)](https://hub.docker.com/_/httpd)
- [proxy (nginx)](https://hub.docker.com/_/nginx)
- [certbot (letsencrypt)](https://hub.docker.com/r/certbot/certbot)
- [phpMyAdmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin/)
- [database](https://hub.docker.com/_/mariadb)
- [redis](https://hub.docker.com/_/redis)
- [backup](https://hub.docker.com/r/futurice/docker-volume-backup)

For run certbot (letsencrypt) certificate:

- [Set DNS configuration of your domain name](https://support.google.com/a/answer/48090?hl=en)

Contents:

- [Requirements](#requirements)
- [Configuration](#configuration)
- [Installation](#installation)
- [Usage](#usage)

## Requirements

Make sure you have the latest versions of **Docker** and **Docker Compose** installed on your machine.

- [How install docker](https://docs.docker.com/engine/install/)
- [How install docker compose](https://docs.docker.com/compose/install/)

Clone this repository or copy the files from this repository into a new folder. In the **docker-compose.yml** file you may change the database from MariaDB to MySQL.

Make sure to [add your user to the `docker` group](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user).

## Configuration and Installation

### Exec install shell script for auto installation and configuration

download with
```
git clone https://github.com/damalis/full-stack-wordpress-for-everyone-with-docker-compose.git
```

```
chmod +x install.sh
./install.sh
```

### Manual Configuration

Copy the example environment into `.env`

```
cp env.example .env
```

Edit the `.env` file to change values of ```LOCAL_TIMEZONE```, ```DOMAIN_NAME```, ```LOCALHOST_PATH```, ```LETSENCRYPT_EMAIL```, ```WORDPRESS_DB_USER```, ```WORDPRESS_DB_PASSWORD```, ```WORDPRESS_DB_NAME```, ```WORDPRESS_TABLE_PREFIX```, ```MYSQL_ROOT_PASSWORD```, ```PMA_CONTROLUSER```, ```PMA_CONTROLPASS```, ```PMA_HTPASSWD_USERNAME``` and ```PMA_HTPASSWD_PASSWORD```.

and

```
cp ./proxy/conf.d/proxy.example.conf ./proxy/conf.d/proxy.conf
```
change example.com to your domain name in ```./proxy/conf.d/proxy.conf``` file.
```
cp ./phpmyadmin/apache2/sites-available/default-ssl.example.conf ./phpmyadmin/apache2/sites-available/default-ssl.conf
```
change example.com to your domain name in ```./phpmyadmin/apache2/sites-available/default-ssl.conf``` file.

rename filename ```cp ./phpmyadmin/config.sample.inc.php ./phpmyadmin/config.inc.php```.

change value of $cfg['blowfish_secret'] in ```./phpmyadmin/config.secret.inc``` file.

### Manual Installation

Open a terminal and `cd` to the folder in which `docker-compose.yml` is saved and run:

Firstly: will create external volume
```
docker volume create certbot-etc
```
```
docker-compose up -d
```

The containers are now built and running. You should be able to access the WordPress installation with the configured IP in the browser address. `https://example.com`.

For convenience you may add a new entry into your hosts file.

### Installation Portainer

```
docker-compose -f portainer-docker-compose.yml -p portainer up -d 
```
manage docker with [Portainer](https://www.portainer.io/solutions/docker) is the definitive container management tool for Docker, Docker Swarm with it's highly intuitive GUI and API. 

You can also visit `https://example.com:9001` to access portainer after starting the containers.

## Usage

### Starting containers

You can start the containers with the `up` command in daemon mode (by adding `-d` as an argument) or by using the `start` command:

```
docker-compose start
```

### Stopping containers

```
docker-compose stop
```

### Removing containers

To stop and remove all the containers use the`down` command:

```
docker-compose down
```

Use `-v` if you need to remove the database volume which is used to persist the database:

```
docker-compose down -v
```

### Project from existing source

Copy all files into a new directory:

You can now use the `up` command:

```
docker-compose up -d
```

### Website

add or remove code in the ./php-fpm/php/conf.d/security.ini file for custom php.ini configurations

Copy and paste the following code in the ./php-fpm/php-fpm.d/z-www.conf file for php-fpm configurations at 1Gb Ram Host

```
pm.max_children = 19
pm.start_servers = 4
pm.min_spare_servers = 2
pm.max_spare_servers = 4
pm.max_requests = 1000
```

Or you should make changes custom host configurations then must restart service

```
docker-compose restart wordpress
```

add and/or remove wordpress site folders and files with any ftp client program in ```./wordpress``` folder.
<br />You can also visit `https://example.com` to access website after starting the containers.

#### Redis Plugin

add and enable [Redis Cache](https://wordpress.org/plugins/redis-cache/) plugin.

### phpMyAdmin

You can also visit `https://example.com:9090` to access phpMyAdmin after starting the containers.

The first authorize screen(htpasswd;username or password) and phpmyadmin login screen the username and the password is the same as supplied in the `.env` file.

### backup

This will back up the all files and folders, once per day, and write it to ./backups with a filename like backup-2022-02-07T16-51-56.tar.gz 
