from models import Node, Edge, Graph

import json
import re
import copy

from graph_tools import *

import networkx as nx


# TODO: Clean this up
def generate_graph(graph_dict):
    edges = set()
    edges_number = set()

    node_map = dict()

    node_id_uuid_map = dict()

    graph = Graph(graph_dict['graph'])
    graph.graph_ui = json.dumps(graph_dict)
    graph.save()

    for n_dict in graph_dict['nodes']:
        node = Node()
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


def sanitize_graph_json(graph_dict):
    for i in range(len(graph_dict['nodes'])):
        graph_dict['nodes'][i]['weight'] = 1.0
    return graph_dict


def generate_paths(graph_name, source_ui_id, destination_ui_id):
    source_node = Node.objects.get(graph__name=graph_name, ui_id=source_ui_id)
    target_node = Node.objects.get(graph__name=graph_name, ui_id=destination_ui_id)
    graph = Graph.objects.get(name=graph_name)

    G = nx.DiGraph()

    for e in graph.edge_set.all():
        G.add_edge(e.from_node.ui_id, e.to_node.ui_id)

    path_edges = dict()

    for idx, p in enumerate(nx.all_simple_paths(G, source_ui_id, destination_ui_id)):
        path = []
        for c, v in zip(p, p[1:]):
            e = Edge.objects.get(graph__name=graph_name,
                                from_node__ui_id=c,
                                to_node__ui_id=v)
            path.append(str(e.edge_id))
        path_edges[idx] = path
    return path_edges
