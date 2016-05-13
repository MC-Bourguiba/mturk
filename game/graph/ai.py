from utils import *
from models import *
from tasks import *
from hedge_algorithm import *



import logging
logger = logging.getLogger(__name__)


from django.contrib.auth.models import User
import random
import math
from views import *

def get_previous_cost_server_side(user):
    game = user.player.game
    iteration = game.current_turn.iteration
    #logger.debug("test user :  "+str(user))
    player = Player.objects.get(user__username=user.username)
    #logger.debug("test :  "+str(player.player_model))
    path_ids = list(Path.objects.filter(player_model=player.player_model).values_list('id', flat=True))
    path_idxs = range(len(path_ids))
    paths = dict()

    previous_flows = dict()
    previous_costs = dict()
    #logger.debug("test 2 "+str(path_ids))

    for idx, p_id in zip(path_idxs, path_ids):
        path = Path.objects.get(id=p_id)
        paths[idx] = list(path.edges.values_list('edge_id', flat=True))


        for turn in game.turns.filter(iteration=iteration-1):

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

    return response

def ai_play_server(user):
    game = user.player.game
    if user.player.superuser:
        return
    previous_costs_and_flows = get_previous_cost_server_side(user)
    paths_ids= previous_costs_and_flows['path_ids']
    if(game.current_turn.iteration>0):

        previous_costs = {int(k):v[0] for k,v in previous_costs_and_flows['previous_costs'].iteritems()}
        previous_flows = {int(k):v[0] for k,v in previous_costs_and_flows['previous_flows'].iteritems()}
        new_flow= hedge_Algorithm(previous_costs,previous_flows,game.current_turn.iteration,range(len(paths_ids)))
        new_distrib=new_flow.values()

        return new_distrib,paths_ids
    else :
        return [1.0/len(paths_ids)]*len(paths_ids),paths_ids
