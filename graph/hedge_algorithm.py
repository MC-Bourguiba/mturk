from math import exp, sqrt
from models import *



def hedge_Algorithm(losses_vector,previous_distributions,iteration, path_idx):
    lr= learning_rate(iteration)
    #ub = upper_bound(iteration)
    #hardcoded for debug purpose
    ub = 1
    next_distributions = dict()
    normalization_const = 0
    for id in path_idx:
        next_distributions[id]=exp_computation(lr,ub,float(losses_vector[id]),float(previous_distributions[id]))
        normalization_const= normalization_const+ next_distributions[id]
    for id in path_idx:
        next_distributions[id]= next_distributions[id]/normalization_const
    return next_distributions

def learning_rate(iteration):
    lr = 1.0/sqrt(iteration)
    return lr



def exp_computation(lr,ub,loss,pd):
    print-(lr*loss/ub)
    return pd*exp(-(lr*loss/ub))




