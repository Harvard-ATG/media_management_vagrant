# README

## Quickstart

Add symlinks to directory containing the media management API and LTI git repositories:

```
$ ln -s ../media_management_apps apps
```

Start and provision vagrant box:

```
$ vagrant up 
$ vagrant ssh
```

Setup API:

```
$ export DJANGO_SETTINGS_MODULE=media_management_api.settings.local
$ workon media_management_api
$ cd /srv/media_management_api
$ ./manage.py migrate
$ ./manage.py collectstatic
```

Setup LTI:

```
$ export DJANGO_SETTINGS_MODULE=media_management_lti.settings.local
$ workon media_management_lti
$ cd /srv/media_management_lti/app
$ npm install && bower install
$ export PATH=`pwd`/node_modules/.bin:$PATH
$ gulp build
$ cd /srv/media_management_lti
$ ./manage.py migrate
$ ./manage.py runserver 0.0.0.0:8080
```

_Note:_ by default the server is provisioned to run NGINX + UWSGI for the API.
When developing the LTI tool, it is expected that `manage.py runserver` will be
used since static files will ned to be rebuilt constantly. 

## Useful Aliases

```sh
alias workon_api='export DJANGO_SETTINGS_MODULE=media_management_api.settings.local && workon media_management_api && cd /srv/media_management_api'
alias workon_lti='export DJANGO_SETTINGS_MODULE=media_management_lti.settings.local && workon media_management_lti && cd /srv/media_management_lti'
```

This allows you to type `workon_lti` or `workon_api` which will change
directory to the API/LTI tool and set the appropriate virtualenv and DJANGO
settings module.


## URLS

- http://localhost:8000/api
- http://localhost:8080/lti/config
