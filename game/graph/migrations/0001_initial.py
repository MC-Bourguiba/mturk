# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.conf import settings
import uuidfield.fields


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Edge',
            fields=[
                ('edge_id', uuidfield.fields.UUIDField(primary_key=True, serialize=False, editable=False, max_length=32, blank=True, unique=True)),
                ('weight_function', models.TextField()),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='GameUser',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Graph',
            fields=[
                ('name', models.TextField(serialize=False, primary_key=True)),
                ('graph_ui', models.TextField()),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Node',
            fields=[
                ('node_id', uuidfield.fields.UUIDField(primary_key=True, serialize=False, editable=False, max_length=32, blank=True, unique=True)),
                ('ui_id', models.IntegerField()),
                ('graph', models.ForeignKey(to='graph.Graph')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.AddField(
            model_name='gameuser',
            name='destination_node',
            field=models.ForeignKey(related_name='destination_node', to='graph.Node', null=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='gameuser',
            name='start_node',
            field=models.ForeignKey(related_name='start_node', to='graph.Node', null=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='gameuser',
            name='user',
            field=models.OneToOneField(to=settings.AUTH_USER_MODEL),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='edge',
            name='from_node',
            field=models.ForeignKey(related_name='from_node', to='graph.Node'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='edge',
            name='graph',
            field=models.ForeignKey(to='graph.Graph'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='edge',
            name='to_node',
            field=models.ForeignKey(related_name='to_node', to='graph.Node'),
            preserve_default=True,
        ),
    ]
