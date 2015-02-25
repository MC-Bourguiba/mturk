from django.db import models


class Node(models.Model):
    node_id = models.IntegerField(primary_key=True)


class Edge(models.Model):
    from_node = Node()
    to_node = Node()
    weight = models.FloatField(default=1.0)
