from django.shortcuts import render

from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect, JsonResponse
from django.template import RequestContext, loader
from django.template.loader import render_to_string

from django.core.paginator import Paginator, PageNotAnInteger, EmptyPage
from django.db.models.fields.files import FieldFile
from django.views.generic import FormView
from django.views.generic.base import TemplateView
from django.contrib import messages

from django.core.files import File

from utils import generate_graph, sanitize_graph_json, generate_paths
from models import Graph, Node, Edge

import simplejson as json


def index(request):
    template = 'graph/graph.djhtml'
    graphs = map(lambda g: g.name, Graph.objects.all())
    context = dict()
    context['graph_names'] = graphs
    return render(request, template, context)


def editor(request):
    template = 'graph/editor.djhtml'
    context = dict()
    return render(request, template, context)


def create_graph(request):
    graph_dict = json.loads(request.body)
    generate_graph(graph_dict)
    to_json = dict()
    return JsonResponse(to_json)


def load_graph(request):
    g_name = request.GET.dict()['name']
    graph = Graph.objects.get(name=g_name)
    response = dict()
    response['graph_ui'] = json.dumps(sanitize_graph_json(json.loads(graph.graph_ui)))
    last_node_id = None
    for node in json.loads(graph.graph_ui)['nodes']:
        last_node_id = max(node['id'], last_node_id)
    response['last_node_id'] = last_node_id
    return JsonResponse(response)


# Need source and destination to generate possible paths.
def generate_all_paths(request):
    get_dict = request.GET.dict()
    paths = generate_paths(get_dict['graph'], int(get_dict['source']),
                           int(get_dict['destination']))
    path_idxs = range(len(paths))
    html_dict = {'path_idxs': path_idxs}
    html = render_to_string('graph/path_display_list.djhtml', html_dict)
    response = dict()
    response['html'] = html
    response['paths'] = paths
    return JsonResponse(response)
