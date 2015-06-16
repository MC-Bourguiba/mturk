# bayen

Feature:
* Display weighted cost

redis: Run redis anywhere

```bash
redis-server
```


celery: Need to run at the root of the project

```bash
celery -A game worker -l info
```


UI:
* Countdown
* Highlight paths in list and graph
* Normalize weights automatically (show box)
* Slide graph
* Display previous weights
* Show total score
* Username, allow special characters
* Path colors match graph and list
* Thickness of flow on graph
* Maybe show edge costs
* Everything fit in smaller space (so no scroll)


Bugs:
* Allow integer values (0)
* Don't let


Access the server at http://104.131.132.100


Server is currently on a super cheap DigitalOcean server ($5 a month) at 104.131.132.100.

username: bayen

password: bayen

ssh using:

```bash
ssh bayen@104.131.132.100
```

and enter password when prompted

The credentials for the "master" user:

username: root

password: root


Install everything in requirements.txt


If supervisor is down, then cd to /home/bayen/bayen/game and:

```bash
supervisord -c supervisor.conf
```

Use supervisorctl for managing the server


```bash
supervisorctl -c supervisor.conf
```


Using fabric:

* Deployment: (Need to be contributor on Github repository and setup SSH ForwardAgent).

  ```bash
    fab prod deploy
  ```

*  Database: Schema migrations

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


Accessing the PostgreSQL database: (Assuming using Mac OS X):

Use pgAdmin3 and follow this setup:

![] (postgres_access.png)

TODO (need to be updated):

* Root
  * Create user
  * Origin, destination, flow
  * Number of iterations
  * Can end and start the game

* Client
  * Normal User
  * Assigned next available positions
  * Notifcation that game has started
    * iteration goes from 0 to 1?
    * Can start input decisions
    * History:
      * Cumulative cost
      * Show last cost and cumulative

* Styling
** Use CSS

* Caching? (Probably not needed?)