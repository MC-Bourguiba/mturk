from django.shortcuts import render

from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect, JsonResponse
from django.template import RequestContext, loader

from django.core.paginator import Paginator, PageNotAnInteger, EmptyPage
from django.db.models.fields.files import FieldFile
from django.views.generic import FormView
from django.views.generic.base import TemplateView
from django.contrib import messages

from django.core.files import File

from utils import generate_graph, sanitize_graph_json
from models import Graph, Node, Edge

import simplejson as json


def index(request):
    template = 'graph/index.djhtml'
    context = dict()
    return render(request, template, context)


def editor(request):
    template = 'graph/editor.djhtml'
    context = dict()
    return render(request, template, context)


def create_graph(request):
    # print json.loads(request.body)
    graph_dict = json.loads(request.body)
    generate_graph(graph_dict)
    # with open('request.txt', 'w') as f:
    #     my_file = File(f)
    #     my_file.write(str(request))
    to_json = dict()
    return JsonResponse(to_json)


def load_graph(request):
    g_name = request.GET.dict()['name']
    print g_name
    graph = Graph.objects.get(name=g_name)
    # graph = Graph.objects.get(name=g_name)
    response = dict()
    response['graph_ui'] = json.dumps(sanitize_graph_json(json.loads(graph.graph_ui)))
    print response
    last_node_id = None
    for node in json.loads(graph.graph_ui)['nodes']:
        last_node_id = max(node['id'], last_node_id)
    response['last_node_id'] = last_node_id
    return JsonResponse(response)
