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

from django.core.urlresolvers import reverse
from django.shortcuts import redirect

from django.core.files import File
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.csrf import ensure_csrf_cookie


from utils import *
from models import *
from tasks import *
from game_functions import *
from ai import *
from pm_pool import *
import requests
from django import forms

from django.contrib.auth import authenticate, login
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.decorators import login_required
from django.utils.translation import ugettext, ugettext_lazy as _
from django.views.decorators.clickjacking import xframe_options_exempt

from django.contrib.auth.models import User

from django.core.cache import cache
from ai import *

import simplejson as json


from django.core import management
from cStringIO import StringIO

import random
import math

import logging
logger = logging.getLogger(__name__)


epsilon = 1E-10
current_game_stopped = False
current_game_started = False
waiting_time = 10
cache.set('waiting_time',waiting_time)
cache.set('current_game_stopped ',False)
cache.set('end_game',False)
use_intermediate_room = False
use_end_template = False
AMAZON_HOST = "https://workersandbox.mturk.com/mturk/externalSubmit"



class CustomUserForm(UserCreationForm):
     error_messages = {
        'duplicate_username': _("A user with that username already exists."),
        'password_mismatch': _("The two password fields didn't match."),
        }
     username = forms.RegexField(label=_("Username"), max_length=30,
        regex=r'^[\w.@+]+$',
        help_text=_("Required. 30 characters or fewer. Letters, digits and "
                    "@/./+/_ only."),
        error_messages={
            'invalid': _("This value may contain only letters, numbers and "
                         "@/./+/_ characters.")})
     password1 = forms.CharField(label=_("Password"),
        widget=forms.PasswordInput)
     password2 = forms.CharField(label=_("Password confirmation"),
        widget=forms.PasswordInput,
        help_text=_("Enter the same password as above, for verification."))
     class Meta:
        model = User
        fields = ("username",)

     def clean_username(self):
        # Since User.username is unique, this check is redundant,
        # but it sets a nicer error message than the ORM. See #13147.
        username = self.cleaned_data["username"]
        try:
            User._default_manager.get(username=username)
        except User.DoesNotExist:
            return username
        raise forms.ValidationError(
            self.error_messages['duplicate_username'],
            code='duplicate_username',
        )
     def clean_password2(self):
        password1 = self.cleaned_data.get("password1")
        password2 = self.cleaned_data.get("password2")
        if password1 and password2 and password1 != password2:
            raise forms.ValidationError(
                self.error_messages['password_mismatch'],
                code='password_mismatch',
            )
        return password2

     def save(self, commit=True):
        user = super(UserCreationForm, self).save(commit=False)
        user.set_password(self.cleaned_data["password1"])
        if commit:
            user.save()
        return user


def KL(x, y):
    return sum([x_i*np.log(x_i/y_i) for x_i, y_i in zip(x, y) if x_i > 0])


class SimplexProjectionExpSort():
    def __init__(self, epsilon = 0):
        self.epsilon = epsilon
    def __str__(self):
        return 'SimplexExpSort{}'.format(self.epsilon)

    def project(self, x, g, eta):
        """Computes the Bregman projection, with exponential potential, of a vector x given a gradient vector g, using a
        sorting method. The complexity of this method is O(d log d), where d is the size of x.
        Takes as input
        - the current iterate x
        - the gradient vector (scaled by the step size) g
        -- This is l_i(t)*eta
        """
        epsilon = self.epsilon
        d = len(x)
        y = (x+epsilon)*np.exp(-g*eta)
        yy = sorted(y)
        S = sum(yy)
        j = 0
        while((1+epsilon*(d-j))*yy[j]/S - epsilon <= 0):
            S -= yy[j]
            j += 1
        return np.maximum(0, -epsilon+(1+epsilon*(d-j))*y/S)


def dump_data_fixture(filename):
    buf = StringIO()
    management.call_command('dumpdata', stdout=buf)
    buf.seek(0)
    with open(filename, 'w') as f:
        f.write(buf.read())


current_game = 'game'



