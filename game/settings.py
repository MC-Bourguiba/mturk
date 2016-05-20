"""
Django settings for game project.

For more information on this file, see
https://docs.djangoproject.com/en/1.7/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.7/ref/settings/
"""

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
import os
import dj_database_url

BASE_DIR = os.path.dirname(os.path.dirname(__file__))
PROJECT_PATH = os.path.realpath(os.path.dirname(__file__))


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.7/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = '4erotoju21tbq40q*+w5^*t%72!w9uf9t90320sb9esibi*9+n'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

TEMPLATE_DEBUG = True

ALLOWED_HOSTS = ['127.0.0.1', 'localhost']


# Application definition

INSTALLED_APPS = (
    # 'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'djcelery',
    'djangojs',
    'id_counter',
    'bootstrapform',
    'graph',
    'silk',
    'django_shell_ipynb',
    # 'bootstrap3',
)

MIDDLEWARE_CLASSES = (
    'sslify.middleware.SSLifyMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.auth.middleware.SessionAuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    # 'silk.middleware.SilkyMiddleware',
)

X_FRAME_OPTIONS = 'ALLOWALL'
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}
DATABASES['default'] =  dj_database_url.config()
ROOT_URLCONF = 'game.urls'

WSGI_APPLICATION = 'game.wsgi.application'

# Internationalization
# https://docs.djangoproject.com/en/1.7/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.7/howto/static-files/

STATIC_URL = '/static/'


# Additional locations of static files
STATICFILES_DIRS = (
    # Put strings here, like "/home/html/static" or "C:/www/django/static".
    # Always use forward slashes, even on Windows.
    # Don't forget to use absolute paths, not relative paths.
    # os.path.join(
    #     os.path.dirname(__file__),
    #     'static',
    # ),
    # os.path.join(BASE_DIR, "static"),
)


APPEND_SLASH = True




LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': ('%(levelname)s %(asctime)s %(process)d'
                       ': %(message)s')
        },
        'simple': {
            'format': '%(levelname)s %(message)s'
        },
    },
    'filters': {
        'require_debug_false': {
            '()': 'django.utils.log.RequireDebugFalse'
        }
    },
    'handlers': {
        'mail_admins': {
            'level': 'ERROR',
            'filters': ['require_debug_false'],
            'class': 'django.utils.log.AdminEmailHandler'
        },
        'logfile': {
            'level': 'DEBUG',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': PROJECT_PATH + '/../logs/debug.log',
            'maxBytes': 1024 * 1024 * 20,  # 20MB
            'backupCount': 10,
            'formatter': 'verbose',
        },
    },
    'loggers': {
        'django.request': {
            'handlers': ['logfile'],
            'level': 'WARNING',
            'propagate': True,
        },
        'django.db.backends': {
            'handlers': ['logfile'],
            'level': 'ERROR',
            'propagate': False
        },
        'django': {
            'handlers':['logfile'],
            'propagate': True,
            'level':'DEBUG',
        },
        'graph': {
            'handlers': ['logfile'],
            'level': 'DEBUG',
        },
    }
}



# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.7/howto/static-files/

STATIC_URL = '/static/'


# Additional locations of static files
STATICFILES_DIRS = (
    # Put strings here, like "/home/html/static" or "C:/www/django/static".
    # Always use forward slashes, even on Windows.
    # Don't forget to use absolute paths, not relative paths.
    # os.path.join(
    #     os.path.dirname(__file__),
    #     'static',
    # ),
    os.path.join(BASE_DIR, "static"),
)


APPEND_SLASH = True





import urlparse
#redis_url = urlparse.urlparse(os.environ.get('REDISTOGO_URL', 'redis://localhost:6959'))


#REDIS_URL = os.environ.get('REDISTOGO_URL', 'redis://localhost')
redis_url = urlparse.urlparse(os.environ.get('REDISCLOUD_URL'))

# CELERY SETTINGS
BROKER_URL = os.environ.get('REDISCLOUD_URL')
CELERY_ACCEPT_CONTENT = ['json']
CELERY_TASK_SERIALIZER = 'json'
CELERY_RESULT_SERIALIZER = 'json'
SILKY_PYTHON_PROFILER = True



CACHES = {
    'default': {
        'BACKEND': 'redis_cache.RedisCache',
        "LOCATION": '%s:%s' % (redis_url.hostname, redis_url.port),
         "OPTIONS": {
             "PASSWORD": redis_url.password,
             "DB": 0,
         }
        # 'OPTIONS': {
        #     'DB': 1,
        #     'PASSWORD': 'yadayada',
        #     'PARSER_CLASS': 'redis.connection.HiredisParser',
        #     'CONNECTION_POOL_CLASS': 'redis.BlockingConnectionPool',
        #     'CONNECTION_POOL_CLASS_KWARGS': {
        #         'max_connections': 50,
        #         'timeout': 20,
        #     }
        # },
    },
}






try:
    from local_settings import *
except:
    pass
