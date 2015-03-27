# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('graph', '0003_gameuser_graph'),
    ]

    operations = [
        migrations.CreateModel(
            name='Player',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='PlayerModel',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('destination_node', models.ForeignKey(related_name='destination_node', blank=True, to='graph.Node', null=True)),
                ('graph', models.ForeignKey(blank=True, to='graph.Graph', null=True)),
                ('start_node', models.ForeignKey(related_name='start_node', blank=True, to='graph.Node', null=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.RemoveField(
            model_name='gameuser',
            name='destination_node',
        ),
        migrations.RemoveField(
            model_name='gameuser',
            name='graph',
        ),
        migrations.RemoveField(
            model_name='gameuser',
            name='start_node',
        ),
        migrations.RemoveField(
            model_name='gameuser',
            name='user',
        ),
        migrations.DeleteModel(
            name='GameUser',
        ),
        migrations.AddField(
            model_name='player',
            name='player_model',
            field=models.OneToOneField(null=True, blank=True, to='graph.PlayerModel'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='player',
            name='user',
            field=models.OneToOneField(to=settings.AUTH_USER_MODEL),
            preserve_default=True,
        ),
    ]