def create_account(request):
    if not Game.objects.filter(name=current_game).exists():
        game = Game(name=current_game)
        game.currently_in_use = True
        game.save()

    if request.method == 'POST':
        form = CustomUserForm(request.POST)
        logger.debug(form)

        if form.is_valid():
            new_user = form.save()
            game = Game.objects.get(name=current_game)

            if create_new_player(new_user, game, 'superuser' in request.POST.dict()):
                return HttpResponseRedirect('/graph/index')
            else:
                pass
                # TODO: Return empty page here
                # template = 'graph/user_wait.djhtml'
    else:
        form = CustomUserForm()

    return render(request, "graph/register.djhtml", {
        'form': form,
    })


def create_new_game(request):
    response = dict()
    return JsonResponse(response)


def index(request):
    if request.user.is_authenticated():

        # redir = redirect("/graph/accounts/profile/")
        # redir['game'] = current_game
        # return redir
        # url = reverse('show_graph', kwargs={'game': current_game})
        # return HttpResponseRedirect(url)

        return HttpResponseRedirect("/graph/accounts/profile/")

    else:
        return HttpResponseRedirect("/graph/accounts/login")


@login_required

def show_graph(request):
    template = 'graph/root.djhtml'

    context = dict()

    initiate_first_game()
    g = Game.objects.get(currently_in_use= True)


    if 'game' in request.GET:
        g = Game.objects.get_or_create(currently_in_use=True)[0]
        initiate_first_game()


    user = User.objects.get(username=request.user.username)
    connected_users = len(Player.objects.filter(is_a_bot = False))-1
    if not user.player.superuser:
        template = 'graph/user.djhtml'
        if not(g.started) or no_more_games_left():
            return HttpResponseRedirect ("/graph/waiting_room/")
        try:
            g = user.player.game
            player_model = user.player.player_model
            context['graph'] = player_model.graph.name
            context['username'] = user.username
            context['start'] = player_model.start_node.ui_id
            context['destination'] = player_model.destination_node.ui_id
            context['flow'] = player_model.flow
            context['is_bot'] =user.player.is_a_bot
        except:
            template = 'graph/user_wait.djhtml'
    else:
        #graphs = [g.graph] if g.graph else []
        # graphs = map(lambda g: g.name, Graph.objects.all())
        context['usernames'] = Player.objects.filter(superuser=False).values_list('user__username', flat=True)
        # context['usernames'] = User.objects.values_list('username', flat=True)
        #try:
           # context['model_names'] = PlayerModel.objects.filter(graph__name=g.graph.name)
        #except:
        context['model_names'] = PlayerModel.objects.all()
        context['graph_names'] = Graph.objects.all()
        context['games'] = Game.objects.all()
        context['connected'] = connected_users



    # context['hidden'] = 'hidden'
    context['hidden'] = ''
    context['game_name'] = g.name

    # if not g.started:
    #     template = 'graph/user_wait.djhtml'

    try:
        if len(PlayerModel.objects.filter(in_use=False, graph__isnull=False).all()) == 0:
            context['hidden'] = ''
    except:
        pass

    context['single_slider_mode'] = 'checked' if g.single_slider_mode else 'unchecked'

    context['game_mode'] = 'single_slider_mode' if g.single_slider_mode else 'normal_mode'
    context['duration'] =g.duration

    return render(request, template, context)


@login_required
def editor(request):
    template = 'graph/editor.djhtml'
    context = dict()
    return render(request, template, context)


@login_required
def create_graph(request):
    request_dict = json.loads(request.body)
    graph = generate_and_save_graph(request_dict)

    game = Game.objects.get(name=request_dict['game'])

    initial_turn = GameTurn()
    initial_turn.game = game
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
    if player_model.start_node:
        model_dict['start'] = player_model.start_node.ui_id
    if player_model.destination_node:
        model_dict['destination'] = player_model.destination_node.ui_id
    if player_model.graph:
        model_dict['graph_name'] = player_model.graph.name
    if player_model.flow:
        model_dict['flow'] = player_model.flow

    html = render_to_string('graph/model_info.djhtml', model_dict)

    response = dict()
    response['html'] = html
    return JsonResponse(response)


