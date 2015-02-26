from django.db import models

from uuidfield import UUIDField


class Graph(models.Model):
    name = models.TextField(primary_key=True)


class Node(models.Model):
    graph = models.ForeignKey(Graph)
    node_id = UUIDField(primary_key=True, auto=True)


class Edge(models.Model):
    from_node = models.ManyToManyField(Node)
    to_node = models.ForeignKey(Node)
    graph = models.ForeignKey(Graph)
    weight = models.FloatField(default=1.0)
