from django.contrib.auth.models import User

from datetime import timedelta
from datetime import datetime

from utils import *
from models import *
from ai import *

import redis_lock
from redis_lock import StrictRedis

import logging
logger = logging.getLogger(__name__)


def create_new_player(user, game, superuser):
    success = False
    graph = game.graph
    player = Player(user=user)
    player.save()
    # player.user = user
    player.game = game




    success = True

    player.superuser = superuser
    player.save()

    return success


def iterate_next_turn(game):
    update_cost(game)

    game.turns.add(game.current_turn)
    next_turn = GameTurn(game_object=game)
    next_turn.iteration = game.current_turn.iteration + 1
    next_turn.save()

    game.current_turn = next_turn
    game.save()
    for player in Player.objects.filter(is_a_bot = True,superuser=False):
         user = player.user
         allocation , path_ids = ai_play_server(user)
         logger.debug("Allocation at turn "+ str(game.current_turn.iteration)+" by "+str(user))
         logger.debug(allocation)

         cache.set(get_hash(user.username) + 'allocation', allocation)
         cache.set(get_hash(user.username) + 'path_ids', path_ids)



# Lock to protect against race condition using Redis.
# TODO: Make this cleaner?
def create_flow_distribution(game, player, allocation, path_ids, turn):
    conn = StrictRedis()

    # with redis_lock.Lock(conn, get_hash(username) + get_hash(str(turn.iteration))
    #                      + 'create_flow_distribution'):
        # Do we really need this?
    # FlowDistribution.objects.filter(username=username, turn=turn).delete()
    #logger.debug("test create flow distribution player :"+ str(player))
    # logger.debug("test create flow distribution turn :"+ str(turn))

    num_player_model = Player.objects.filter(player_model = player.player_model).count()

    flow_distribution, created = FlowDistribution.objects.get_or_create(turn=turn, player=player)
    flow_distribution.path_assignments.clear()

    total_weight = float(sum(allocation))
    nb_paths = float(len(allocation))

    for weight, path_id in zip(allocation, path_ids):
        path = Path.objects.get(graph=game.graph, player_model=player.player_model,
                                pk=path_id)
        assignment = PathFlowAssignment()
        assignment.path = path
        if(total_weight > 0):
            assignment.flow = (weight / total_weight) * player.player_model.flow
        else:
            # if all the weights are non-positive, assign the uniform distribution
            assignment.flow = 1. / nb_paths * player.player_model.flow
        assignment.flow/=num_player_model
        assignment.save()
        flow_distribution.path_assignments.add(assignment)

    flow_distribution.save()
    player.flow_distribution = flow_distribution
    player.save()

    return flow_distribution


def calculate_maximum_flow(game):
    """
    Calculate the maximum flow on the edges for all users
    """

    edge_flow = dict()
    for pm in PlayerModel.objects.filter(graph=game.graph):
        for path in Path.objects.filter(player_model=pm, graph=game.graph):
        # path = Path.objects.get(player_model=pm, graph=game.graph)
            for edge in path.edges.all():
                if edge.edge_id not in edge_flow:
                    edge_flow[edge.edge_id] = pm.flow
                else:
                    edge_flow[edge.edge_id] += pm.flow

    return edge_flow


def create_default_distribution(player_model, game, player):
    path_ids = list(Path.objects.filter(player_model=player_model).values_list('id', flat=True))
    return create_flow_distribution(game, player, [1.0/len(path_ids)]*len(path_ids), path_ids, game.current_turn)


def evalFunc(func, xVal):
    x = xVal
    return eval(func)


def calculate_edge_flow(current_turn, game, use_cache=True):
    """
    Returns dictionary, keys are the edge id's and
    the values are the flow on the edge.
    """
    edge_flow = dict()
    # current_turn = game.current_turn

    for e in Edge.objects.filter(graph=game.graph):
        edge_flow[e] = 0.0

    for player in Player.objects.filter(game=game, superuser=False):
        allocation = []
        path_ids = []

        # Check the cache
        if use_cache and cache.get(get_hash(player.user.username) + 'allocation'):
            allocation = cache.get(get_hash(player.user.username) + 'allocation')
            path_ids = cache.get(get_hash(player.user.username) + 'path_ids')
            if player.user.username == 'u1':
                logger.debug('Getting allocation from cache:' + str(allocation))

        else:
            flow_distribution = None

            # Else copy from previous iteration.
            if current_turn.iteration == 0:
                # If we are at the start, just use the default flow_distribution
                # Must have been instiated!!!
                flow_distribution = FlowDistribution.objects.get(turn=current_turn,
                                                                 player=player)
            else:
                prev_iteration = current_turn.iteration - 1

                # This should not fail!!!
                flow_distribution = FlowDistribution.objects.get(turn__iteration=prev_iteration,
                                                                 player=player)

            for pfa in flow_distribution.path_assignments.all():
                path_ids.append(pfa.path.id)
                allocation.append(pfa.flow)


        flow_distribution = create_flow_distribution(game, player, allocation,
                                                     path_ids, current_turn)

        for path_assignment in flow_distribution.path_assignments.all():
            for e in path_assignment.path.edges.all():
                edge_flow[e] += path_assignment.flow

    return edge_flow


def get_current_edge_costs(game):
    edge_costs = dict()
    if game.current_turn.iteration > 0 and game.edge_highlight:
        # TODO: Clean this up, a bit messy! Add game to GameTurn model?
        gc = GameTurn.objects.get(game=game, iteration=game.current_turn.iteration-1).graph_cost
        # for gt in GameTurn.objects.get(game=game, iteration=game.current_turn.iteration-1):
        #     if gt.graph_cost and gt.graph_cost.graph == game.graph:
        #         gc = gt.graph_cost
        #         break

        # gc = GameTurn.objects.get(iteration=game.current_turn.iteration - 1).graph_cost
        for ec in gc.edge_costs.all():
            edge_costs[ec.edge_id] = ec.cost
    return edge_costs


def calculate_graph_cost(edge_flow, graph):
    graph_cost = GraphCost(graph=graph)
    graph_cost.save()

    for e in Edge.objects.filter(graph=graph):
        cost_f = parser.expr(e.cost_function).compile()
        cost = evalFunc(cost_f, edge_flow[e])

        edge_cost = EdgeCost()
        edge_cost.edge = e
        edge_cost.cost = cost
        edge_cost.save()
        graph_cost.edge_costs.add(edge_cost)

    graph_cost.save()
    return graph_cost


def update_cost(game):
    logger.debug(game.name)
    edge_flow = calculate_edge_flow(game.current_turn, game)
    graph_cost = calculate_graph_cost(edge_flow, game.graph)
    # graph_cost = GraphCost(graph=game.graph)
    # graph_cost.save()

    game.current_turn.graph_cost = graph_cost
    game.current_turn.save()

    costs_cache_key = get_hash(game.pk) + 'iteration %d' % game.current_turn.iteration
    cache.set(costs_cache_key, get_current_edge_costs(game))