def get_bar_values(game, player, turn_iteration):
    path_ids = list(Path.objects.filter(player_model=player.player_model).values_list('id', flat=True))

    turn = GameTurn.objects.get(game=game, iteration=turn_iteration)
    next_turn = GameTurn.objects.get(game=game, iteration=turn_iteration+1)

    fd = FlowDistribution.objects.get(player=player, turn=turn)
    fd_next = FlowDistribution.objects.get(player=player, turn=next_turn)

    e_costs = turn.graph_cost.edge_costs

    current_flows = np.array([])
    current_costs = np.array([])
    next_flows = np.array([])

    for p_id in path_ids:
        path = Path.objects.get(id=p_id)

        flow = fd.path_assignments.get(path=path).flow
        current_flows = np.append(current_flows, flow)

        # current_flows = sanitize_flows(current_flows)

        next_flows = np.append(next_flows, fd_next.path_assignments.get(path=path).flow)

        # next_flows = sanitize_flows(next_flows)

        path_cost = 0
        for e in path.edges.all():
            path_cost += e_costs.get(edge=e).cost

        current_costs = np.append(current_costs, path_cost)

    return current_flows, current_costs, next_flows


def estimate_best_eta_for_turn(game, player, turn_iteration):
    eta_grid = np.logspace(-3, 1.0, 4000)
    # eta_grid = np.linspace(-10, 10, 400)
    spe = SimplexProjectionExpSort(epsilon)


    current_flows  , current_costs, next_flows = get_bar_values(game, player, turn_iteration)
    @np.vectorize
    def calculate_divergence(eta):
        x_predicted = spe.project(current_flows, current_costs, eta)
        return KL(next_flows + epsilon, x_predicted + epsilon)

    kl_grid = calculate_divergence(eta_grid)
    return eta_grid[np.argmin(kl_grid)]


def estimate_best_eta_all_turns(game, player):
    # Don't hard-code this in the future
    # start = 1
    # stop = 28

    best_etas = []

    for turn in GameTurn.objects.filter(game=game):
        if LearningRate.objects.filter(player=player, turn=turn).exists():
            lr = LearningRate.objects.get(player=player, turn=turn)
            best_etas.append(lr.learning_rate)
        else:
            try:
                best_eta = estimate_best_eta_for_turn(game, player, turn.iteration)
                best_etas.append(best_eta)

                lr = LearningRate(player=player, turn=turn)
                lr.learning_rate = best_eta
                #logger.debug('Saving learning rate for %s' % str(player))
                lr.save()
            except:
                pass

    return map(math.log10, best_etas)


def predict_user_flows_all_turns(game, player):
    predictions = dict()
    actual = dict()
    number_of_pm = Player.objects.filter(player_model = player.player_model).count()
    path_ids = list(Path.objects.filter(player_model=player.player_model).values_list('id', flat=True))

    for p_id in path_ids:
        predictions[p_id] = []
        actual['actual_%s' % str(p_id)] = []

    counter = 1

    predictions['x'] = []

    for prev_turn, curr_turn in zip(GameTurn.objects.filter(game=game),
                                    GameTurn.objects.filter(game=game)[1:]):
        counter += 1
        try:
            learning_rate = LearningRate.objects.get(player=player, turn=prev_turn).learning_rate
            current_flows, current_costs, actual_flows = get_bar_values(game, player, curr_turn.iteration)

            spe = SimplexProjectionExpSort(epsilon)
            x_predicted = spe.project(current_flows, current_costs, learning_rate)

            i = 0
            for p_id, prediction, actual_flow in zip(path_ids, x_predicted, actual_flows):
                predictions[p_id].append(prediction/number_of_pm)
                actual['actual_%s' % str(p_id)].append(actual_flow)
                i += 1

            predictions['x'].append(counter)
        except Exception as e:
            logger.error(e)

    return predictions, actual


  
@login_required
def get_user_predictions(request, username):

    game = Game.objects.get(currently_in_use=True)
    player = Player.objects.get(user__username=username)
    flow_predictions, actual_flows = predict_user_flows_all_turns(game, player)
    response = dict()
    response['predictions'] = flow_predictions
    response['actual'] = actual_flows
    return JsonResponse(response)


  
