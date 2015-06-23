# Bayen Fabric File


from fabric.api import *
from fabric.contrib.console import confirm
from fabtools import postgres
from ilogue.fexpect import expect, expecting, run

env.hosts = ['bayen@104.131.132.100']
env.forward_agent = True
env.stage_root = '/home/bayen/'


def prod():
    env.stage_root = '/home/bayen/bayen/game'


# We should eventually have a dev instead of all prod
# def dev():
#     env.stage_root = '/home/bayen/bayen/'


def deploy(reboot=True):
    with cd(env.stage_root):
        run('git pull')

    # Reboots gunicorn
    if reboot:
        restart('gunicorn')
        restart('celery')


def supervisor(command, *args):
    with prefix('workon research'):
        with cd(env.stage_root):
            for a in args:
                run(' supervisorctl -c supervisor.conf %s %s' % (command, a[0]))


def restart(*args):
    supervisor('restart', args)


def stop(*args):
    supervisor('stop', args)


# NOTE: Be super careful about using this
def migrate_schema(app='graph'):
    with prefix('workon research'):
        with cd(env.stage_root):
            run(env.stage_root + '/manage.py makemigrations %s ' % app)


def migrate(app='graph'):
    with prefix('workon research'):
        with cd(env.stage_root):
            run(env.stage_root + '/manage.py migrate %s' % app)
