#!/bin/bash

printf "starting Duck DNS cron\n"
cd ~/home-assistant

/usr/local/bin/docker-compose run --rm duckdns
printf "\n\n"
