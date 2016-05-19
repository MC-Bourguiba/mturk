from django.db import models

from django.contrib.auth.models import User



class Graph(models.Model):
    name = models.TextField(primary_key=True)
    graph_ui = models.TextField()

    def __unicode__(self):
        return self.name


class Node(models.Model):
    graph = models.ForeignKey('Graph')
    node_id = models.TextField(primary_key=True)
    ui_id = models.IntegerField()

    def __unicode__(self):
        return str(self.ui_id)


class PlayerModel(models.Model):
    name = models.TextField(primary_key=True)
    graph = models.ForeignKey(Graph, null=True, blank=True)
    start_node = models.ForeignKey(Node, related_name='start_node', null=True, blank=True)
    destination_node = models.ForeignKey(Node, related_name='destination_node', null=True, blank=True)
    flow = models.FloatField(null=True, blank=True)
    in_use = models.BooleanField(default=False)
    normalization_const = models.FloatField(null=True, blank=True)
    historic_player= models.TextField(default='')
    def get_player(self):
        if hasattr(self, 'player'):
            return self.player
        return None

    def __unicode__(self):
        return self.name

    class Meta:
        ordering = ['name']


class Player(models.Model):
    user = models.OneToOneField(User, null=True, blank=True)
    player_model = models.ForeignKey(PlayerModel, blank=True, null=True)
    # completed_task = models.BooleanField(default=False)
    game = models.ForeignKey('Game', null=True, blank=True)
    is_a_bot = models.BooleanField(default=False)
    # flow_distribution = models.ForeignKey('FlowDistribution', null=True, blank=True)
    superuser = models.BooleanField(default=False)

    def __unicode__(self):
        return self.user.username

    class Meta:
        ordering = ['user__username']


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

    def __unicode__(self):
        return str(self.id) + str(map(str, self.edges.all()))


class PathFlowAssignment(models.Model):
    path = models.ForeignKey('Path')
    flow = models.FloatField(default=0.2)

    def __unicode__(self):
        return unicode(self.path) + ' flow: ' + str(self.flow)


class GameTurn(models.Model):
    iteration = models.IntegerField(default=0)
    graph_cost = models.ForeignKey('GraphCost', blank=True, null=True)
    game_object = models.ForeignKey('Game', blank=True, null=True)

    def __unicode__(self):
        return str(self.iteration)
    # graph_cost = models.ManyToManyField('GraphCost', blank=True, null=True)


# NOTE: DO NOT do something like FlowDistribution.objects.
# Use the player model!!!
class FlowDistribution(models.Model):
    path_assignments = models.ManyToManyField('PathFlowAssignment',
                                              related_name='flow_distribution')
    player = models.ForeignKey('Player')
    turn = models.ForeignKey('GameTurn', blank=True, null=True)

    def __unicode__(self):
        return 'user: ' + str(self.player) + ' turn: ' + str(self.turn.iteration)

    class Meta:
        unique_together = ['player', 'turn']


class LearningRate(models.Model):
    player = models.ForeignKey('Player')
    turn = models.ForeignKey('GameTurn', blank=True, null=True)
    learning_rate = models.FloatField(blank=True, null=True)

    def __unicode__(self):
        return 'user: ' + str(self.player) + ' turn: ' + str(self.turn.iteration) + ' ' + str(self.learning_rate)


class EdgeCost(models.Model):
    edge = models.ForeignKey('Edge')
    cost = models.FloatField(default=0.0)

    def __unicode__(self):
        return str(self.cost)


class GraphCost(models.Model):
    graph = models.ForeignKey('Graph')
    edge_costs = models.ManyToManyField('EdgeCost')


class Game(models.Model):
    name = models.TextField(primary_key=True)
    turns = models.ManyToManyField('GameTurn') # Previous turns
    current_turn = models.ForeignKey('GameTurn', related_name='current_turn', blank=True, null=True)
    graph = models.OneToOneField('Graph', blank=True, null=True)
    started = models.BooleanField(default=False)
    game_loop_time = models.DateTimeField(blank=True, null=True)
    stopped = models.BooleanField(default=False)
    edge_highlight = models.BooleanField(default=True)
    duration = models.IntegerField(default=30)
    single_slider_mode = models.BooleanField(default=False)
    currently_in_use = models.BooleanField(default=False)
    # thread_iteration = models.IntegerField(blank=True, null=True)

    def __unicode__(self):
        return self.name

    def __str__(self):
        return self.name
