# full stack wordpress for everyone with docker compose

If You want to have a wordpress website at short time; 

Full stack WordPress:
<p align="left"> <a href="https://wordpress.org/" target="_blank" rel="noreferrer"> <img style="margin: 10px" src="https://profilinator.rishav.dev/skills-assets/wordpress.png" alt="wordPress" height="40" width="40"/> </a> <a href="https://www.docker.com/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/docker/docker-original-wordmark.svg" alt="docker" width="40" height="40"/> </a> <a href="https://mariadb.org/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/mariadb/mariadb-icon.svg" alt="mariadb" width="40" height="40"/> </a> <a href="https://www.nginx.com" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/nginx/nginx-original.svg" alt="nginx" width="40" height="40"/> </a> <a href="https://www.php.net" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/php/php-original.svg" alt="php" width="40" height="40"/> </a> <a href="https://redis.io" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/redis/redis-original-wordmark.svg" alt="redis" width="40" height="40"/> </a> <a href="#" target="_blank" rel="noreferrer"> <img style="margin: 10px" src="https://profilinator.rishav.dev/skills-assets/gnu_bash-icon.svg" alt="Bash" height="40" width="40" /> </a>
<a href="https://www.portainer.io/?hsLang=en" target="_blank" rel="noreferrer"> <img style="margin: 10px" src="https://www.portainer.io/hs-fs/hubfs/PortainerTM-blue-landscape-small-web-300px.png?width=300&name=PortainerTM-blue-landscape-small-web-300px.png" alt="portainer" height="40"/> </a> <a href="https://www.phpmyadmin.net/" target="_blank" rel="noreferrer"> <img style="margin: 10px" src="https://www.phpmyadmin.net/static/images/logo.png?067b638aa2a2" alt="phpmyadmin" height="40"/> </a> </p>

Plus, manage docker containers with Portainer.

With this project you can quickly run the following:

- [wordPress (php-fpm)](https://hub.docker.com/_/wordpress/)
- [webserver (apache2/httpd)](https://hub.docker.com/_/httpd)
- [proxy (nginx)](https://hub.docker.com/_/nginx)
- [certbot (letsencrypt)](https://hub.docker.com/r/certbot/certbot)
- [phpMyAdmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin/)
- [database](https://hub.docker.com/_/mariadb)
- [redis](https://hub.docker.com/_/redis)
- [backup](https://hub.docker.com/r/futurice/docker-volume-backup)

For certbot (letsencrypt) certificate:

- [Set DNS configuration of your domain name](https://support.google.com/a/answer/48090?hl=en)

## IPv4 Firewall
Create rules to open ports to the internet, or to a specific IPv4 address or range.

- http: 80
- https: 443
- portainer: 9001
- phpmyadmin: 9090

Contents:

- [Auto Configuration and Installation](#automatic)
- [Requirements](#requirements)
- [Configuration](#configuration)
- [Installation](#installation)
- [Usage](#usage)

## Automatic

### Exec install shell script for auto installation and configuration

download with
```
git clone https://github.com/damalis/full-stack-wordpress-for-everyone-with-docker-compose.git
```
Open a terminal and `cd` to the folder in which `docker-compose.yml` is saved and run:

```
cd full-stack-wordpress-for-everyone-with-docker-compose
chmod +x install.sh
./install.sh
```

## Requirements

Make sure you have the latest versions of **Docker** and **Docker Compose** installed on your machine.

- [How install docker](https://docs.docker.com/engine/install/)
- [How install docker compose](https://docs.docker.com/compose/install/)

Clone this repository or copy the files from this repository into a new folder. In the **docker-compose.yml** file you may change the database from MariaDB to MySQL.

Make sure to [add your user to the `docker` group](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user).

## Configuration

download with
```
git clone https://github.com/damalis/full-stack-wordpress-for-everyone-with-docker-compose.git
```

Open a terminal and `cd` to the folder in which `docker-compose.yml` is saved and run:

```
cd full-stack-wordpress-for-everyone-with-docker-compose
```

### Manual Configuration

Copy the example environment into `.env`

```
cp env.example .env
```

Edit the `.env` file to change values of ```LOCAL_TIMEZONE```, ```DOMAIN_NAME```, ```DIRECTORY_PATH```, ```LETSENCRYPT_EMAIL```, ```WORDPRESS_DB_USER```, ```WORDPRESS_DB_PASSWORD```, ```WORDPRESS_DB_NAME```, ```WORDPRESS_TABLE_PREFIX```, ```MYSQL_ROOT_PASSWORD```, ```PMA_CONTROLUSER```, ```PMA_CONTROLPASS```, ```PMA_HTPASSWD_USERNAME``` and ```PMA_HTPASSWD_PASSWORD```.

LOCAL_TIMEZONE=[to see local timezones](https://docs.diladele.com/docker/timezones.html)

DIRECTORY_PATH=```pwd``` at command line

and

```
cp ./proxy/conf.d/proxy.sample.conf ./proxy/conf.d/proxy.conf
```
change example.com to your domain name in ```./proxy/conf.d/proxy.conf``` file.
```
cp ./phpmyadmin/apache2/sites-available/default-ssl.sample.conf ./phpmyadmin/apache2/sites-available/default-ssl.conf
```
change example.com to your domain name in ```./phpmyadmin/apache2/sites-available/default-ssl.conf``` file.

## Installation

### Manual Installation

Firstly: will create external volume
```
docker volume create --driver local --opt type=none --opt device=/home/ubuntu/full-stack-wordpress-for-everyone-with-docker-compose/certbot --opt o=bind certbot-etc
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

to remove portainer and the other containers
```
docker rm -f $(docker ps -a -q)
```

Use `-v` if you need to remove the database volume which is used to persist the database:

```
docker-compose down -v
```

to remove external certbot-etc and portainer and the other volumes

```
docker volume rm $(docker volume ls -q)
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

add and enable [Redis Cache](https://wordpress.org/plugins/redis-cache/) plugin and

must add below code in wp-config.php file.

```
define('WP_REDIS_HOST', 'redis');
define('WP_CACHE_KEY_SALT', 'wp-docker-7f1a7682-9aec-4d4b-9a10-46bbadec41ba');
define('WP_REDIS_PREFIX', $_SERVER['HTTP_HOST']);
define('WP_REDIS_CONFIG', [
	'prefix' => getenv('WP_REDIS_PREFIX') ?: null,
    'timeout' => 0.5,
    'read_timeout' => 0.5,
    'async_flush' => true,
    'compression' => 'zstd',
    'serializer' => 'igbinary',
    'split_alloptions' => true,
    'debug' => false,
    'save_commands' => false,
]);
```

add this code to connect always with ssl in wp-config.php file.

```
define('FORCE_SSL_LOGIN', true);
define('FORCE_SSL_ADMIN', true);
```

### phpMyAdmin

You can also visit `https://example.com:9090` to access phpMyAdmin after starting the containers.

The first authorize screen(htpasswd;username or password) and phpmyadmin login screen the username and the password is the same as supplied in the `.env` file.

### backup

This will back up the all files and folders, once per day, and write it to ./backups with a filename like backup-2022-02-07T16-51-56.tar.gz 
