from math import exp, sqrt
from models import *
from ai import *


def hedge_Algorithm(losses_vector,previous_distributions,iteration, path_ids):
    lr= learning_rate(iteration)
    #ub = upper_bound(iteration)
    #hardcoded for debug purpose
    ub = 100
    next_distributions = dict()
    normalization_const = 0
    for id in path_ids:
        next_distributions[id]=exp_computation(lr,ub,float(losses_vector[id])*1000,float(previous_distributions[id]))
        normalization_const= normalization_const+ next_distributions[id]
    for id in path_ids:
        next_distributions[id]= next_distributions[id]/normalization_const
    return next_distributions

def learning_rate(iteration):
    lr = 1.0/sqrt(iteration)
    return lr


def upper_bound(iteration):
    return

def exp_computation(lr,ub,loss,pd):
    print-(lr*loss/ub)
    return pd*exp(-(lr*loss/ub))


def get_order_of_magnitude(number):
    return


def get_max_cost():
    users = User.objects.all()
    game = User.objects.first().player.game
    return game.name