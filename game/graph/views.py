from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect, JsonResponse
from django.template import RequestContext, loader
from django.template.loader import render_to_string

from django.core.paginator import Paginator, PageNotAnInteger, EmptyPage
from django.db.models.fields.files import FieldFile
from django.views.generic import FormView
from django.views.generic.base import TemplateView
from django.contrib import messages

from django.core.files import File

from utils import generate_graph, sanitize_graph_json, generate_paths, root_username
from models import Graph, Node, Edge, Player, PlayerModel

from django.contrib.auth import authenticate, login
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.decorators import login_required

from django.contrib.auth.models import User

import simplejson as json


def create_account(request):
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            new_user = form.save()
            pm = PlayerModel.objects.filter(in_use=False)[:1].get()

            pm.in_use = True
            player = Player()
            player.user = new_user
            player.player_model = pm

            pm.save()
            player.save()

            return HttpResponseRedirect("/graph/index")
    else:
        form = UserCreationForm()
    return render(request, "graph/register.djhtml", {
        'form': form,
    })


def index(request):
    if request.user.is_authenticated():
        return HttpResponseRedirect("/graph/accounts/profile")
    else:
        return HttpResponseRedirect("/graph/accounts/login")


@login_required
def show_graph(request):
    template = 'graph/root.djhtml'

    context = dict()

    if request.user.username != root_username:
        template = 'graph/user.djhtml'
        user = User.objects.get(username=request.user.username)
        context['graph'] = user.player.player_model.graph.name
        context['username'] = user.username
    else:
        graphs = map(lambda g: g.name, Graph.objects.all())
        context['usernames'] = User.objects.values_list('username', flat=True)
        context['model_names'] = PlayerModel.objects.values_list('name', flat=True)
        context['graph_names'] = graphs

    return render(request, template, context)


@login_required
def editor(request):
    template = 'graph/editor.djhtml'
    context = dict()
    return render(request, template, context)


@login_required
def create_graph(request):
    graph_dict = json.loads(request.body)
    generate_graph(graph_dict)
    to_json = dict()
    return JsonResponse(to_json)


@login_required
def load_graph(request):
    g_name = request.GET.dict()['name']
    graph = Graph.objects.get(name=g_name)
    response = dict()
    response['graph_ui'] = json.dumps(sanitize_graph_json(json.loads(graph.graph_ui)))
    last_node_id = None
    for node in json.loads(graph.graph_ui)['nodes']:
        last_node_id = max(node['id'], last_node_id)
    response['last_node_id'] = last_node_id
    return JsonResponse(response)


@login_required
def get_model_info(request, modelname):
    player_model = PlayerModel.objects.get(name=modelname)
    model_dict = dict()
    model_dict['name'] = modelname
    if player_model.start_node and player_model.destination_node and player_model.graph:
        model_dict['start'] = player_model.start_node.ui_id
        model_dict['destination'] = player_model.destination_node.ui_id
        model_dict['graph_name'] = player_model.graph.name
        model_dict['flow'] = player_model.flow

        # import ipdb; ipdb.set_trace()


    html = render_to_string('graph/model_info.djhtml', model_dict)

    response = dict()
    response['html'] = html
    return JsonResponse(response)


# Need source and destination to generate possible paths.
def generate_all_paths(request):
    get_dict = request.GET.dict()
    paths = generate_paths(get_dict['graph'], int(get_dict['source']),
                           int(get_dict['destination']))
    path_idxs = range(len(paths))
    html_dict = {'path_idxs': path_idxs}
    html = render_to_string('graph/path_display_list.djhtml', html_dict)
    response = dict()
    response['html'] = html
    response['paths'] = paths
    return JsonResponse(response)


@login_required
def assign_model_node(request):
    data = json.loads(request.body)
    return save_model_node(request, data['model_name'], data['graph_name'],
                          data['node_ui_id'], data['is_start'])


@login_required
def assign_model_graph(request):
    data = json.loads(request.body)
    graph = Graph.objects.get(name=data['graph_name'])
    player_model = PlayerModel.objects.get(name=data['model_name'])

    player_model.graph = graph
    player_model.save()

    response = dict()
    response['graph_name'] = data['graph_name']
    return JsonResponse(response)


@login_required
def add_model(request):
    data = json.loads(request.body)

    player_model = PlayerModel(name=data['model_name'])
    player_model.save()

    response = dict()
    return JsonResponse(response)


def save_model_node(request, model_name, graph_name, node_ui_id, is_start):
    player_model = PlayerModel.objects.get(name=model_name)
    node = Node.objects.get(graph__name=graph_name, ui_id=node_ui_id)

    if is_start:
        player_model.start_node = node
    else:
        player_model.destination_node = node

    player_model.save()

    response = dict()
    response['node_ui_id'] = node_ui_id
    return JsonResponse(response)


@login_required
def user_model_info(request, username):
    user = User.objects.get(username=username)

    user_dict = dict()
    user_dict['player_username'] = username
    if hasattr(user, 'player'):
        user_dict['player_modelname'] = user.player.player_model.name

    html = render_to_string('graph/player_assigned_model_info.djhtml', user_dict)
    response = dict()
    response['html'] = html
    return JsonResponse(response)


@login_required
def assign_user_model(request):
    data = json.loads(request.body)
    user = User.objects.get(username=data['username'])
    model = PlayerModel.objects.get(name=data['modelname'])

    if hasattr(user, 'player'):
        user.player.player_model.in_use = False
        user.player.player_model.save()
        user.player.delete()

    player = Player()
    player.user = user
    player.player_model = model

    model.in_use = True

    model.save()
    player.save()
    user.save()

    response = dict()
    return JsonResponse(response)


@login_required
def assign_model_flow(request):
    data = json.loads(request.body)
    model = PlayerModel.objects.get(name=data['modelname'])
    flow = float(data['flow'])

    model.flow = flow
    model.save()

    response = dict()
    return JsonResponse(response)


@login_required
def get_edge_cost(request, edge_id):
    edge = Edge.objects.get(edge_id=edge_id)

    response = dict()
    response['cost'] = edge.cost_function
    response['from_node'] = edge.from_node.ui_id
    response['to_node'] = edge.to_node.ui_id

    return JsonResponse(response)


@login_required
def assign_edge_cost(request):
    data = json.loads(request.body)

    edge = Edge.objects.get(edge_id=data['edge_id'])
    edge.cost_function = data['cost']
    edge.save()

    response = dict()
    return JsonResponse(response)


@login_required
def assign_all_edge_cost(request):
    data = json.loads(request.body)

    for edge in Edge.objects.filter(graph__name=data['graph']):
        edge.cost_function = data['cost']
        edge.save()

    response = dict()
    return JsonResponse(response)


def get_user_info(request, username):
    user = User.objects.get(username=username)

    response = dict()
    response['graph'] = user.player.player_model.graph.name

    return JsonResponse(response)
