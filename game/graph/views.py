from datetime import datetime

from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect, JsonResponse
from django.template import RequestContext, loader
from django.template.loader import render_to_string

from django.core.paginator import Paginator, PageNotAnInteger, EmptyPage
from django.db.models.fields.files import FieldFile
from django.db.models import Q
from django.views.generic import FormView
from django.views.generic.base import TemplateView
from django.contrib import messages

from django.core.files import File

from utils import *
from models import *
from tasks import *
from game_functions import *

from django.contrib.auth import authenticate, login
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.decorators import login_required

from django.contrib.auth.models import User

from django.core.cache import cache

import simplejson as json


current_game = 'game'

def create_account(request):

    if not Game.objects.filter(name=current_game).exists():
        game = Game(name=current_game)
        game.save()

    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            new_user = form.save()
            game = Game.objects.get(name=current_game)

            if create_new_player(new_user, game):
                return HttpResponseRedirect('/graph/index')
            else:
                pass
                # TODO: Return empty page here
                # template = 'graph/user_wait.djhtml'
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

        try:
            player_model = user.player.player_model
            context['graph'] = player_model.graph.name
            context['username'] = user.username
            context['start'] = player_model.start_node.ui_id
            context['destination'] = player_model.destination_node.ui_id
            context['flow'] = player_model.flow
        except:
            template = 'graph/user_wait.djhtml'
    else:
        # if not Game.objects.filter(name=current_game).exists():
       #     game = Game(name=current_game)
        #     game.save()

        graphs = map(lambda g: g.name, Graph.objects.all())
        context['usernames'] = User.objects.values_list('username', flat=True)
        context['model_names'] = PlayerModel.objects.values_list('name', flat=True)
        context['graph_names'] = graphs

    context['hidden'] = 'hidden'

    g = Game.objects.all()[0]

    # if not g.started:
    #     template = 'graph/user_wait.djhtml'

    try:
        if len(PlayerModel.objects.filter(in_use=False, graph__isnull=False).all()) == 0:
            context['hidden'] = ''
    except:
        pass

    return render(request, template, context)


@login_required
def editor(request):
    template = 'graph/editor.djhtml'
    context = dict()
    return render(request, template, context)


@login_required
def create_graph(request):
    graph_dict = json.loads(request.body)
    graph = generate_and_save_graph(graph_dict)

    game = Game.objects.get(name=current_game)

    initial_turn = GameTurn()
    initial_turn.iteration = 0
    initial_turn.save()
    game.current_turn = initial_turn
    game.graph = graph
    game.save()

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

    html = render_to_string('graph/model_info.djhtml', model_dict)

    response = dict()
    response['html'] = html
    return JsonResponse(response)


# Need source and destination to generate possible paths.
# @login_required
# def generate_all_paths(request):
#     get_dict = request.GET.dict()
#     paths = generate_paths(get_dict['graph'], int(get_dict['source']),
#                            int(get_dict['destination']))
#     path_idxs = range(len(paths))
#     html_dict = {'path_idxs': path_idxs}
#     html = render_to_string('graph/path_display_list.djhtml', html_dict)
#     response = dict()
#     response['html'] = html
#     response['paths'] = paths
#     return JsonResponse(response)


@login_required
def get_user_costs(request, graph_name):
    game = Game.objects.get(graph__name=graph_name)
    players = Player.objects.filter(game=game)

    current_costs = dict()
    cumulative_costs = dict()

    for player in players:
        if player.user.username == root_username:
            continue

        username = player.user.username
        paths = Path.objects.filter(player_model=player.player_model)
        # path_assignments = player.flow_distribution.path_assignments
        cumulative_cost = 0
        normalization_const = player.player_model.normalization_const
        for turn in game.turns.all().order_by('iteration'):
            # if turn.iteration == 0:
            #     continue

            path_assignments = FlowDistribution.objects.get(turn=turn, username=username).path_assignments
            # path_assignments = turn.flow_distributions.get(username=username).path_assignments
            e_costs = turn.graph_cost.edge_costs
            current_cost = 0
            if player.user.username not in current_costs:
                current_costs[player.user.username] = []
                cumulative_costs[player.user.username] = []

            for path in paths:
                flow = path_assignments.get(path=path).flow
                current_path_cost = 0
                for e in path.edges.all():
                    current_path_cost += e_costs.get(edge=e).cost
                current_cost += (current_path_cost) * flow

            cumulative_cost += current_cost
            current_costs[player.user.username].append(current_cost/normalization_const)
            cumulative_costs[player.user.username].append(cumulative_cost/normalization_const)

    response = dict()
    response['started'] = game.started
    response['current_costs'] = current_costs
    response['cumulative_costs'] =  cumulative_costs
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
    response = dict()

    if PlayerModel.objects.filter(name=data['model_name']).count() > 0:
        response['success'] = False
    else:
        player_model = PlayerModel(name=data['model_name'])
        player_model.in_use = False
        player_model.save()
        response['success'] = True

    return JsonResponse(response)


