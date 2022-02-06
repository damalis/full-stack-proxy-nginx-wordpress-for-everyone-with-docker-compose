#!/bin/sh
set -e

# set your domain name in files at folder
domain_name=""
read -p 'Enter Domain Name(ex: example.com): ' domain_name
while [ -z $domain_name ] || [[ $domain_name != *"."* ]]
do
	echo "Try again"
	read -p 'Enter Domain Name(ex: example.com): ' domain_name
	sleep 1
done
echo ""

# set parameters in env.example file
email=""
read -p 'Enter Email Address for letsencrypt ssl(ex: email@domain.com): ' email
while [ -z $email ] || [[ $email != *"@"* ]]
do
	echo "Try again"
	read -p 'Enter Email Address for letsencrypt ssl(ex: email@domain.com): ' email
	sleep 1
done
echo ""

db_username=""
read -p 'Enter Database Username(at least 6 characters): ' db_username
while [ -z $db_username ] || [[ $(echo ${#db_username}) -lt 6 ]]
do
	echo "Try again"
	read -p 'Enter Database Username(at least 6 characters): ' db_username
	sleep 1
done
echo ""

db_password=""
read -p 'Enter Database Password(at least 6 characters): ' db_password
while [ -z $db_password ] || [[ $(echo ${#db_password}) -lt 6 ]]
do
	echo "Try again"
	read -p 'Enter Database Password(at least 6 characters): ' db_password
	sleep 1
done
echo ""

db_name=""
read -p 'Enter Database Name(at least 6 characters): ' db_name
while [ -z $db_name ] || [[ $(echo ${#db_name}) -lt 6 ]]
do
	echo "Try again"
	read -p 'Enter Database Name(at least 6 characters): ' db_name
	sleep 1
done
echo ""

mysql_root_password=""
read -p 'Enter MariaDb/Mysql Root Password(at least 6 characters): ' mysql_root_password
while [ -z $mysql_root_password ] || [[ $(echo ${#mysql_root_password}) -lt 6 ]]
do
	echo "Try again"
	read -p 'Enter MariaDb/Mysql Root Password(at least 6 characters): ' mysql_root_password
	sleep 1
done
echo ""

pma_username=""
read -p 'Enter PhpMyAdmin Username(at least 6 characters): ' pma_username
while [ -z $pma_username ] || [[ $(echo ${#pma_username}) -lt 6 ]]
do
	echo "Try again"
	read -p 'Enter PhpMyAdmin Username(at least 6 characters): ' pma_username
	sleep 1
done
echo ""

pma_password=""
read -p 'Enter PhpMyAdmin Password(at least 6 characters): ' pma_password
while [ -z $pma_password ] || [[ $(echo ${#pma_password}) -lt 6 ]]
do
	echo "Try again"
	read -p 'Enter PhpMyAdmin Password(at least 6 characters): ' pma_password
	sleep 1
done
echo ""

find ./ -type f \( -iname ".*" ! -iname ".sh" ! -iname ".md" ! -iname ".yml" \) -exec sed -i -e 's/example.com/'$domain_name'/g' {} \; & export pid=$!
echo "processing..."
wait $pid

sed -i 's/email@domain.com/'$email'/g' env.example
sed -i 's/db_username/'$db_username'/g' env.example
sed -i 's/db_password/'$db_password'/g' env.example
sed -i 's/db_name/'$db_name'/g' env.example
sed -i 's/mysql_root_password/'$mysql_root_password'/g' env.example
sed -i 's/pma_username/'$pma_username'/g' env.example
sed -i 's/pma_password/'$pma_password'/g' env.example

cp env.example .env

if [ -x "$(command -v docker)" ] && [ -x "$(command -v docker-compose)" ]; then
    # installing wordpress and the other services
	$docker_code = docker-compose up -d; & export pid=$!
	echo "wordpress and the other services installing processing..."
	wait $pid
	if [ $docker_code == 0 ]
	then
		# installing portainer
		$portainer_code = docker-compose -f portainer-docker-compose.yml -p portainer up -d; & export pid=$!
		echo "portainer installing processing..."
		wait $pid
		if [ $portainer_code != 0 ]; then
			echo "Error! could not installed portainer"
			exit 0
		else
			echo ""
			echo "completed setup"
			echo ""
			echo "Website: https://$domain_name"
			echo "Portainer: https://$domain_name:9001"
			echo "phpMyAdmin: https://$domain_name:9090"
			echo ""
		fi
	else
		echo "Error! could not installed wordpress and the other services by docker-compose"
		exit 0
	fi
else
	echo ""
    echo "Install docker and/or docker-compose"
	echo ""
fi