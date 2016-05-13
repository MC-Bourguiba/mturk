from django.conf.urls import patterns, url, include

from id_counter import views

urlpatterns = patterns('',
                       url(r'^$', views.login),
                       url(r'^game/$', views.game),
                       url(r'^logout/$', views.logout),
                       url(r'^reset/$', views.reset),
                       url(r'^djangojs/', include('djangojs.urls')),
)
