#!/bin/bash

# nginx-maintenance installer
# https://github.com/stvnwrgs/nginx-maintenance
#
# usage: ./installer.sh servernames
# example: ./installer.sh example-production example.mydomain.com
#
# /etc/init.d/maintenance start/stop
#

PATH_TO_WWW= /var/www/maintenance
SEARCH="{{servernames}}"

if [ "$#" -ne 1 ]; then
    echo "please give me some servernames"
    echo "example: installer.sh 'server.com servername2.com'"
    exit 1
fi
echo "$1"
mkdir -p $PATH_TO_WWW
cp ./maintenance /etc/init.d/maintenance
cp ./000-maintenance /etc/nginx/sites-available/000-maintenance
cp ./index.html $PATH_TO_WWW/index.html

cat ./000-maintenance.txt | sed -e "s/$SEARCH/$1/" >> /etc/nginx/sites-available/000-maintenance

echo "installed nginx-maintenance stat with /etc/init.d/maintenance start"
