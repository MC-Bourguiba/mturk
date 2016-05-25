web: gunicorn game.wsgi  -w 3 --log-file -
data: python manage.py loaddata test_bayen.json
worker: celery -A game worker -l info