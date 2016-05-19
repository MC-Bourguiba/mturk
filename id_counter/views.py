from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect
from django.template import RequestContext, loader

from django.core.paginator import Paginator, PageNotAnInteger, EmptyPage
from django.db.models.fields.files import FieldFile
from django.views.generic import FormView
from django.views.generic.base import TemplateView
from django.contrib import messages
from django.views.decorators.clickjacking import xframe_options_exempt

from .forms import UserForm, NumberForm
from models import User


@xframe_options_exempt
def reset(request):
    if 'user_id' in request.session:
        for user in User.objects.all():
            user.entered_number = None
            user.completed_task = False
            user.save()
        return HttpResponseRedirect('/id_counter/game')

    return HttpResponseRedirect('/id_counter')

@xframe_options_exempt
def logout(request):
    if 'user_id' in request.session:
        user = User.objects.get(user_id=request.session['user_id'])
        user.logged_in = False
        user.save()
    del request.session['user_id']
    return HttpResponseRedirect('/id_counter')

@xframe_options_exempt
def login(request):

    if request.method == 'POST':
        form = UserForm(request.POST or None)
        if form.is_valid():
            user, created = User.objects.get_or_create(**form.cleaned_data)
        else:
            user = User.objects.get(user_id=request.POST['user_id'])
            user.logged_in = True
            user.save()
        request.session['user_id'] = user.user_id
        request.session.modified = True
        return HttpResponseRedirect('/id_counter/game')


    template = 'id_counter/login.djhtml'
    form = UserForm(request.POST or None)
    context = {'form': form}

    return render(request, template, context)

@xframe_options_exempt
def game(request):
    print request

    user = User.objects.get(user_id=request.session['user_id'])

    if request.method == 'POST':
        form = NumberForm(request.POST or None)
        if form.is_valid():
            user.entered_number = request.POST['enter_number']
            user.completed_task = True
            user.save()
            return HttpResponseRedirect('/id_counter/game')

    template = 'id_counter/game.djhtml'

    context = dict()

    context['user_id'] = user.user_id

    all_completed = True
    total = 0.0
    for user in User.objects.filter(logged_in=True):
        if not user.completed_task:
            all_completed = False
            break
        if user.entered_number:
            total += user.entered_number


    context['number_form'] = NumberForm()
    context['all_completed'] = all_completed
    context['total'] = total
    context['user_finished'] = user.completed_task
    context['users_finished'] = User.objects.filter(completed_task=True)
    context['users'] = User.objects.filter(logged_in=True)
    return render(request, template, context)
