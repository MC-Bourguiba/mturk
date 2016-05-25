web: gunicorn game.wsgi  -w 3 --log-file -
worker: celery -A game worker -l info