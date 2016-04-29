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



def initiate_first_game():
    game = Game.objects.first()
    game.currently_in_use = True
    game.save()
    return

def switch_game():
    current_game = Game.objects.get(currently_in_use = True)
    EdgeCost.objects.all().delete()
    for turn in GameTurn.objects.filter(game=current_game):
        turn.delete()
        turn.save()
    FlowDistribution.objects.all().delete()
    GraphCost.objects.all().delete()
    PathFlowAssignment.objects.all().delete()
    cache.clear()
    next_game = Game.objects.filter(currently_in_use=False,started = False,stopped= False)[0]
    current_game.currently_in_use = False
    if not(current_game.stopped):
        current_game.stopped = True
    current_game.save()
    next_game.currently_in_use = True
    initial_turn = GameTurn()
    initial_turn.game = next_game
    initial_turn.iteration = 0
    initial_turn.save()
    next_game.current_turn = initial_turn
    next_game.save()
    assign_user_to_player_model()
    return