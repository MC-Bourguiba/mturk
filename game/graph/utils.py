from models import Node, Edge

import re

edge_source_key     = r'links[%d][target][id]'
edge_target_key     = r'links[%d][source][id]'
edge_number_pattern = r'links\[(\d+)\].*'
node_id_pattern     = r'nodes\[(\d+)\]\[id\]'


def generate_graph(request):
    edges = set()
    edges_number = set()
    gDict = request.POST.dict()

    node_id_uuid_map = dict()

    nodes = []
    for key in gDict.keys():
        result = re.search(node_id_pattern, key)
        if result:
            node_id = int(result.group(1))
            nodes.append(node_id)
            node_id_uuid_map[node_id] = Node()
            node_id_uuid_map[node_id].save()

    for key in gDict.keys():
        result = re.search(edge_number_pattern, key)
        if result:
            edge_point = int(result.group(1))
            edges_number.add(edge_point)

    for e in edges_number:
        source_node = int(gDict[edge_source_key % e]) - 1
        target_node = int(gDict[edge_target_key % e]) - 1
        source = node_id_uuid_map[source_node]
        target = node_id_uuid_map[target_node]
        edge = Edge()
        edge.from_node = source
        edge.to_node = target
        edge.save()