@login_required
def get_user_costs(request, graph_name):
    if not Game.objects.filter(graph__name=graph_name).count():
        return JsonResponse({'started': False})

    game = Game.objects.get(graph__name=graph_name)

    #game = Game.objects.get(currently_in_use = True)
    if not game.started:
        return JsonResponse({'started': game.started})
    #for user in User.objects.all():
        ##player.game =game
        #player.save()
    players = Player.objects.filter(game=game,superuser=False)

    current_costs = dict()
    cumulative_costs = dict()
    user_etas = dict()
    logger.debug(str(players)+" smells like teen spirit")

    for player in players:

        username = player.user.username
        paths = Path.objects.filter(player_model=player.player_model)

        # path_assignments = player.flow_distribution.path_assignments
        number_of_PM = len(Player.objects.filter(player_model = player.player_model))
        cumulative_cost = 0
        #TODO fix normilzation const
        #
        normalization_const = player.player_model.normalization_const
        #normalization_const = 2.5
        logger.debug("#################")
        for turn in game.turns.all().order_by('iteration'):
            #if turn.iteration == 0 and player.is_a_bot:


            path_assignments = FlowDistribution.objects.get(turn=turn,player=player).path_assignments


            # path_assignments = turn.flow_distributions.get(username=username).path_assignments
            e_costs = turn.graph_cost.edge_costs
            current_cost = 0
            if player.user.username not in current_costs:
                current_costs[player.user.username] = []
                cumulative_costs[player.user.username] = []

            for path in paths:
                #TODO fix request
                try:
                    flow = path_assignments.get(path=path).flow
                except:
                    flow = player.player_model.flow/len(paths)
                current_path_cost = 0
                for e in path.edges.all():
                    current_path_cost += e_costs.get(edge=e).cost
                current_cost += (current_path_cost) * flow

            cumulative_cost += current_cost
            current_costs[player.user.username].append(current_cost/normalization_const*number_of_PM)
            cumulative_costs[player.user.username].append(cumulative_cost/normalization_const*number_of_PM)

        etas = estimate_best_eta_all_turns(game, player)
        logger.debug("#################")
        #logger.debug(etas)
        user_etas[player.user.username] = etas

    user_etas['x'] = list(range(1, len(user_etas[user_etas.keys()[0]]) + 1))

    response = dict()
    response['started'] = game.started
    response['current_costs'] = current_costs
    response['cumulative_costs'] =  cumulative_costs
    response['user_etas'] = user_etas
    return JsonResponse(response)


  
@login_required
def assign_game(request):
    data = json.loads(request.body)

    logger.debug('Data:' + str(data))

    game = Game.objects.get(name=data['game'])
    user = User.objects.get(username=data['username'])
    user.player.game = game
    user.save()
    user.player.save()

    return JsonResponse(dict())


  
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
def assign_game_graph(request):
    data = json.loads(request.body)
    graph = Graph.objects.get(name=data['graph_name'])
    game = Game.objects.get(name=data['game_name'])

    game.graph = graph
    initial_turn = GameTurn()
    initial_turn.game = game
    initial_turn.iteration = 0
    initial_turn.save()
    game.current_turn = initial_turn
    game.save()

    response = dict()
    response['graph_name'] = game.graph.name
    response['game_name'] = game.name

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
        if data['graph_name']:
            player_model.graph = Graph.objects.get(name=data['graph_name'])

        player_model.save()
        response['success'] = True

    return JsonResponse(response)

  
@login_required
def generate_pm(request):
    data  = json.loads(request.body)
    graph_name = data['graph']
    generate_player_model(graph_name)
    return JsonResponse(dict())


  
@login_required
def add_game(request):
    data = json.loads(request.body)
    response = dict()

    if Game.objects.filter(name=data['game_name']).count() > 0:
        response['success'] = False
    else:
        game = Game(name=data['game_name'])
        game.save()
        response['success'] = True

    return JsonResponse(response)


  
