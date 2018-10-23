#!/bin/bash

# Create the password-File with the User-Variables
echo $MQTT_USER:$MQTT_PASSWD > /mqtt/config/passwd
mosquitto_passwd -U /mqtt/config/passwd

/usr/sbin/mosquitto -c /mqtt/config/mosquitto.conf
