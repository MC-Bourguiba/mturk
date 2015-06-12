from __future__ import absolute_import

from datetime import datetime

from .models import *
from .utils import *
from .game_functions import *

from celery import shared_task


async_res = None


@shared_task
def game_force_next(game_name):
    global async_res

    game = Game.objects.get(name=game_name)

    if game.stopped:
        return

    force_complete_turn(game)
    iterate_next_turn(game)

    game.game_loop_time = datetime.now()
    game.save()
    async_res = game_force_next.apply_async((game_name,), countdown=duration)


# def add(x, y):
#     return x + y
