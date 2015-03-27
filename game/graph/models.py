from django.db import models

from django.contrib.auth.models import User

from uuidfield import UUIDField


class Graph(models.Model):
    name = models.TextField(primary_key=True)
    graph_ui = models.TextField()

    def __unicode__(self):
        return self.name


class Node(models.Model):
    graph = models.ForeignKey('Graph')
    node_id = UUIDField(primary_key=True, auto=True)
    ui_id = models.IntegerField()

    def __unicode__(self):
        return str(self.ui_id)


class PlayerModel(models.Model):
    name = models.TextField(primary_key=True)
    graph = models.ForeignKey(Graph, null=True, blank=True)
    start_node = models.ForeignKey(Node, related_name='start_node', null=True, blank=True)
    destination_node = models.ForeignKey(Node, related_name='destination_node',
                                         null=True, blank=True)
    flow = models.FloatField(null=True, blank=True)
    in_use = models.BooleanField(default=False)

    def get_player(self):
        if hasattr(self, 'player'):
            return self.player
        return None

    def __unicode__(self):
        return self.name

    class Meta:
        ordering = ['name']


class Player(models.Model):
    user = models.OneToOneField(User)
    player_model = models.ForeignKey(PlayerModel, blank=True, null=True)

    def __unicode__(self):
        return self.user.username


class Edge(models.Model):
    edge_id = UUIDField(primary_key=True, auto=True)
    graph = models.ForeignKey('Graph')
    from_node = models.ForeignKey('Node', related_name='from_node')
    to_node = models.ForeignKey('Node', related_name='to_node')

    cost_function = models.TextField(default="x")
