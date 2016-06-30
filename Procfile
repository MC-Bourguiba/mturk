web: gunicorn game.wsgi  -w 3 --log-file -
data: newrelic-admin run-program gunicorn game.wsgi
worker: celery -A game worker -l info