web: gunicorn game.wsgi  -w 3 --log-file -
web: newrelic-admin run-program gunicorn appname.wsgi
worker: celery -A game worker -l info