def get_previous_cost(request, username):
    user = User.objects.get(username=username)
    game = user.player.game
    current_turn = game.current_turn
    player = Player.objects.get(user__username=username)
    path_ids = list(Path.objects.filter(player_model=player.player_model).values_list('id', flat=True))
    path_idxs = range(len(path_ids))
    paths = dict()

    flow = []
    previous_cost = []
    previous_turn = None
    cumulative_costs = []
    previous_costs = dict()

    if current_turn.iteration > 0:
        previous_turn = game.turns.get(iteration=current_turn.iteration - 1)

    for idx, p_id in zip(path_idxs, path_ids):
        path = Path.objects.get(id=p_id)
        paths[idx] = list(path.edges.values_list('edge_id', flat=True))
        if FlowDistribution.objects.filter(username=username, turn=current_turn).exists():
        # if current_turn.flow_distributions.filter(username=username).exists():
            fd = FlowDistribution.objects.get(turn=current_turn, username=username)
            # fd = current_turn.flow_distributions.get(username=username)
            flow.append(fd.path_assignments.get(path__id=p_id).flow)
        else:
            flow.append(0.5)

        if current_turn.iteration > 0:
            edge_costs = previous_turn.graph_cost.edge_costs
            total_cost = 0
            for e in path.edges.all():
                total_cost += edge_costs.get(edge=e).cost
            previous_cost.append(total_cost)

            cumulative_cost = 0
            for turn in game.turns.all():
                e_costs = turn.graph_cost.edge_costs
                t_cost = 0
                for e in path.edges.all():
                    t_cost += e_costs.get(edge=e).cost
                if idx not in previous_costs:
                    previous_costs[idx] = []
                previous_costs[idx].append(t_cost)
                cumulative_cost += total_cost

            cumulative_costs.append(cumulative_cost)
        else:
            previous_cost.append(0)
            cumulative_costs.append(0)

    response = dict()

    response['path_ids'] = path_ids
    response['paths'] = paths
    response['previous_costs'] = previous_costs
    return JsonResponse(response)


def get_paths(request, username):
    user = User.objects.get(username=username)
    game = user.player.game
    current_turn = game.current_turn
    player = Player.objects.get(user__username=username)
    path_ids = list(Path.objects.filter(player_model=player.player_model).values_list('id', flat=True))
    path_idxs = range(len(path_ids))
    paths = dict()

    previous_cost = []
    previous_turn = None
    cumulative_costs = []
    flow = []

    prev_alloc, prev_path_ids = None, None

    if current_turn.iteration > 0:
        previous_turn = game.turns.get(iteration=current_turn.iteration - 1)

    # TODO: Fix the cache key scheme
    if cache.get(get_hash(user.username) + 'path_ids'):
        prev_alloc = cache.get(get_hash(user.username) + 'alloc')
        prev_path_ids = cache.get(get_hash(user.username) + 'path_ids')


    for idx, p_id in zip(path_idxs, path_ids):
        path = Path.objects.get(id=p_id)
        paths[idx] = list(path.edges.values_list('edge_id', flat=True))

        # if FlowDistribution.objects.filter(username=username, turn=current_turn).exists():
        # # if current_turn.flow_distributions.filter(username=username).exists():
        #     fd = FlowDistribution.objects.get(turn=current_turn, username=username)
        #     # fd = current_turn.flow_distributions.get(username=username)
        #     flow.append(fd.path_assignments.get(path__id=p_id).flow)
        # else:
        #     flow.append(0.5)

        if prev_alloc:
            flow.append(prev_alloc[prev_path_ids.index(p_id)])
        else:
            print 'failing!!!!!!!'
            flow.append(0.5)

        if current_turn.iteration > 0:
            edge_costs = previous_turn.graph_cost.edge_costs
            total_cost = 0
            for e in path.edges.all():
                total_cost += edge_costs.get(edge=e).cost
            previous_cost.append(total_cost)

            cumulative_cost = 0
            for turn in game.turns.all():
                e_costs = turn.graph_cost.edge_costs
                path_cost = 0
                for e in path.edges.all():
                    path_cost += e_costs.get(edge=e).cost
                cumulative_cost += path_cost

            cumulative_costs.append(cumulative_cost)
        else:
            previous_cost.append(0)
            cumulative_costs.append(0)


    flow = map(lambda x: x * 100, flow)

    html_dict = {'path_idxs': zip(path_idxs, path_ids, flow, previous_cost,
                                  cumulative_costs)}
    html = render_to_string('graph/path_display_list.djhtml', html_dict)

    response = dict()

    response['html'] = html
    response['path_ids'] = path_ids
    response['paths'] = paths
    return JsonResponse(response)


