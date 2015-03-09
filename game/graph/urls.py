from django.conf.urls import patterns, url, include

from graph import views

urlpatterns = patterns('',
                       url(r'^$', views.index),
                       url(r'^editor/$', views.editor),
                       url(r'^create_graph/$', views.create_graph),
                       url(r'^load_graph/$', views.load_graph),
                       # url(r'^game/$', views.game),
                       # url(r'^logout/$', views.logout),
                       # url(r'^reset/$', views.reset),
)
