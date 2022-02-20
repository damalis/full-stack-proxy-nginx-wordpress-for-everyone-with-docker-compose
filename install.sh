#!/bin/bash

clear
echo ""
echo "================================================================="
echo "|  								|"
echo "|  full-stack-wordpress-for-everyone-with-docker-compose Setup  |"
echo "|	 		  by Erdal ALTIN			|"
echo "|  								|"
echo "================================================================="
sleep 2

# Uninstall old versions
echo "Older versions of Docker were called docker, docker.io, or docker-engine. If these are installed, uninstall them"

sudo apt-get remove docker docker-engine docker.io containerd runc

echo ""
echo "Done ✓"
echo "============================================"

# install start
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo chmod 666 /var/run/docker.sock
sudo apt-get update

Installed=`sudo apt-cache policy docker-ce | sed -n '2p' | cut -c 14-`
Candidate=`sudo apt-cache policy docker-ce | sed -n '3p' | cut -c 14-`

if [[ "$Installed" != "$Candidate" ]]; then 
	sudo apt-get install docker-ce docker-ce-cli containerd.io
elif [[ "$Installed" == "$Candidate" ]]; then
	echo ""
	echo 'docker currently version already installed.'
fi


echo ""
echo "Done ✓"
echo "============================================"

##########
# Run Docker without sudo rights
##########
echo ""
echo ""
echo "============================================"
echo "| Running Docker without sudo rights..."
echo "============================================"
echo ""
sleep 2

sudo groupadd docker
sudo usermod -aG docker ${USER}
# su - ${USER} &

echo ""
echo "Done ✓"
echo "============================================"

##########
# Install Docker-Compose
##########
echo ""
echo ""
echo "============================================"
echo "| Installing Docker Compose v1.29.2..."
echo "============================================"
echo ""
sleep 2

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# permission for Docker daemon socket
sudo chmod 666 /var/run/docker.sock

echo ""
echo "Done ✓"
echo "============================================"

##########
# Setup project variables
##########
echo ""
echo ""
echo "============================================"
echo "| Please enter project related variables..."
echo "============================================"
echo ""
sleep 2

# set your domain name
domain_name=""
read -p 'Enter Domain Name(e.g. : example.com): ' domain_name
[ -z $domain_name ] && domain_name="NULL"
host -N 0 $domain_name 2>&1 > /dev/null
while [ $? -ne 0 ]
do
	echo "Try again"
	read -p 'Enter Domain Name(e.g. : example.com): ' domain_name
	[ -z $domain_name ] && domain_name="NULL"
	host -N 0 $domain_name 2>&1 > /dev/null
done
echo "Ok."

# set parameters in env.example file
email=""
regex="^[a-zA-Z0-9\._-]+\@[a-zA-Z0-9._-]+\.[a-zA-Z]+\$"
read -p 'Enter Email Address for letsencrypt ssl(e.g. : email@domain.com): ' email
while [ -z $email ] || [[ ! $email =~ $regex ]]
do
	echo "Try again"
	read -p 'Enter Email Address for letsencrypt ssl(e.g. : email@domain.com): ' email
	sleep 1
done
echo "Ok."