@login_required
def get_previous_cost(request, username):
    user = User.objects.get(username=username)
    game = user.player.game
    iteration = int(request.GET.dict()['iteration'])
    player = Player.objects.get(user__username=username)
    path_ids = list(Path.objects.filter(player_model=player.player_model).values_list('id', flat=True))
    path_idxs = range(len(path_ids))

    paths = dict()

    previous_flows = dict()
    previous_costs = dict()


    for idx, p_id in zip(path_idxs, path_ids):
        path = Path.objects.get(id=p_id)
        paths[idx] = list(path.edges.values_list('edge_id', flat=True))

        # for turn in game.turns.all():
        for turn in game.turns.filter(iteration__gte=iteration-1):
            # cache_key_t_cost = str(turn.iteration) + game.name + "get_previous_cost" + username + "t_cost"
            # cache_key_flow_ = str(turn.iteration) + game.name + "get_previous_cost" + username + "flow"
            # if cache.get(cache_key_t_cost):
            e_costs = turn.graph_cost.edge_costs
            t_cost = 0
            flow_distribution = FlowDistribution.objects.get(turn=turn, player=player)
            flow = flow_distribution.path_assignments.get(path=path).flow
            for e in path.edges.all():
                t_cost += e_costs.get(edge=e).cost
            if idx not in previous_costs:
                previous_costs[idx] = []
            previous_costs[idx].append(t_cost)
            if idx not in previous_flows:
                previous_flows[idx] = []
            previous_flows[idx].append(flow)

    response = dict()
    response['number_pm'] = Player.objects.filter(player_model= player.player_model).count()
    response['path_ids'] = path_ids
    response['paths'] = paths
    response['previous_costs'] = previous_costs
    response['previous_flows'] = previous_flows
    return JsonResponse(response)


  
def get_user_graph_cost(request,username,graph_name):
    user = User.objects.get(username=username)
    game = Game.objects.get(graph__name=graph_name)
    iteration =  0
    used_pms = PlayerModel.objects.filter(graph__name=graph_name)
    user_with_same_pm = 0


    for used_pm in used_pms:
        if username in used_pm.historic_player:
            pm_to_use = used_pm
    for us in User.objects.all():
        pl = Player.objects.get(user=us)
        if pl.user.username in pm_to_use.historic_player:
            user_with_same_pm=user_with_same_pm+1
    player = Player.objects.get(user__username=username)
    path_ids = list(Path.objects.filter(player_model=pm_to_use).values_list('id', flat=True))
    path_idxs = range(len(path_ids))

    paths = dict()

    previous_flows = dict()
    previous_costs = dict()


    for idx, p_id in zip(path_idxs, path_ids):
        path = Path.objects.get(id=p_id)
        paths[idx] = list(path.edges.values_list('edge_id', flat=True))

        # for turn in game.turns.all():
        for turn in game.turns.filter(iteration__gte=iteration-1):
            # cache_key_t_cost = str(turn.iteration) + game.name + "get_previous_cost" + username + "t_cost"
            # cache_key_flow_ = str(turn.iteration) + game.name + "get_previous_cost" + username + "flow"
            # if cache.get(cache_key_t_cost):
            e_costs = turn.graph_cost.edge_costs
            t_cost = 0
            flow_distribution = FlowDistribution.objects.get(turn=turn, player =player )
            flow = flow_distribution.path_assignments.get(path=path).flow
            for e in path.edges.all():
                t_cost += e_costs.get(edge=e).cost
            if idx not in previous_costs:
                previous_costs[idx] = []
            previous_costs[idx].append(t_cost)
            if idx not in previous_flows:
                previous_flows[idx] = []
            previous_flows[idx].append(flow)

    response = dict()
    response['number_of_iterations'] = game.turns.filter(iteration__gte=iteration-1).count()
    response['users_with_same_pm'] = user_with_same_pm
    response['path_ids'] = path_ids
    response['paths'] = paths
    response['previous_costs'] = previous_costs
    response['previous_flows'] = previous_flows
    return JsonResponse(response)


  
