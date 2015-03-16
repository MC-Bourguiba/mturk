from django.conf.urls import patterns, url, include
from django.contrib.auth.views import login, logout


from graph import views

login_args = {'template_name': 'graph/login.djhtml',
              'extra_context': {'next': '/graph/index/'},
              }

logout_args = {'next_page': '/graph/index'}

urlpatterns = patterns('',
                       url(r'^$', views.index),
                       url(r'^index/$', views.index),
                       url(r'^accounts/login/$',  login, login_args),
                       url(r'^accounts/logout/$', logout, logout_args),
                       url(r'^accounts/profile/$', views.show_graph),
                       url(r'^create_account/$', views.create_account),
                       url(r'^editor/$', views.editor),
                       url(r'^create_graph/$', views.create_graph),
                       url(r'^load_graph/$', views.load_graph),
                       url(r'^generate_paths/$', views.generate_all_paths),
)
