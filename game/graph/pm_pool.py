from models import *
from game_functions import *
import random

def assign_user_to_player_model():
    game = Game.objects.get(currently_in_use = True)
    players = Player.objects.filter(superuser = False)
    curent_graph = game.graph
    pm_to_use = PlayerModel.objects.filter(graph=curent_graph)

    for player in players:
        player.game = game
        player_model_ids = [pm.pk for pm in pm_to_use]
        player.player_model = random.choice(pm_to_use)
        pm = player.player_model
        pm.in_use= True
        player.save()
        flow_distribution = create_default_distribution(pm, game, player)
        player.flow_distribution = flow_distribution
        flow_distribution.save()
        pm.save()


    admins = Player.objects.filter(superuser= True)

    for admin in admins:
        admin.game = game
        admin.save()
    return
