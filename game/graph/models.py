from django.db import models

from uuidfield import UUIDField


class Graph(models.Model):
    name = models.TextField(primary_key=True)
    graph_ui = models.TextField()


class Node(models.Model):
    graph = models.ForeignKey('Graph')
    node_id = UUIDField(primary_key=True, auto=True)
    ui_id = models.IntegerField()


class Edge(models.Model):
    edge_id = UUIDField(primary_key=True, auto=True)
    graph = models.ForeignKey('Graph')
    from_node = models.ForeignKey('Node', related_name='from')
    to_node = models.ForeignKey('Node', related_name='to')

    weight_function = models.TextField()
