from django.contrib.auth.models import User

from datetime import timedelta
from datetime import datetime

from utils import *
from models import *


import redis_lock
from redis_lock import StrictRedis


def create_new_player(user, game):
    success = False

    if user.username != root_username:

        pms = PlayerModel.objects.filter(in_use=False, graph__isnull=False)

        if pms:
            player = Player(user=user)
            # player.user = user
            player.game = game

            pm = PlayerModel.objects.filter(in_use=False, graph__isnull=False)[:1].get()
            pm.in_use = True
            flow_distribution = create_default_distribution(pm, game, user.username, player)
            player.flow_distribution = flow_distribution
            player.player_model = pm
            flow_distribution.save()
            pm.save()

            player.save()

            success = True

    return success


def iterate_next_turn(game):
    update_cost(game)

    game.turns.add(game.current_turn)
    next_turn = GameTurn()
    next_turn.iteration = game.current_turn.iteration + 1
    next_turn.save()

    game.current_turn = next_turn
    game.save()


# Lock to protect against race condition using Redis.
# TODO: Make this cleaner?
def create_flow_distribution(game, username, player, allocation, path_ids, turn):
    conn = StrictRedis()

    with redis_lock.Lock(conn, get_hash(username) + get_hash(str(turn.iteration))
                         + 'create_flow_distribution'):
        # Do we really need this?
        FlowDistribution.objects.filter(username=username, turn=turn).delete()

        flow_distribution = FlowDistribution(turn=turn, username=username)
        flow_distribution.save()

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

            assignment.save()
            flow_distribution.path_assignments.add(assignment)
            flow_distribution.username = username

        flow_distribution.save()
        player.flow_distribution = flow_distribution
        player.save()

        return flow_distribution

    return None


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


def create_default_distribution(player_model, game, username, player):
    path_ids = list(Path.objects.filter(player_model=player_model).values_list('id', flat=True))
    return create_flow_distribution(game, username, player, [], path_ids, game.current_turn)


def evalFunc(func, xVal):
    x = xVal
    return eval(func)


def calculate_edge_flow(game):
    """
    Returns dictionary, keys are the edge id's and
    the values are the flow on the edge.
    """
    edge_flow = dict()
    current_turn = game.current_turn

    for e in Edge.objects.filter(graph=game.graph):
        edge_flow[e] = 0.0

    for player in Player.objects.filter(game=game):
        allocation = []
        path_ids = []

        # Check the cache
        if cache.get(get_hash(player.user.username) + 'allocation'):
            allocation = cache.get(get_hash(player.user.username) + 'allocation')
            path_ids = cache.get(get_hash(player.user.username) + 'path_ids')
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


        # print allocation
        # print path_ids
        flow_distribution = create_flow_distribution(game, player.user.username,
                                                     player, allocation,
                                                     path_ids, current_turn)

        for path_assignment in flow_distribution.path_assignments.all():
            for e in path_assignment.path.edges.all():
                edge_flow[e] += path_assignment.flow

    return edge_flow


def get_current_edge_costs(game):
    edge_costs = dict()
    if game.current_turn.iteration > 0 and game.edge_highlight:
        gc = GameTurn.objects.get(iteration=game.current_turn.iteration - 1).graph_cost
        for ec in gc.edge_costs.all():
            edge_costs[ec.edge_id] = ec.cost
    return edge_costs


def update_cost(game):
    edge_flow = calculate_edge_flow(game)
    graph_cost = GraphCost(graph=game.graph)
    graph_cost.save()

    for e in Edge.objects.filter(graph=game.graph):
        cost_f = parser.expr(e.cost_function).compile()
        cost = evalFunc(cost_f, edge_flow[e])

        edge_cost = EdgeCost()
        edge_cost.edge = e
        edge_cost.cost = cost
        edge_cost.save()
        graph_cost.edge_costs.add(edge_cost)

    graph_cost.save()
    game.current_turn.graph_cost = graph_cost
    game.current_turn.save()

    costs_cache_key = 'iteration %d' % game.current_turn.iteration
    cache.set(costs_cache_key, get_current_edge_costs(game))