db_username=""
read -p 'Enter Database Username(at least 6 characters): ' db_username
while [ -z $db_username ] || [[ $(echo ${#db_username}) -lt 6 ]]
do
	echo "Try again"
	read -p 'Enter Database Username(at least 6 characters): ' db_username
	sleep 1
done
echo "Ok."

db_password=""
read -p 'Enter Database Password(at least 6 characters): ' db_password
while [ -z $db_password ] || [[ $(echo ${#db_password}) -lt 6 ]]
do
	echo "Try again"
	read -p 'Enter Database Password(at least 6 characters): ' db_password
	sleep 1
done
echo "Ok."

db_name=""
read -p 'Enter Database Name(at least 6 characters): ' db_name
while [ -z $db_name ] || [[ $(echo ${#db_name}) -lt 6 ]]
do
	echo "Try again"
	read -p 'Enter Database Name(at least 6 characters): ' db_name
	sleep 1
done
echo "Ok."

mysql_root_password=""
read -p 'Enter MariaDb/Mysql Root Password(at least 6 characters): ' mysql_root_password
while [ -z $mysql_root_password ] || [[ $(echo ${#mysql_root_password}) -lt 6 ]]
do
	echo "Try again"
	read -p 'Enter MariaDb/Mysql Root Password(at least 6 characters): ' mysql_root_password
	sleep 1
done
echo "Ok."

pma_username=""
read -p 'Enter PhpMyAdmin Username(at least 6 characters): ' pma_username
while [ -z $pma_username ] || [[ $(echo ${#pma_username}) -lt 6 ]]
do
	echo "Try again"
	read -p 'Enter PhpMyAdmin Username(at least 6 characters): ' pma_username
	sleep 1
done
echo "Ok."

pma_password=""
read -p 'Enter PhpMyAdmin Password(at least 6 characters): ' pma_password
while [ -z $pma_password ] || [[ $(echo ${#pma_password}) -lt 6 ]]
do
	echo "Try again"
	read -p 'Enter PhpMyAdmin Password(at least 6 characters): ' pma_password
	sleep 1
done
echo "Ok."

read -p "Apply changes (y/n)? " choice
case "$choice" in
  y|Y ) echo "Yes! Proceeding now...";;
  n|N ) echo "No! Aborting now...";;
  * ) echo "Invalid input! Aborting now...";;
esac

cp ./phpmyadmin/config.sample.inc.php ./phpmyadmin/config.inc.php

cp ./proxy/conf.d/proxy.sample.conf ./proxy/conf.d/proxy.conf
sed -i 's/example.com/'$domain_name'/g' ./proxy/conf.d/proxy.conf
cp ./phpmyadmin/apache2/sites-available/default-ssl.sample.conf ./phpmyadmin/apache2/sites-available/default-ssl.conf
sed -i 's/example.com/'$domain_name'/g' ./phpmyadmin/apache2/sites-available/default-ssl.conf

cp env.example .env

sed -i 's/example.com/'$domain_name'/g' .env
sed -i 's/email@domain.com/'$email'/g' .env
sed -i 's/db_username/'$db_username'/g' .env
sed -i 's/db_password/'$db_password'/g' .env
sed -i 's/db_name/'$db_name'/g' .env
sed -i 's/mysql_root_password/'$mysql_root_password'/g' .env
sed -i 's/pma_username/'$pma_username'/g' .env
sed -i 's/pma_password/'$pma_password'/g' .env
sed -i "s@directory_path@$(pwd)@" .env

if [ -x "$(command -v docker)" ] && [ -x "$(command -v docker-compose)" ]; then
    # Firstly: create external volume
	docker volume create --driver local --opt type=none --opt device=`pwd`/certbot --opt o=bind certbot-etc > /dev/null
	# installing wordpress and the other services
	docker-compose up -d & export pid=$!
	echo "wordpress and the other services installing proceeding..."
	echo ""
	wait $pid
	if [ $? -eq 0 ]
	then
		# installing portainer
		docker-compose -f portainer-docker-compose.yml -p portainer up -d & export pid=$!
		echo ""
		echo "portainer installing proceeding..."
		wait $pid
		if [ $? -ne 0 ]; then
			echo "Error! could not installed portainer" >&2
			exit 1
		else
			echo ""
			echo "completed setup"
			echo ""
			echo "Website: https://$domain_name"
			echo "Portainer: https://$domain_name:9001"
			echo "phpMyAdmin: https://$domain_name:9090"
			echo ""
			echo "Ok."
		fi
	else
		echo ""
		echo "Error! could not installed wordpress and the other services with docker-compose" >&2
		exit 1
	fi
else
	echo ""
    echo "not found docker and/or docker-compose, Install docker and/or docker-compose" >&2
	exit 1
fi