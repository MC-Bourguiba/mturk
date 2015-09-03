from django.core.urlresolvers import reverse, reverse_lazy
from django.conf.urls import patterns, url, include
from django.contrib.auth.views import login, logout


from graph import views

login_args = {'template_name': 'graph/login.djhtml',
              'extra_context': {'next': reverse_lazy('graph_index')},
}

logout_args = {'next_page': '/graph/index'}

urlpatterns = patterns('',
                       url(r'^$', views.index, name='graph'),
                       url(r'^index/$', views.index, name='graph_index'),
                       url(r'^model/(?P<modelname>[a-zA-Z0-9_]+)/$', views.get_model_info, name='model'),
                       url(r'^accounts/login/$',  login, login_args, name='login'),
                       url(r'^accounts/logout/$', logout, logout_args, name='logout'),
                       url(r'^accounts/profile/$', views.show_graph, name='show_graph'),
                       url(r'^create_account/$', views.create_account, name='create_user'),
                       url(r'^editor/$', views.editor, name='graph_editor'),
                       url(r'^create_graph/$', views.create_graph, name='create_graph'),
                       url(r'^load_graph/$', views.load_graph, name='load_graph'),
                       url(r'^djangojs/', include('djangojs.urls')),
                       url(r'^assign_model_node/$', views.assign_model_node, name='assign_model_node'),
                       url(r'^assign_model_graph/$', views.assign_model_graph, name='assign_graph'),
                       url(r'^add_model/$', views.add_model, name='add_model'),
                       url(r'^user_model_info/(?P<username>[a-zA-Z0-9_]+)/$', views.user_model_info, name='user_model_info'),
                       url(r'^assign_user_model/$', views.assign_user_model,
                           name='assign_user_model'),
                       url(r'^assign_model_flow/$', views.assign_model_flow,
                           name='assign_model_flow'),
                       url(r'^get_edge_cost/(?P<edge_id>[a-zA-Z0-9_\-]+)/$', views.get_edge_cost,
                           name='get_edge_cost'),
                       url(r'^assign_edge_cost/$', views.assign_edge_cost,
                           name='assign_edge_cost'),
                       url(r'^assign_all_edge_cost/$', views.assign_all_edge_cost,
                           name='assign_all_edge_cost'),
                       url(r'^user_info/(?P<username>[a-zA-Z0-9_]+)$', views.get_user_info,
                           name='get_user_info'),
                       url(r'current_state/', views.current_state, name='current_state'),
                       url(r'^submit_distribution/', views.submit_distribution,
                           name='submit_distribution'),
                       url(r'^get_paths/(?P<username>[a-zA-Z0-9_]+)/$',
                           views.get_paths, name='get_paths'),
                       url(r'^get_previous_cost/(?P<username>[a-zA-Z0-9_]+)/$',
                           views.get_previous_cost, name='get_previous_cost'),
                       url(r'^get_user_costs/(?P<graph_name>[a-zA-Z0-9_]+)/$',
                           views.get_user_costs, name='get_user_costs'),
                       url(r'^start_game/$', views.start_game, name='start_game'),
                       url(r'^stop_game/$', views.stop_game, name='stop_game'),
                       url(r'^stop_edge_highlight/$', views.stop_edge_highlight,
                           name='stop_edge_highlight'),
                       url(r'^start_edge_highlight/$', views.start_edge_highlight,
                           name='start_edge_highlight'),
                       url(r'^save_data/$', views.save_data,
                           name='save_data'),
                       url(r'^assign_duration/$', views.assign_duration,
                           name='assign_duration'),
                       url(r'^set_game_mode/$', views.set_game_mode,
                           name='set_game_mode'),
                       # url(r'^get_duration/$', view.get_duration, name='get_duration'),
)
