from django.conf.urls import patterns, url, include

from graph import views

urlpatterns = patterns('',
                       url(r'^$', views.index),
                       # url(r'^game/$', views.game),
                       # url(r'^logout/$', views.logout),
                       # url(r'^reset/$', views.reset),
)
