from __future__ import absolute_import

from datetime import datetime

from .models import *
from .utils import *
from .game_functions import *
import os

from celery import shared_task

from django.core.cache import cache

import time
REDIS_URL = os.environ.get('REDISTOGO_URL', 'redis://localhost')


player_timeout = 60


@shared_task
def game_force_next(game_name):
    game = Game.objects.get(name=game_name)

    if game.stopped:
        return
    
    iterate_next_turn(game)

    game.game_loop_time = datetime.now()
    game.save()
    async_res = game_force_next.apply_async((game_name,), countdown=game.duration)


@shared_task
def change_player(game_name):
    game = Game.objects.get(name=game_name)

    for player in Player.objects.filter(game=game,superuser = False):
        # TODO: Switch to AI player here
        if not cache.get(player.user.username + '_ts'):
            cache.set(player.user.username + '_ai', True)
            player.is_a_bot = True
            player.save()

            continue

        timestamp = float(cache.get(player.user.username + '_ts'))
        current_ts = time.time()
        if current_ts - timestamp > player_timeout:
            cache.set(player.user.username + '_ai', True)
            player.is_a_bot = True
            player.save()
        else:
            cache.set(player.user.username + '_ai', False)
            player.is_a_bot = False
            player.save()

    change_player_res = change_player.apply_async((game_name,), countdown=10.0)
