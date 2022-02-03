#!/bin/bash

# set your domain in files at folder
read -p "Enter Domain Name: " domain_name
find ./ -type f -exec sed -i -e 's/example.com/${domain_name}/g' {} \;

# set parameters in env.example file
read -p "Enter Email address: " email
sed -i 's/email@domain.com/${email}/g' env.example;

read -p "Enter Database Username: " db_username
sed -i 's/db_username/${db_username}/g' env.example;

read -p "Enter Database Password: " db_password
sed -i 's/db_password/${db_password}/g' env.example;

read -p "Enter Database Name: " db_name
sed -i 's/db_name/${db_name}/g' env.example;

read -p "Enter Maria Root Password: " mysql_root_password
sed -i 's/mysql_root_password/${mysql_root_password}/g' env.example

read -p "Enter PhpMyAdmin Username: " pma_username
sed -i 's/pma_username/${pma_username}/g' env.example

read -p "Enter PhpMyAdmin Password: " pma_password
sed -i 's/pma_password/${pma_password}/g' env.example

echo "completed setup"
echo ""