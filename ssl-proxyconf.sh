#!/bin/sh
set -e

if [ -z $1 ]; then
	echo "DOMAIN environment variable is not set"
	exit 1;
fi

if [ ! -f $2/ssl-dhparam.pem ]; then
	openssl dhparam -out $2/ssl-dhparam.pem 2048
fi

use_lets_encrypt_certificates() {
	echo "switching nginx to use Let's Encrypt certificate for $1"	
	sed -i '/location.*acme-challenge/,/}/ s/^[^#]/#/; /#location.\/./,/#}/ s/#//; s/#listen/listen/g; s/#ssl_/ssl_/g' $3/conf.d/default.conf > $3/conf.d/default.conf.bak && cp $3/conf.d/default.conf.bak $3/conf.d/default.conf	
}

reload_nginx() {
	echo "Reloading Nginx configuration"
	nginx -s reload
}

wait_for_lets_encrypt() {
	if [ -n "$(find $2/live -name '$1-*' | head -1)" ]; then 
		break 
	else
		until [ -n "$(find $2/live -name '$1-*' | head -1)" ]; do
			echo "waiting for Let's Encrypt certificates for $1"
			sleep 5s & wait ${!}
			if [ -n "$(find $2/live -name '$1-*' | head -1)" ]; then break; fi
		done
	fi;	
	use_lets_encrypt_certificates "$1" "$2" "$3"
	reload_nginx
}

for domain in $1; do
	if [ -n "$(find $2/live -name '$1-*' | head -1)" ]; then
		wait_for_lets_encrypt "$domain" "$2" "$3" &
	else
		use_lets_encrypt_certificates "$domain" "$2" "$3"
	fi
done

exec nginx -g "daemon off;"
