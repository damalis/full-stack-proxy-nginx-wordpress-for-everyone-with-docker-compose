#!/bin/sh
set -e

# set your domain in files at folder
read -p "Enter Domain Name: " domain_name
if [ ! -n "${domain_name}" ]
then
	find ./ -type f -exec sed -i -e 's/example.com/${domain_name}/g' {} \;
else
	return 0
fi

# set parameters in env.example file
read -p "Enter Email address: " email
if [ ! -n "${email}" ]
then
	sed -i 's/email@domain.com/${email}/g' env.example;
else
	return 0
fi

read -p "Enter Database Username: " db_username
if [ ! -n "${db_username}" ]
then
	sed -i 's/db_username/${db_username}/g' env.example;
else
	return 0
fi

read -p "Enter Database Password: " db_password
if [ ! -n "${db_password}" ]
then
	sed -i 's/db_password/${db_password}/g' env.example;
else
	return 0
fi

read -p "Enter Database Name: " db_name
if [ ! -n "${db_name}" ]
then
	sed -i 's/db_name/${db_name}/g' env.example;
else
	return 0
fi

read -p "Enter Maria Root Password: " mysql_root_password
if [ ! -n "${mysql_root_password}" ]
then
	sed -i 's/mysql_root_password/${mysql_root_password}/g' env.example
else
	return 0
fi

read -p "Enter PhpMyAdmin Username: " pma_username
if [ ! -n "${pma_username}" ]
then
	sed -i 's/pma_username/${pma_username}/g' env.example
else
	return 0
fi

read -p "Enter PhpMyAdmin Password: " pma_password
if [ ! -n "${pma_password}" ]
then
	sed -i 's/pma_password/${pma_password}/g' env.example
else
	return 0
fi

# installing wordpress and the other services
if [ (docker-compose up -d) != 0 ]; then
   echo "Error!"
   exit 0
else
	# installing portainer
	if { (docker-compose -f portainer-docker-compose.yml -p portainer up -d) != 0 ]
		echo "Error!"
		exit 0
	else		
		echo "completed setup"
		echo "Website: https://${domain_name}"
		echo "Portainer: https://${domain_name}:9001"
		echo "phpMyAdmin: https://${domain_name}:9090"
		echo ""
	fi
fi
