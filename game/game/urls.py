from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()

from django.contrib.staticfiles.urls import staticfiles_urlpatterns


urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'game.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),
    url(r'', include('id_counter.urls')),
    url(r'^id_counter/', include('id_counter.urls')),
    url(r'^graph/', include('graph.urls')),
    url(r'^djangojs/', include('djangojs.urls')),
    # url(r'^id_counter/', include('id_counter.urls')),
    # url(r'^admin/', include(admin.site.urls)),
    # url(r'^admin/', include(admin.site.urls)),
)

urlpatterns += staticfiles_urlpatterns()