def get_paths(request, username):
    user = User.objects.get(username=username)
    # iteration = request.GET.dict()['iteration']
    game = user.player.game
    current_turn = game.current_turn
    player = Player.objects.get(user__username=username)
    path_ids = list(Path.objects.filter(player_model=player.player_model).values_list('id', flat=True))
    path_idxs = range(len(path_ids))
    paths = dict()


    previous_cost = []
    previous_turn = None
    cumulative_costs = []
    weights = []

    prev_alloc, prev_path_ids = None, None

    if current_turn.iteration > 0:
        previous_turn = game.turns.get(iteration=current_turn.iteration - 1)

    # TODO: Fix the cache key scheme
    path_ids_key = get_hash(user.username) + 'path_ids'
    allocation_key = get_hash(user.username) + 'allocation'
    if cache.get(path_ids_key):
        prev_alloc = cache.get(allocation_key)
        prev_path_ids = cache.get(path_ids_key)
        logger.debug(prev_path_ids)
        logger.debug(prev_alloc)


    for idx, p_id in zip(path_idxs, path_ids):
        path = Path.objects.get(id=p_id)
        logger.debug(str(path))
        paths[idx] = list(path.edges.values_list('edge_id', flat=True))
        logger.debug(paths[idx])
        # if FlowDistribution.objects.filter(username=username, turn=current_turn).exists():
        # # if current_turn.flow_distributions.filter(username=username).exists():
        #     fd = FlowDistribution.objects.get(turn=current_turn, username=username)
        #     # fd = current_turn.flow_distributions.get(username=username)
        #     flow.append(fd.path_assignments.get(path__id=p_id).flow)
        # else:
        #     flow.append(0.5)

        if prev_alloc:
            logger.debug(prev_path_ids)
            logger.debug(path_ids)
            logger.debug("")
            logger.debug(prev_alloc[prev_path_ids.index(p_id)])

            weights.append(prev_alloc[prev_path_ids.index(p_id)])

        else:
            weights.append(0.5)

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


    weights = map(lambda x: x * 100, weights)
    total_weight = sum(weights)
    flows = map(lambda x: x/total_weight, weights)

    html_dict = {'path_idxs': zip(path_idxs, path_ids, weights, previous_cost, cumulative_costs, flows)}


    if game.single_slider_mode:
        previous_cost_total = sum(previous_cost)
        cumulative_cost_total = sum(cumulative_costs)
        html_dict['previous_cost'] = previous_cost_total
        html_dict['cumulative_cost'] = cumulative_cost_total
        html = render_to_string('graph/single_slider_display.djhtml', html_dict)
    else:
        html = render_to_string('graph/path_display_list.djhtml', html_dict)

    response = dict()

    response['html'] = html
    response['path_ids'] = path_ids
    response['paths'] = paths
    return JsonResponse(response)

  
@login_required
def clean_paths_cache(request):
      for user in User.objects.all():
        cache.delete(get_hash(user.username) + 'allocation')
        cache.delete(get_hash(user.username) + 'path_ids')
      return JsonResponse(dict())

  
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

    response = dict()
    response['node_ui_id'] = node_ui_id
    return JsonResponse(response)

  
@login_required
def user_model_info(request, username):
    user = User.objects.get(username=username)

    user_dict = dict()
    user_dict['player_username'] = username
    user_dict['game'] = user.player.game

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
    player = Player.objects.get(user=user)

    allocation = data['allocation']
    path_ids = data['ids']

    response = dict()
    game = player.game
    response['all'] = allocation
    response['ids'] = path_ids

    if not game.started:

        return JsonResponse(response)

    cache.set(get_hash(user.username) + 'allocation', allocation)
    cache.set(get_hash(user.username) + 'path_ids', path_ids)

    return JsonResponse(response)


  
