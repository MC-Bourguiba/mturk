# bayen


Access the server at http://104.131.132.100


Server is currently on DigitalOcean ($5 a month) at 104.131.132.100.

username: bayen
password: bayen

ssh using:

```bash

ssh bayen@104.131.132.100

```

and enter password when prompted


Install everything in requirements.txt using while in /home/bayen/bayen/game:

```bash

supervisord -c supervisor

```

Using fabric:
  Deployment: (Need to be contributor on Github repository and setup SSH ForwardAgent).

  ```bash

    fab prod deploy

  ```

  Database: Schema migrations

  ```bash

    fab prod migrate_schema
    fab prod migrate

  ```


The current setup stack is:

* PostgreSQL for database
* Nginx for webserver
* Gunicorn for WSGI server
* Django w/ Bootstrap and a lot of custom Javascript / AJAX
* Ubuntu 14.04