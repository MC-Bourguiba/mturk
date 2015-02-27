from django.db import models

from uuidfield import UUIDField


class Graph(models.Model):
    name = models.TextField(primary_key=True)


class Node(models.Model):
    graph = Graph()
    node_id = UUIDField(primary_key=True, auto=True)


class Edge(models.Model):
    from_node = Node()
    to_node = Node()
    weight = models.FloatField(default=1.0)
