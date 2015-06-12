from django.contrib.auth.models import User

from datetime import timedelta
from datetime import datetime

from utils import *
from models import *


from django.core.cache import cache


def create_new_player(user, game):
    success = False

    if user.username != root_username:

        pms = PlayerModel.objects.filter(in_use=False, graph__isnull=False)

        if pms:
            player = Player(user=user)
            # player.user = user
            player.game = game

            pm = PlayerModel.objects.filter(in_use=False, graph__isnull=False)[:1].get()
            pm.in_use = True
            flow_distribution = create_default_distribution(pm, game, user.username)
            player.flow_distribution = flow_distribution
            player.player_model = pm
            flow_distribution.save()
            pm.save()

            player.save()

            success = True

    return success


def update_game_state(game):

    secs_left = duration

    if game.game_loop_time:
        # print 'Calculating time left'
        # if True:
        datetime_started = game.game_loop_time
        # print 'datetime_started', datetime_started
        es_started = int(datetime_started.strftime("%s"))
        secs_now = int(datetime.now().strftime("%s"))
        # print 'datetime_now', datetime.now()
        secs_left = (es_started + duration) - secs_now

    if is_turn_complete(game):
        iterate_next_turn(game)


    cache.set('time_left', secs_left)

    # return secs_left


def force_complete_turn(game):
    if not is_turn_complete(game):
        players = Player.objects.filter(game=game).exclude(user__username=root_username)
        for player in players:
            player.completed_task = True
            player.save()
