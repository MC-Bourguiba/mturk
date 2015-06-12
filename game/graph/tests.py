from django.test import TestCase
from django.contrib.auth.models import User

from .models import *
from .game_functions import *


class EmptyGameTemplate(TestCase):

    fixtures = ['fixtures/create_account/graph_pm.json']

    def setUp(self):
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


    def test_default_distribution(self):
        fd = create_default_distribution(self.pm1, self.g1, self.u1.username)
        pas = fd.path_assignments.all()
        for pa in pas:
            self.assertEquals(pa.flow, 1.0 / len(pas))


class GameTemplate(TestCase):

    fixtures = ['fixtures/game_template/graph.json',
                'fixtures/game_template/player.json']

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


class GameFlowTest(GameTemplate):

    def setUp(self):
        super(GameFlowTest, self).setUp()
        self.g1.started = True
        self.g1.save()


class SubmitDistributionTest(GameFlowTest):


    def test_submission_turn_completed(self):
        self.assertTrue(self.g1.started)

        update_game(self.u1, self.path1_allocation,
                    self.path1_ids, False)

        update_game(self.u2, self.path2_allocation,
                    self.path2_ids, False)

        self.assertTrue(is_turn_complete(self.g1))


    def test_submission_turn_partial_temporary(self):
        self.assertTrue(self.g1.started)

        update_game(self.u1, self.path1_allocation,
                    self.path1_ids, True)

        update_game(self.u2, self.path2_allocation,
                    self.path2_ids, False)

        self.assertFalse(is_turn_complete(self.g1))


    def test_multiple_temporary_submission(self):
        # Test that the flow distribution is discarded after another update

        self.assertTrue(self.g1.started)

        update_game(self.u1, self.path1_allocation,
                    self.path1_ids, True)

        update_game(self.u2, self.path2_allocation,
                    self.path2_ids, False)

        num = len(FlowDistribution.objects.all())

        self.path1_allocation[0] = 0.93

        update_game(self.u1, self.path1_allocation,
                    self.path1_ids, False)

        self.assertEquals(num, len(FlowDistribution.objects.all()))

        update_game(self.u1, self.path1_allocation,
                    self.path1_ids, True)

        self.assertEquals(num, len(FlowDistribution.objects.all()))



class IterateTurnTest(GameFlowTest):

    def test_iterate_next_turn_count(self):
        self.assertEquals(self.g1.current_turn.iteration, 0)
        iterate_next_turn(self.g1)
        self.assertEquals(self.g1.current_turn.iteration, 1)

        iterate_next_turn(self.g1)
        iterate_next_turn(self.g1)

        self.assertEquals(self.g1.current_turn.iteration, 3)


class GameStateTest(GameFlowTest):


    def test_turn_not_iterated(self):

        self.assertEquals(self.g1.current_turn.iteration, 0)

        update_game(self.u1, self.path1_allocation,
                    self.path1_ids, True)

        update_game(self.u2, self.path2_allocation,
                    self.path2_ids, False)

        update_game_state(self.g1)

        self.assertEquals(self.g1.current_turn.iteration, 0)



    def test_turn_iterated(self):

        self.assertEquals(self.g1.current_turn.iteration, 0)

        update_game(self.u1, self.path1_allocation,
                    self.path1_ids, False)

        update_game(self.u2, self.path2_allocation,
                    self.path2_ids, False)

        update_game_state(self.g1)

        self.assertEquals(self.g1.current_turn.iteration, 1)


    def test_force_complete_turn(self):
        players = Player.objects.filter(game=self.g1).exclude(user__username=root_username)
        for player in players:
            self.assertFalse(player.completed_task)

        self.assertFalse(is_turn_complete(self.g1))

        force_complete_turn(self.g1)

        players = Player.objects.filter(game=self.g1).exclude(user__username=root_username)
        for player in players:
            self.assertTrue(player.completed_task)
