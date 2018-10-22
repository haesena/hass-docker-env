#!/bin/sh

rm /config/home-assistant.log
rm /config/OZW_Log.txt

ln -s /hass-db/home-assistant.log /config/home-assistant.log
ln -s /hass-db/OZW_Log.txt /config/OZW_Log.txt

python -m homeassistant --config /config
