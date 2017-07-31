#!/bin/sh

if [ -f "/var/cms/.env" ]
then
  echo ".env found."
  cp /var/cms/.env /var/www/html/.env
else
	echo ".env not found."
fi

exec apache2-foreground "$@"

