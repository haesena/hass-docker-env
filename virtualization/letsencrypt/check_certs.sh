#!/bin/sh

if [[ -f "/usr/scripts/certs_created" ]]; then
	echo "renewing"
	/usr/bin/certbot renew
else
	echo "initializing"
	/usr/bin/certbot certonly \
	 	--webroot \
	 	-w /var/www/letsencrypt \
	 	--domains $LETSENCRYPT_DOMAIN \
	 	--email $LETSENCRYPT_EMAIL \
	 	--agree-tos -n

	touch /usr/scripts/certs_created
fi