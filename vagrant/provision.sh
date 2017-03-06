#!/bin/bash
USER=vagrant
HOME=/home/vagrant
PROJECTS=(media_management_api media_management_lti)

# Update packages
sudo apt-get update
sudo apt-get -y autoremove

# Install system packages
sudo apt-get -y install build-essential libffi-dev
sudo apt-get -y install libxslt1-dev libxml2 libxml2-dev
sudo apt-get -y install openssl libcurl4-openssl-dev
sudo apt-get -y install git curl wget unzip
sudo apt-get -y install python-dev python-pip python-setuptools redis-server
sudo apt-get -y install postgresql postgresql-contrib libpq-dev
sudo apt-get -y install zlib1g-dev libjpeg8-dev
sudo apt-get -y install nginx

sudo curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install system python dependencies (project-specific will be installed in a virtualenv)
sudo -H pip install virtualenv
sudo -H pip install urllib3[secure]
sudo -H pip install uwsgi

# Setup database
for project in ${PROJECTS[@]}
do
	#sudo -u postgres -i psql -d postgres -c "DROP DATABASE IF EXISTS $project"
	#sudo -u postgres -i psql -d postgres -c "DROP USER IF EXISTS $project"
	sudo -u postgres -i psql -d postgres -c "CREATE USER $project WITH PASSWORD '$project'"
	sudo -u postgres -i psql -d postgres -c "CREATE DATABASE $project WITH OWNER $project"
done

# Ensure permissions are correct
sudo chown -R www-data:www-data /srv

sudo -u $USER -s bash

# Ensure github.com ssh public key is in $HOME/.ssh/known_hosts file
chmod 700 $HOME/.ssh
if ! grep -sq github.com $HOME/.ssh/known_hosts; then
	ssh-keyscan github.com >> $HOME/.ssh/known_hosts
fi
chmod 744 $HOME/.ssh/known_hosts

# Install project requirements
for project in ${PROJECTS[@]}
do
	mkdir -pv /opt/virtualenvs/$project
	virtualenv /opt/virtualenvs/$project
	. /opt/virtualenvs/$project/bin/activate
	pip install -r /srv/$project/$project/requirements/local.txt
done

# uwsgi
sudo cp /opt/provision/upstart/uwsgi.conf /etc/init/uwsgi.conf
sudo service uwsgi stop

# nginx
sudo ln -sf /opt/provision/nginx/apps.conf /etc/nginx/sites-enabled/apps
sudo service nginx stop
