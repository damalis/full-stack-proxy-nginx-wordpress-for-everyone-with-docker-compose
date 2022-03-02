#!/bin/sh
set -e

DOMAIN=$1

if [ -z $1 ]; then
	echo "DOMAIN environment variable is not set"
	exit 1;
fi

if [ ! -f ./certbot/ssl-dhparam.pem ]; then
	openssl dhparam -out $2/ssl-dhparam.pem 2048
fi

use_lets_encrypt_certificates() {
	echo "switching nginx to use Let's Encrypt certificate for $1"	
	sed -i '/location.*acme-challenge/,/}/ s/^[^#]/#/; /#location.\/./,/#}/ s/#//; s/#listen/listen/g; s/#ssl_/ssl_/g' ./proxy/conf.d/proxy.conf	
}

reload_nginx() {
	echo "Reloading Nginx configuration"
	doker-compose stop proxy
	doker-compose start proxy
}

wait_for_lets_encrypt() {
	if sudo [ -d "./certbot/live/$1" ]; then 
		break 
	else
		until sudo ls ./certbot/live/$1 2>/dev/null; do
			echo "waiting for Let's Encrypt certificates for $1"
			sleep 5s & wait ${!}
			if sudo [ -d "./certbot/live/$1" ]; then break; fi
		done
	fi;	
	use_lets_encrypt_certificates "$1" "$2" "$3"
	reload_nginx
	exit 0
}

for domain in $DOMAIN; do
	if sudo [ ! -d "$2/live/$domain" ]; then
		wait_for_lets_encrypt "$domain" &
	else
		use_lets_encrypt_certificates "$domain"
	fi
done

#doker-compose stop proxy
#doker-compose start proxy
