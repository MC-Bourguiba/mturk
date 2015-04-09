from models import *

import json
import re
import copy

from graph_tools import *

import parser

import networkx as nx
import uuid


root_username = 'root'


# TODO: Clean this up
def generate_and_save_graph(graph_dict):
    edges = set()
    edges_number = set()

    node_map = dict()

    node_id_uuid_map = dict()

    graph = Graph(graph_dict['graph'])
    graph.graph_ui = json.dumps(graph_dict)
    graph.save()

    for n_dict in graph_dict['nodes']:
        node = Node()
        node.node_id = str(uuid.uuid4())
        node_id  = n_dict['id']
        node.ui_id = node_id
        node.graph = graph
        node.save()
        node_map[node_id] = node

    for e_dict in graph_dict['links']:
        edge = Edge()
        source_node_id = e_dict['source']['id']
        target_node_id = e_dict['target']['id']

        if e_dict['left']:
            source_node_id = e_dict['target']['id']
            target_node_id = e_dict['source']['id']

        edge.edge_id = e_dict['id']
        edge.from_node = node_map[source_node_id]
        edge.to_node = node_map[target_node_id]
        edge.graph = graph
        edge.save()

    return graph


def is_turn_complete(game):
    players = Player.objects.filter(game=game)

    for player in players:
        if not player.completed_task:
            return False

    return True


def evalFunc(func, xVal):
    x = xVal
    return eval(func)


def update_cost(game):
    edge_flow = dict()
    current_turn = game.current_turn
    flow_distributions = current_turn.flow_distributions

    for e in Edge.objects.filter(graph=game.graph):
        edge_flow[e] = 0.0

    for flow_distribution in flow_distributions.all():
        for path_assignment in flow_distribution.path_assignments.all():
            for e in path_assignment.path.edges.all():
                edge_flow[e] += path_assignment.flow

    graph_cost = GraphCost(graph=game.graph)
    graph_cost.save()

    for e in Edge.objects.filter(graph=game.graph):
        cost_f = parser.expr(e.cost_function).compile()
        cost = evalFunc(cost_f, edge_flow[e])

        # print cost

        edge_cost = EdgeCost()
        edge_cost.edge = e
        edge_cost.cost = cost
        edge_cost.save()
        graph_cost.edge_costs.add(edge_cost)

    graph_cost.save()
    current_turn.graph_cost = graph_cost
    current_turn.save()


def sanitize_graph_json(graph_dict):
    for i in range(len(graph_dict['nodes'])):
        graph_dict['nodes'][i]['weight'] = 1.0
    return graph_dict


def generate_paths(graph, source_node, destination_node, player_model):
    # source_node = Node.objects.get(graph__name=graph_name, ui_id=source_ui_id)
    # target_node = Node.objects.get(graph__name=graph_name, ui_id=destination_ui_id)
    # graph = Graph.objects.get(name=graph_name)

    G = nx.DiGraph()

    for e in graph.edge_set.all():
        G.add_edge(e.from_node.ui_id, e.to_node.ui_id)

    path_edges = dict()

    # path_m = Path()
    # path_m.save()

    for idx, p in enumerate(nx.all_simple_paths(G, source_node.ui_id, destination_node.ui_id)):
        path = Path()
        path.graph = graph
        path.player_model = player_model
        path.save()

        # path = []
        for c, v in zip(p, p[1:]):
            e = Edge.objects.get(graph__name=graph.name,
                                 from_node__ui_id=c,
                                 to_node__ui_id=v)
            # path.append(str(e.edge_id))
            # path_m.edges.add(e)
            path.edges.add(e)

        # path_edges[idx] = path

    # return path_edges