@login_required
def current_state(request):
    data = json.loads(request.body)
    #logger.debug(data)
    game = Game.objects.get(name=data['game'])

    time_key = game.pk + get_hash(str(game.current_turn.iteration))

    duration = None

    if cache.get(time_key):
        duration = cache.get(time_key)
    else:
        duration = game.duration
        cache.set(time_key, duration)

    secs_left = duration

    if game.game_loop_time:
        datetime_started = game.game_loop_time
        es_started = int(datetime_started.strftime("%s"))
        secs_now = int(datetime.now().strftime("%s"))
        secs_left = (es_started + duration) - secs_now


    # cache.set('time_left', secs_left)

    response = dict()
    response['iteration'] = game.current_turn.iteration
    response['secs'] = secs_left

    edge_costs = dict()

    costs_cache_key = get_hash(game.pk) + 'iteration %d' % game.current_turn.iteration

    if cache.get(costs_cache_key):
        edge_costs = cache.get(costs_cache_key)
    else:
        cache.set(costs_cache_key, get_current_edge_costs(game))

    max_flow_cache_key = get_hash(game.pk) + 'edge_max_flow'
    if not cache.get(max_flow_cache_key):
       # logger.debug('max flow CACHE FAILLEDDD')
        edge_max_flow = calculate_maximum_flow(game)
        cache.set(max_flow_cache_key, edge_max_flow)

    response['edge_max_flow'] = cache.get(max_flow_cache_key)
    response['edge_cost'] = edge_costs
    response['duration'] = game.duration

    return JsonResponse(response)

  
def start_game(request):

    #data = json.loads(request.body)

    #game = Game.objects.get(name=data['game'])
    game = Game.objects.get(currently_in_use = True)
    global current_game_stopped
    global current_game_started
    current_game_stopped = False
    current_game_started = True



    if(game.started):
        return JsonResponse(dict())
    else:
        logger.debug('Calculating equilibrium flows')
        logger.debug(game.graph.name)
        updateEquilibriumFlows(game.graph.name)
        logger.debug('Finished calculating equilibrium flows')

        game.started = True
        game.game_loop_time = datetime.now()
        game.stopped = False

        game.save()

        game_force_next.apply_async((game.name,), countdown=game.duration)
        return JsonResponse(dict())

  
def stop_game(request):
    global current_game_stopped
    global current_game_started
    global use_intermediate_room

    current_game_stopped = True
    current_game_started = False
    use_intermediate_room = True
    data = json.loads(request.body)
    game = Game.objects.get(currently_in_use = True)
    dump_data_fixture('graph-' + str(game.graph.name)+'-'+str(datetime.now()) + '.json')
    game.stopped = True
    game.save()
    for user in User.objects.all():
        cache.delete(get_hash(user.username) + 'allocation')
        cache.delete(get_hash(user.username) + 'path_ids')
    #generate_player_model()
    switch_game()

    response = dict()
    response['success'] = True
    response['use_intermediate'] = use_intermediate_room
    response['use_end'] = no_more_games_left()

    return JsonResponse(response)


# TODO: Fix this later!
def reset_game(game):

    users, pms = [], []

    for player in Player.objects.all():
        users.append(player.user)
        pms.append(player.player_model)

    EdgeCost.objects.all().delete()
    GameTurn.objects.filter(game=game).delete()
    FlowDistribution.objects.all().delete()
    GraphCost.objects.all().delete()
    PathFlowAssignment.objects.all().delete()
    cache.clear()

    initial_turn = GameTurn()
    initial_turn.game = game
    initial_turn.iteration = 0
    initial_turn.save()
    game.current_turn = initial_turn
    game.save()

    # Randomize here
    random.shuffle(pms)

    for user, pm in zip(users, pms):
        player = Player(user=user)
        player.game = game
        player.player_model = pm
        flow_distribution = create_default_distribution(player.player_model, game,
                                                        player.user.username, player)
        player.flow_distribution = flow_distribution
        flow_distribution.save()
        player.save()

    game.stopped = True
    game.started = False
    game.save()

  
def start_edge_highlight(request):
    game = Game.object.get(currently_in_use=True)

    if not game.edge_highlight:
        game.edge_highlight = True
        game.save()
        reset_game(game)

    response = dict()
    response['success'] = True
    return JsonResponse(response)

  
def stop_edge_highlight(request):
    game = Game.object.get(currently_in_use=True)

    if game.edge_highlight:
        game.edge_highlight = False
        game.save()
        reset_game(game)

    response = dict()
    response['success'] = True
    return JsonResponse(response)

  
