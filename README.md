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
$ workon --cd media_management_api
$ ./manage.py migrate
$ ./manage.py collectstatic
```

Setup LTI:

```
$ workon --cd media_management_lti
$ cd app 
$ npm install && bower install
$ export PATH=`pwd`/node_modules/.bin:$PATH
$ gulp build
$ cd ..
$ ./manage.py migrate
$ ./manage.py runserver 0.0.0.0:8080
```

_Note:_ by default the server is provisioned to run NGINX + UWSGI for the API.
When developing the LTI tool, it is expected that `manage.py runserver` will be
used since static files will ned to be rebuilt constantly. 

## URLS

- http://localhost:8000/api
- http://localhost:8080/lti/config
