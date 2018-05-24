# hass-docker-env

This docker environment provides the main components to get started with HomeAssistant exposed on the web and secured with standard HTTPS encryption. The three main containers that are always running are:
* samba: a samba server to edit the files from your computer
* homeassistant: the HomeAssistant server listening on port 8123
* nginx: the nginx server listening on port 80 and routing the traffic to HomeAssistant or letsencrypt

Then there are two containers that return right away after their respective tasks are finished, and which are called regularly by cron on the host-container:
* duckdns: a script that updates the IP of your duckdns-domain
* letsencrypt: a script that creates or renews your ssl certificates

These containers were developped and tested on a RaspberryPi 3B+, the base images may have to be changed to run on a different hardware.

I will detail the steps to get this docker-container running on RaspberryPi running Raspbian Stretch Lite

## Environment variables

The duckdns container uses two environment variables to update the IP adress of your domain:
* DUCKDNS_TOKEN: The token that you can retrieve on your account page at duckdns.org
* DUCKDNS_DOMAIN: The domain-name for which the IP adress will be updated (the part that comes before the ducdns.org in your URL)

The letsencrypt container uses two environment variables to generate the SSL certificates:
* LETSENCRYPT_DOMAIN: The domain for which the certificate will be generated (URL with duckdns.org at the end)
* LETSENCRYPT_EMAIL: The email used for generating the certificate

The nginx container uses a build argument to set the correct path pointing to the generated certificates in the nginx config:
* domain: the domain for which the LetsEncrypt certificates are generated

## Setting up the raspberry with docker

```bash
# change password
passwd

# update packages
sudo apt-get update
sudo apt-get upgrade -y

# install git
sudo apt-get install git

# install docker
curl -sSL https://get.docker.com | sh
# add pi-user to docker gorup
sudo usermod -aG docker pi
# enable docker
sudo systemctl enable docker

# reboot the pi
sudo reboot

# start docker
sudo systemctl start docker

# install docker-compose
sudo apt-get -y install python-pip
sudo pip install docker-compose
```

## Settings up the docker environment
Get the docker enironment by cloning this repository

```bash
git clone https://github.com/haesena/hass-docker-env.git home-assistant
```

Open the file docker-compose.yml and replace the build argument for the nginx containert and the environment variables for the duckdns and letsencrypt containers as detailed in the section Environment variables.

Change to the home-assistant directory and run the `up` command to build and start the containers:

```bash
cd home-assistant
docker-compose up
```
