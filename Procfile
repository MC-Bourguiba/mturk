web: gunicorn game.wsgi  -w 3 --log-file -
data: newrelic-admin run-program gunicorn -w 3 wsgi:application
worker: celery -A game worker -l info