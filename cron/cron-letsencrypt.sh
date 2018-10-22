#!/bin/bash

printf "starting Lets's Encrypt cron"

cd ~/home-assistant
/usr/local/bin/docker-compose run --rm letsencrypt

printf "\n\n"

