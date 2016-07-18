from __future__ import absolute_import

from datetime import datetime

from .models import *
from .utils import *

import os

from celery import shared_task

from django.core.cache import cache

import time


player_timeout = 6
#check max_iteration in views.py as well
max_iteration = 25

@shared_task
def game_force_next(game_name):
    global max_iteration
    game = Game.objects.get(name=game_name)

    if game.stopped:
        return
    from .game_functions import iterate_next_turn
    iterate_next_turn(game)

    game.game_loop_time = datetime.now()
    game.save()
    if game.current_turn.iteration == max_iteration and game.started and not(game.stopped):
            from graph.pm_pool import switch_game,assign_user_to_player_model
            from graph.views import  set_waiting_time_server, last_game
            if not(last_game()):
                switch_game()
                assign_user_to_player_model()
                logger.debug('cleaning cache')
                for user in User.objects.all():
                    cache.delete(get_hash(user.username) + 'allocation')
                    cache.delete(get_hash(user.username) + 'path_ids')
                set_waiting_time_server()
                waiting_countdown_server()
            else:
                game.stopped=True
                game.save()
                return
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




@shared_task
def waiting_countdown_server():
    game = Game.objects.get(currently_in_use=True)
    if game.started:
        return
    val = int (cache.get("waiting_time"))
    val = val-1
    cache.set("waiting_time",val)
    response = dict()
    if (cache.get("waiting_time")<=0):
        for user in User.objects.all():
                    cache.delete(get_hash(user.username) + 'allocation')
                    cache.delete(get_hash(user.username) + 'path_ids')
        from graph.views import start_game_server
        start_game_server()
        return
    if(cache.get("waiting_time")>0):
        waiting_countdown_server.apply_async((), countdown=1.0)
    response['ping']=val
    return response

@shared_task
def compute_total_costs_for_all_players():
    game = Game.objects.get(currently_in_use=True)
    if not(game.started):
        return

    t1  = int(round(time.time() * 1000))
    players = Player.objects.filter(superuser=False)
    iteration=game.current_turn.iteration-1
    for player in players:
        path_ids = list(Path.objects.filter(player_model=player.player_model).values_list('id', flat=True))
        path_idxs = range(len(path_ids))
      
        paths = dict()
        for idx, p_id in zip(path_idxs, path_ids):
            path = Path.objects.get(id=p_id)
            paths[idx] = list(path.edges.values_list('edge_id', flat=True))


            for turn in game.turns.filter(iteration=iteration):
                cache_key_t_cost = str(turn.iteration) + game.name + "get_previous_cost" + str(player)+ "t_cost"+str(idx)
                cache_key_flow = str(turn.iteration) + game.name + "get_previous_flow" + str(player)+ "flow"+str(idx)
                cache_key_total = str(turn.iteration) + game.name + "get_previous_total" + str(player) + "total"+str(idx)
                
              
                e_costs = turn.graph_cost.edge_costs
                t_cost = 0
                for e in path.edges.all():
                    t_cost += e_costs.get(edge=e).cost
                cache.set(cache_key_t_cost,t_cost)


                
                
                flow_distribution = FlowDistribution.objects.filter(turn=turn, player=player,game=game)[0]
                flow = flow_distribution.path_assignments.filter(path=path)[0].flow
                cache.set(cache_key_flow,flow)


                if(PathTotalFlowAndCosts.objects.filter(path=path,game=game,iteration=turn.iteration).count()==0):
                    try:
                        path_cost_per_iteration = PathTotalFlowAndCosts(path=path,game=game,iteration=turn.iteration,total_cost=t_cost)
                        path_cost_per_iteration.save()
                    except:
                        logger.debug("problem with saving PathTotalFlowAndCosts")
                        continue
                cache.set(cache_key_total,t_cost*flow)
            
            """Turn here is an integer !!! """
            if iteration<0:
                compute_total_costs_for_all_players.apply_async((), countdown=game.duration/10)
                return
            if iteration == 0 :
                first_turn= game.turns.first()
                first_turn.game_object=game
                first_turn.save()
            cache_key_total = str(iteration) + game.name + "get_previous_total" + str(player) + "total"+str(idx)
            path_cost_per_iteration = PathTotalFlowAndCosts.objects.get(path=path,game=game,iteration=iteration)
            cache.set(cache_key_total,flow*path_cost_per_iteration.total_cost)
    t2 = int(round(time.time() * 1000))
    logger.debug("total cost time : "+str(t2-t1))
              
    compute_total_costs_for_all_players.apply_async((), countdown=game.duration/10)



 





