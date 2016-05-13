from django.test import TestCase
from django.contrib.auth.models import User

from .models import *
from .game_functions import *

from django.core.cache import cache


class EmptyGameTemplate(TestCase):

    fixtures = ['fixtures/tests/create_account/graph_pm.json']

    def setUp(self):
        cache.clear()
        self.u1 = User.objects.create(username='u1')
        self.u1.save()
        self.g1 = Game.objects.all()[0]
        self.pm1 = PlayerModel.objects.get(name='m1')


class CreateAccountTest(EmptyGameTemplate):

    def test_create_new_player(self):
        response = create_new_player(self.u1, self.g1)
        self.assertTrue(response)

        p1 = Player.objects.get(user__username='u1')
        self.assertIsNotNone(p1)


class GameTemplate(TestCase):

    fixtures = ['fixtures/tests/game_template/graph.json',
                'fixtures/tests/game_template/player.json']

    def setUp(self):
        self.path1_allocation = [0.1, 0.5, 0.3, 0.5]
        self.path2_allocation = [0.1, 0.5]
        self.path1_ids = [1, 2, 3, 4]
        self.path2_ids = [5, 6]
        self.u1 = User.objects.get(username='u1')
        self.u2 = User.objects.get(username='u2')
        self.p1 = Player.objects.get(user__username='u1')
        self.p2 = Player.objects.get(user__username='u2')
        self.g1 = Game.objects.all()[0]
        self.pm1 = PlayerModel.objects.all()[0]


class GameFunctionsTest(GameTemplate):

    def setUp(self):
        super(GameFunctionsTest, self).setUp()
        self.g1.started = True
        self.g1.save()


    def test_default_distribution(self):
        player = Player(user=self.u1)
        fd = create_default_distribution(self.pm1, self.g1, self.u1.username, player)
        pas = fd.path_assignments.all()
        for pa in pas:
            self.assertEquals(pa.flow, 1.0 / len(pas))


    # Make sure that the normalization doesn't screw up if we "clone" a flow distribution
    def test_create_flow_distribution_normalization(self):
        fd1 = create_flow_distribution(self.g1, self.u1.username, self.p1,
                                       self.path1_allocation, self.path1_ids,
                                       self.g1.current_turn)

        allocation = []
        path_ids = []

        for pfa in fd1.path_assignments.all():
            path_ids.append(pfa.path.id)
            allocation.append(pfa.flow)

        new_turn = GameTurn(iteration=self.g1.current_turn.iteration+1)

        fd2 = create_flow_distribution(self.g1, self.u1.username, self.p1, allocation,
                                       path_ids, new_turn)

        for pfa in fd1.path_assignments.all():
            index_of = path_ids.index(pfa.path.id)
            self.assertEquals(pfa.flow, allocation[index_of])


    def test_calculate_edge_flow(self):
        # TODO: TEST THIS!!! calculate_edge_flow in utils.py
        pass


class IterateTurnTest(GameFunctionsTest):

    def test_iterate_next_turn_count(self):
        self.assertEquals(self.g1.current_turn.iteration, 0)
        iterate_next_turn(self.g1)
        self.assertEquals(self.g1.current_turn.iteration, 1)

        iterate_next_turn(self.g1)
        iterate_next_turn(self.g1)

        self.assertEquals(self.g1.current_turn.iteration, 3)


    def test_next_turn_flow_distribution(self):
        self.assertEquals(self.g1.current_turn.iteration, 0)

        prev_iteration = self.g1.current_turn.iteration

        prev_fds = []
        for player in Player.objects.all():
            fd1 = FlowDistribution.objects.get(turn=self.g1.current_turn,
                                               player=player)

        iterate_next_turn(self.g1)

        self.assertEquals(self.g1.current_turn.iteration, 1)

        iterate_next_turn(self.g1)
