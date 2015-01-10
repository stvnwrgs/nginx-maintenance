#!/bin/bash

# nginx-maintenance installer
# https://github.com/stvnwrgs/nginx-maintenance
#
# usage: ./installer.sh servernames
# example: ./installer.sh example-production example.mydomain.com
#
# /etc/init.d/maintenance start/stop
#

PATH_TO_WWW="/var/www/maintenance"
SERVERNAMES="{{servernames}}"
SSL_CERT=""
SSL_KEY=""

echo "$#"

if [ "$#" -lt 1 ]; then
    echo "please give me some servernames"
    echo "example: installer.sh 'server.com servername2.com' /path/to/sslcert /path/to/sslkey"
    exit 1
fi
echo "$1"

if [ "$#" -eq 3 ]; then
    echo "WITH SSL"

    if [ ! -f "$2" ] || [ ! -f "$3" ]; then
        echo "ERROR! Wrong path to ssl cert or key"
        exit 1
    fi

    SSL_CERT="ssl_certificate_key $2;"
    SSL_KEY="ssl_certificate_key $3;"
fi

if [ ! -d "$PATH_TO_WWW" ]
    echo "creating $PATH_TO_WWW directory"
    then mkdir -p $PATH_TO_WWW
fi
echo "copying files"
cp ./maintenance /etc/init.d/maintenance
cp ./000-maintenance /etc/nginx/sites-available/000-maintenance
cp ./index.html $PATH_TO_WWW/index.html

cat ./000-maintenance | sed -e "s/{{servernames}}/$1/" > /tmp/maintenace.conf
cat /tmp/maintenace.conf | sed -e "s/{{root}}/$PATH_TO_WWW/" > /tmp/maintenace.conf

cat ./000-maintenance | sed -e "s/ssl_certificate;/$SSL_CERT/" > /tmp/maintenace.conf
cat /tmp/maintenace.conf | sed -e "s/ssl_certificate_key;/$SSL_KEY/" > /tmp/maintenace.conf

cp /tmp/maintenace.conf /etc/nginx/sites-available/000-maintenance
echo "DONE!"
echo ""
echo "installed nginx-maintenance stat with /etc/init.d/maintenance start"