def save_data(request):
    dump_data_fixture('graph-' + str(Game.objects.get(currently_in_use=True).graph.name)+'-'+str(datetime.now()) + '.json')
    return JsonResponse(dict())

  
def assign_duration(request):
    data = json.loads(request.body)
    duration = data['duration']

    # TODO: Fix this for multiple games
    game = Game.objects.get(name=data['game'])

    game.duration = duration
    game.save()

    # begin at the *next* turn
    time_key = game.pk + get_hash(str(game.current_turn.iteration + 1))
    cache.set(time_key, game.duration)

    return JsonResponse(dict())

  
def set_game_mode(request):
    data = json.loads(request.body)
    single_slider_mode = data['single_slider']

    # TODO: Fix this for multiple games
    game = Game.objects.get(name=data['game'])

    game.single_slider_mode = single_slider_mode
    game.save()

    return JsonResponse(dict())

  
@login_required
def waiting_room(request):
    user = User.objects.get(username=request.user.username)
    response = dict()
    response['Success']=True
    template = 'graph/user_wait.djhtml'
    if not cache.get("waiting_time"):
        cache.set("waiting_time", waiting_time)
    if (int(cache.get("waiting_time"))<0  or user.player.game.started) and not(no_more_games_left()):
         return HttpResponseRedirect('/graph/accounts/profile/')




    response['time_countdown'] = cache.get('waiting_time')
    response['username'] = user.username
    response['time_countdown'] = cache.get('waiting_time')
    response['started_game'] = user.player.game.started
    if no_more_games_left():
        html = render_to_string('graph/end_game.djhtml', response)
    elif use_intermediate_room:
        html = render_to_string('graph/intermediate_room.djhtml', response)

    else:

        html = render_to_string('graph/welcome_template.djhtml', response)
    response['html']= html
    return render(request,template,response)

  
@login_required
def waiting_countdown(request):
    val = int (cache.get("waiting_time"))
    val = val-1
    cache.set("waiting_time",val)
    response = dict()
    response['ping']=val
    return JsonResponse(response)

  
@login_required
def get_countdown(request):
    global current_game_started
    response= dict()
    response['countdown'] =cache.get('waiting_time')
    response ['started'] = current_game_started
    response['game_left'] = no_more_games_left()
    return JsonResponse(response)

  
def set_waiting_time(request):
    cache.set('waiting_time',waiting_time)
    response = dict()
    response['Success'] = True
    response['countdown'] = int (cache.get("waiting_time"))
    return JsonResponse(response)



  
def get_game_graph(request):
    data = json.loads(request.body)
    game_name = data['game']
    response = dict()
    game = Game.objects.get(name=game_name)
    response['game']=game.name
    try:
        graph= game.graph
        response['graph'] =graph.name
    except:
        response['graph'] =""
    return JsonResponse(response)

  
def assign_player_model_to_player(request):
    assign_user_to_player_model()
    return JsonResponse(dict())

  
@login_required
def heartbeat(request):
    post_data = request.POST
    username = post_data['username']
    timestamp = post_data['timestamp']
    cache.set(username + '_ts', timestamp)
    response =dict()
    response['ts'] = cache.get(username + '_ts')
    response['current_game_stopped'] = current_game_stopped
    return JsonResponse(response)


  
def check_for_connection_loss(request):
    game_name = Game.objects.get(currently_in_use = True).name
    change_player.apply_async((game_name,), countdown=10.0)
    response = dict()
    #for test purpose with basis_test.json
    response['graph'] =  Game.objects.get(currently_in_use = True).graph.name
    response['ts_1'] = cache.get("user_1_ts")
    response['ts_2'] = cache.get("user_2_ts")
    response['ai_1'] =  cache.get("user_1_ai")
    response['ai_2'] =  cache.get("user_2_ai")
    return JsonResponse(response)


def no_more_games_left():
    initial_number_of_games = len(Game.objects.all())
    used_games = len(Game.objects.filter(stopped=True))
    return initial_number_of_games==used_games
