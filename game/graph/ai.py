from utils import *
from models import *
from tasks import *
from game_functions import *
from hedge_algorithm import *




from django.contrib.auth.models import User
import random
import math

current_game = 'game'

def ai_play(user,current_game):
    game = Game.objects.get(name=current_game)
    game = user.player.game
    iteration = game.current_turn.iteration
    player = Player.objects.get(user__username=user.username)
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

    response['path_ids'] = path_ids
    response['paths'] = paths
    response['previous_costs'] = previous_costs
    response['previous_flows'] = previous_flows
    print(response)
    return