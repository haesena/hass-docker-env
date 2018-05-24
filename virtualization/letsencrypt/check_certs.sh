#!/bin/sh

if [[ -f "/var/www/letsencrypt/certs_created" ]]; then
	echo "renewing"
	/usr/bin/certbot renew
else
	echo "initializing"
	
	rm -rf /etc/letsencrypt/live/

	/usr/bin/certbot certonly \
	 	--webroot \
	 	-w /var/www/letsencrypt \
	 	--domains $LETSENCRYPT_DOMAIN \
	 	--email $LETSENCRYPT_EMAIL \
	 	--agree-tos -n

	touch /var/www/letsencrypt/certs_created
fi