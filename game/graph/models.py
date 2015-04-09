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
    node_id = models.TextField(primary_key=True)
    # node_id = UUIDField(primary_key=True, auto=True)
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
    normalization_const = models.FloatField(null=True, blank=True)

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
    completed_task = models.BooleanField(default=False)
    game = models.ForeignKey('Game', null=True, blank=True)
    flow_distribution = models.ForeignKey('FlowDistribution', null=True, blank=True)
    completed_task = models.BooleanField(default=False)

    def __unicode__(self):
        return self.user.username


class Edge(models.Model):
    edge_id = models.TextField(primary_key=True)
    # edge_id = UUIDField(primary_key=True, auto=True)
    graph = models.ForeignKey('Graph')
    from_node = models.ForeignKey('Node', related_name='from_node')
    to_node = models.ForeignKey('Node', related_name='to_node')

    cost_function = models.TextField(default='x')

    def __unicode__(self):
        return 'from: %i to: %i' % (self.from_node.ui_id, self.to_node.ui_id)


class Path(models.Model):
    graph = models.ForeignKey('Graph')
    edges = models.ManyToManyField('Edge')
    player_model = models.ForeignKey('PlayerModel')


class PathFlowAssignment(models.Model):
    path = models.ForeignKey('Path')
    flow = models.FloatField(default=0.0)


class FlowDistribution(models.Model):
    path_assignments = models.ManyToManyField('PathFlowAssignment')
    username = models.TextField(blank=True, null=True)


class EdgeCost(models.Model):
    edge = models.ForeignKey('Edge')
    cost = models.FloatField(default=0.0)


class GraphCost(models.Model):
    graph = models.ForeignKey('Graph')
    edge_costs = models.ManyToManyField('EdgeCost')


class GameTurn(models.Model):
    iteration = models.IntegerField(default=0)
    graph_cost = models.ForeignKey('GraphCost', blank=True, null=True)
    # graph_cost = models.ManyToManyField('GraphCost', blank=True, null=True)
    flow_distributions = models.ManyToManyField('FlowDistribution')


class Game(models.Model):
    name = models.TextField(primary_key=True)
    turns = models.ManyToManyField('GameTurn')
    current_turn = models.ForeignKey('GameTurn', related_name='current_turn', blank=True, null=True)
    graph = models.OneToOneField('Graph', blank=True, null=True)