def save_model_node(request, model_name, graph_name, node_ui_id, is_start):
    player_model = PlayerModel.objects.get(name=model_name)
    node = Node.objects.get(graph__name=graph_name, ui_id=node_ui_id)

    if is_start:
        player_model.start_node = node
    else:
        player_model.destination_node = node

    player_model.save()

    if player_model.start_node and player_model.destination_node:
        graph = Graph.objects.get(name=graph_name)
        generate_paths(graph, player_model.start_node,
                       player_model.destination_node, player_model)
        # generate_paths(get_dict['graph'], int(get_dict['source']),
        #                    int(get_dict['destination']))

        if player_model.flow:
            updateEquilibriumFlows(graph_name)


    response = dict()
    response['node_ui_id'] = node_ui_id
    return JsonResponse(response)


@login_required
def user_model_info(request, username):
    user = User.objects.get(username=username)

    user_dict = dict()
    user_dict['player_username'] = username

    try:
        if hasattr(user, 'player') and hasattr(user.player, 'player_model'):
            user_dict['player_modelname'] = user.player.player_model.name
    except:
        pass

    html = render_to_string('graph/player_assigned_model_info.djhtml', user_dict)
    response = dict()
    response['html'] = html
    return JsonResponse(response)


@login_required
def assign_user_model(request):
    data = json.loads(request.body)
    user = User.objects.get(username=data['username'])
    model = PlayerModel.objects.get(name=data['modelname'])

    try:
        if hasattr(user, 'player'):
            user.player.player_model.in_use = False
            user.player.player_model.save()
            user.player.delete()
    except:
        pass

    player = user.player
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


# TODO: Remove all the saves that aren't needed!
@login_required
def submit_distribution(request):
    data = json.loads(request.body)
    user = User.objects.get(username=data['username'])
    player = Player.objects.get(user__username=data['username'])
    allocation = data['allocation']
    path_ids = data['ids']
    temporary = data['temporary']

    response = dict()
    game = player.game

    if not game.started:
        return JsonResponse(response)

    update_game(user, allocation, path_ids, temporary)

    cache.set(get_hash(user.username) + 'alloc', allocation)
    cache.set(get_hash(user.username) + 'path_ids', path_ids)

    if is_turn_complete(game) and not temporary:
        iterate_next_turn(game)
        if async_res:
            async_res.revoke()

        game.game_loop_time = datetime.now()
        game.save()

    return JsonResponse(response)


@login_required
def current_state(request):
    game = Game.objects.all()[0]

    update_game_state(game)

    response = dict()
    response['iteration'] = game.current_turn.iteration

    response['secs'] = duration

    if cache.get('time_left'):
        response['secs'] = cache.get('time_left')

    return JsonResponse(response)


def start_game(request):
    # TODO: Fix this, let game be addressable in root UI
    game = Game.objects.get(name=current_game)
    # game = Game.objects.all()[0]
    game.started = True
    game.game_loop_time = datetime.now()
    game.stopped = False

    game.save()

    async_res = game_force_next.apply_async((game.name,), countdown=duration)

    return JsonResponse(dict())


def stop_game(request):
    game = Game.objects.all()[0]
    game.stopped = True
    game.save()

    response = dict()

    if async_res:
        async_res.revoke()

    response['success'] = True

    return JsonResponse(response)
