from __future__ import absolute_import

from graph.models import *
from graph.utils import *
from datetime import datetime

from celery import shared_task


duration = 30
async_res = None


@shared_task
def game_force_next(game_name):
    global async_res

    game = Game.objects.get(name=game_name)

    # Force turn completion
    if not is_turn_complete(game):
        players = Player.objects.filter(game=game)
        for player in players:
            player.completed_task = True
            # if not player.completed_task:
            #     return False

    print 'Forced next turn!!!'
    update_cost(game)
    iterate_next_turn(game)

    game.game_loop_started = datetime.now()
    game.save()
    async_res = game_force_next.apply_async((game_name,), countdown=duration)


# def add(x, y):
#     return x + y
