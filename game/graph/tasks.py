from __future__ import absolute_import

from datetime import datetime

from .models import *
from .utils import *
from .game_functions import *

from celery import shared_task


@shared_task
def game_force_next(game_name):
    game = Game.objects.get(name=game_name)

    if game.stopped:
        return

    iterate_next_turn(game)

    game.game_loop_time = datetime.now()
    game.save()
    async_res = game_force_next.apply_async((game_name,), countdown=duration)
