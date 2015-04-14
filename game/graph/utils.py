from models import *

import json
import re
import copy
from graph_tools import *
import parser
import networkx as nx
import uuid
import numpy as np


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
    # flow_distributions = current_turn.flow_distributions

    for e in Edge.objects.filter(graph=game.graph):
        edge_flow[e] = 0.0

    for flow_distribution in FlowDistribution.objects.filter(turn=current_turn):
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

    # first, remove the previously computed paths for that player model.
    Path.objects.filter(player_model__name=player_model).delete()

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

#
# Functions to compute the equilibrium, so that we can correctly normalize the costs

def computeEquilibrium(dimensions, gradientFunctions, precision):
    # dimensions is a list of scalars that specify the number of paths of each player
    # gradientFunctions is a list of functions. Use:
    # gs = gradientFunctions(xs) returns a list of path costs, where xs is a list of path flows
    # precision is a scalar, specifies the desired precision.
    def entropicDescentUpdate(x, g, t):
        w = [xi*np.exp(-gi/(1+np.sqrt(t))) for (xi,gi) in zip(x, g)]
        return w / (sum(w))
    # initialize
    xs = [np.ones((di, 1))/di for di in dimensions]
    gs = gradientFunctions(xs)
    def cost(xs, gs):
        return sum(np.dot(x.T, g) for (x, g) in zip(xs, gs))
    c = cost(xs, gs)
    delta = 1
    t = 0
    while(delta > precision):
        xs_plus = [entropicDescentUpdate(x, g, t) for (x, g) in zip(xs, gs)]
        gs_plus = gradientFunctions(xs_plus)
        c_plus = cost(xs_plus, gs_plus)
        delta = abs(c_plus - c)
        c = c_plus
        xs = xs_plus
        gs = gs_plus
        t += 1
        if(t % 100 == 0):
            print(t)
    # print("converged after {} iterations".format(t))
    costs = [np.dot(x.T, g) for (g, x) in zip(gs, xs)]
    return costs


def pathLossFunctions(costFunctions, adjMatrices, masses):
    def lossFunctions(xs):
        edgeFlows = sum(mass*np.dot(adjMatrix, x) for (mass, adjMatrix, x) in zip (masses, adjMatrices, xs))
        edgeCosts = [evalFunc(costFunc, edgeFlow) for (costFunc, edgeFlow) in zip(costFunctions, edgeFlows)]
        return [np.dot(adjMatrix.T, edgeCosts) for adjMatrix in adjMatrices]
    return lossFunctions



def computeRoutingGameEquilibrium(costFunctions, adjMatrices, masses, precision = .000000001):
    dimensions = [np.size(adjMatrix, 1) for adjMatrix in adjMatrices]
    gradientFunction = pathLossFunctions(costFunctions, adjMatrices, masses)
    return computeEquilibrium(dimensions, gradientFunction, precision)

def updateEquilibriumFlows(graph):
    costFunctionDict = {}
    massDict = {}
    pmPaths = {}

    edgeIndex = {}
    edgeIdx = 0
    pmIndex = {}
    pmIdx = 0

    for edge in Edge.objects.filter(graph__name=graph):
        costFunctionDict[edge] = edge.cost_function
        edgeIndex[edge] = edgeIdx
        edgeIdx += 1
    for pm in PlayerModel.objects.filter(graph__name=graph):
        massDict[pm] = pm.flow
        pmPaths[pm] = []
        pmIndex[pm] = pmIdx
        pmIdx += 1
    for path in Path.objects.filter(graph__name=graph):
        pmPaths[path.player_model].append(path.edges.all())


    # once we have the dictionaries, we can create the vectors
    compiledCosts = [None]*len(edgeIndex)
    adjMatrices = [None]*len(pmIndex)
    masses = [None]*len(pmIndex)

    def createAdjMatrix(paths):
        adjMatrix = np.zeros((len(edgeIndex), len(paths)))
        pathIdx = 0
        for pathEdges in paths:
            for edge in pathEdges:
                adjMatrix[edgeIndex[edge], pathIdx] = 1
            pathIdx += 1
        return adjMatrix

    for (edge, cost) in costFunctionDict.items():
        compiledCosts[edgeIndex[edge]] = parser.expr(cost).compile()
    for (pm, paths) in pmPaths.items():
        adjMatrices[pmIndex[pm]] = createAdjMatrix(paths)
    for (pm, mass) in massDict.items():
        masses[pmIndex[pm]] = mass

    eqCosts = computeRoutingGameEquilibrium(compiledCosts, adjMatrices, masses)
    for (pm, pmIdx) in pmIndex.items():
        pm.normalization_const = eqCosts[pmIdx]
        pm.save()

    return True
