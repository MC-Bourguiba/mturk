from django.shortcuts import render

from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect, JsonResponse
from django.template import RequestContext, loader

from django.core.paginator import Paginator, PageNotAnInteger, EmptyPage
from django.db.models.fields.files import FieldFile
from django.views.generic import FormView
from django.views.generic.base import TemplateView
from django.contrib import messages

from utils import generate_graph

import simplejson


def index(request):
    template = 'graph/index.djhtml'
    context = dict()
    return render(request, template, context)


def editor(request):
    template = 'graph/editor.djhtml'
    context = dict()
    return render(request, template, context)


def create_graph(request):
    print request
    generate_graph(request)
    print 'Generating graph'
    to_json = dict()
    return JsonResponse(to_json)
