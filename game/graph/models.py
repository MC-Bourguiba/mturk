from django.db import models

from uuidfield import UUIDField


class Node(models.Model):
    node_id = UUIDField(auto=True)


class Edge(models.Model):
    from_node = Node()
    to_node = Node()
    weight = models.FloatField(default=1.0)
