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
    $2="(print - "$2" | sed 's/\//\\\//g')"
    $3="(print - "$3" | sed 's/\//\\\//g')"
    SSL_CERT="ssl_certificate_key $2;"
    SSL_KEY="ssl_certificate_key $3;"
fi

if [ ! -d "$PATH_TO_WWW" ]
    echo "creating $PATH_TO_WWW directory"
    then mkdir -p $PATH_TO_WWW
fi
echo "copying files"
 ./index.html $PATH_TO_WWW/index.html

cat ./000-maintenance | sed -e "s|{{servernames}}|$1|" > /tmp/maintenance.conf.a
cat /tmp/maintenance.conf.a | sed -e "s|{{root}}|$PATH_TO_WWW|" > /tmp/maintenance.conf.b

cat ./000-maintenance.conf.b | sed -e "s|ssl_certificate;|$SSL_CERT|" > /tmp/maintenance.conf.a
cat /tmp/maintenance.conf.a | sed -e "s|ssl_certificate_key;|$SSL_KEY|" > /tmp/maintenance.conf.b

cp /tmp/maintenance.conf.b /etc/nginx/sites-available/000-maintenance
echo "DONE!"
echo ""
echo "installed nginx-maintenance stat with /etc/init.d/maintenance start"
