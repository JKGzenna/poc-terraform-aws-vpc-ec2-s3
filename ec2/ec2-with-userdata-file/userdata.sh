#!/bin/bash
yum install httpd -y
chmod 775 -R /var/www
echo "Hello UK microsites server from terraform!!!" > /var/www/html/index.html
service httpd start
