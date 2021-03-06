# hass-docker-env

This docker environment provides the main components to get started with Home Assistant exposed on the web and secured with standard HTTPS encryption. The setup is loosely based on the setup descibed in the [Home Assistant NGINX ecosystem](https://www.home-assistant.io/docs/ecosystem/nginx/). The three main containers that are always running are:
* samba: a samba server to edit the files from your computer
* homeassistant: the Home Assistant server listening on port 8123
* nginx: the nginx server listening on port 80 and routing the traffic to Home Assistant or Let's Encrypt

Then there are two containers that return right away after their respective tasks are finished, and which are called regularly by cron on the host-container:
* duckdns: a script that updates the IP of your Duck DNS domain
* letsencrypt: a script that creates or renews your ssl certificates

These containers were developped and tested on a RaspberryPi 3B+, the base images may have to be changed to run on a different hardware.

I will detail the steps to get this docker-container running on RaspberryPi running Raspbian Stretch Lite.

## Prerequisites
To use this environment out of the box, you need a Duck DNS domain forwarded to your router. The port 80 on your router has to be forwarded to the machine where this environment will run on.

## Environment variables

The duckdns container uses two environment variables to update the IP address of your domain:
* DUCKDNS_TOKEN: The token that you can retrieve on your account page at duckdns.org
* DUCKDNS_DOMAIN: The domain-name for which the IP address will be updated (the part that comes before the duckdns.org in your URL)

The letsencrypt container uses two environment variables to generate the SSL certificates:
* LETSENCRYPT_DOMAIN: The domain for which the certificate will be generated (URL with duckdns.org at the end)
* LETSENCRYPT_EMAIL: The email used for generating the certificate

The nginx container uses a build argument to set the correct path pointing to the generated certificates in the nginx config:
* domain: the domain for which the Let's Encrypt certificates are generated

## Setting up the raspberry with docker

```bash
# change password
passwd

# update packages
sudo apt-get update
sudo apt-get upgrade -y

# set your current timezone
sudo cp /usr/share/zoneinfo/Europe/Paris /etc/localtime

# install git
sudo apt-get install git

# install docker
curl -sSL https://get.docker.com | sh
# add pi-user to docker gorup
sudo usermod -aG docker pi
# enable docker
sudo systemctl enable docker

# install docker-compose
sudo apt-get -y install python-pip
sudo pip install docker-compose

# reboot the pi
sudo reboot

# start docker
sudo systemctl start docker
```

## Setting up the docker environment
Get the docker environment by cloning this repository:

```bash
git clone https://github.com/haesena/hass-docker-env.git home-assistant
```

Open the file `docker-compose.yml` and replace the build argument for the nginx container and the environment variables for the duckdns and letsencrypt containers as detailed in the section Environment variables.

During the nginx build a DH-Params file will be generated, this will take a while. You can skip this step if you already have a generated file that you want to use. Copy your key to the file `virtualization/nginx/dhparams.pem`, if this file is not empty during the build, the DH-Params will not be generated.

Change to the home-assistant directory and run the `up` command to build and start the containers:

```bash
cd home-assistant
docker-compose up
```

## Setting up the cronjobs
Make sure the two scripts `cron-duckdns.sh` and `cron-letsencrypt.sh` in the cron directory are executable. Then add these two scripts to you preferred cronjob manager. For example, to run the duckdns cron every 5 minutes and the letsencrypt cron at 7:00 and 19:00 using `crontab`, run `crontab -e` and add these two lines at the end:

```
*/5 * * * * ~/home-assistant/cron/cron-duckdns.sh
* 7,19 * * * ~/home-assistant/cron/cron-letsencrypt.sh
```

