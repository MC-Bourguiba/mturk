from models import *
import random
import logging
logger = logging.getLogger(__name__)

def assign_user_to_player_model():

    game = Game.objects.get(currently_in_use = True)
    players = Player.objects.filter(superuser = False)
    current_graph = game.graph
    pm_to_use = PlayerModel.objects.filter(graph=current_graph)
    admins = Player.objects.filter(superuser= True)

    for admin in admins:
        admin.game = game
        admin.in_use = True
        admin.save()


    for player in players:
            if not(player.player_model==None):
                if player.player_model.graph==current_graph:
                    pass

            player.game = game
            player.player_model = random.choice(pm_to_use)
            pm = player.player_model
            pm.in_use= True
            pm.shared_players+=1
            pm.historic_player=str(pm.historic_player)+str(player)
            player.save()
            from game_functions import create_default_distribution
            flow_distribution = create_default_distribution(pm, game, player)
            player.flow_distribution = flow_distribution
            flow_distribution.save()
            pm.save()
            player.save()

    if (Player.objects.filter(player_model__isnull=True,superuser=False).count()>0 )or( len(players)!=Player.objects.filter(player_model__graph=current_graph,superuser=False).count()) :
         assign_user_to_player_model()


    for pm in PlayerModel.objects.filter(graph=current_graph):
        if Player.objects.filter(player_model = pm).count() == 0:
           Path.objects.filter(player_model=pm).delete()
           pm.delete()

    return



def initiate_first_game():
    if(len(Game.objects.filter(currently_in_use = True))==0):
        game = Game(name='game')
        game.currently_in_use = True
        game.save()
        return
    else:
        return


def switch_game():
    try:
        logger.debug("do even switch broooo ???")
        current_game = Game.objects.get(currently_in_use = True)
        current_game.currently_in_use = False
        current_game.save()
        current_game.stopped = True
        current_game.save()
        next_game = Game.objects.filter(currently_in_use=False,started = False,stopped= False)[0]
        next_game.currently_in_use = True
        next_game.save()
        initial_turn = GameTurn(game_object=next_game)
        initial_turn.game = next_game
        initial_turn.iteration = 0
        initial_turn.save()
        next_game.current_turn = initial_turn
        next_game.save()
    except :
        print 'error occurred'
        logger.debug('error occurred')
    return







def generate_player_model(graph_name):
    graph = Graph.objects.get(name=graph_name)
    for i in range(1,4):
            player_model = PlayerModel(name=graph.name+'_PM'+str(i),graph=graph,flow=1.0)
            player_model.save()

    return

def assign_graphs_to_games():
    games_without_graphs = Game.objects.filter(graph__isnull = True)
    unusued_graphs = Graph.objects.all()
    #Assumes that we have at least as many graphs as games
    for graph, game in zip(unusued_graphs,games_without_graphs):
        game.graph= graph
        print (game)
        print (game.graph)
    return