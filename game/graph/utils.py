from models import Node, Edge, Graph

import json
import re


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

        edge.from_node = node_map[source_node_id]
        edge.to_node = node_map[target_node_id]
        edge.graph = graph
        edge.save()


def sanitize_graph_json(graph_dict):
    for i in range(len(graph_dict['nodes'])):
        graph_dict['nodes'][i]['weight'] = 1.0
        # del graph_dict['nodes'][i]['px']
        # del graph_dict['nodes'][i]['py']
        # del graph_dict['nodes'][i]['x']
        # del graph_dict['nodes'][i]['y']
    return graph_dict
