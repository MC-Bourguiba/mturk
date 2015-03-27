# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('graph', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='gameuser',
            name='destination_node',
            field=models.ForeignKey(related_name='destination_node', blank=True, to='graph.Node', null=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='gameuser',
            name='start_node',
            field=models.ForeignKey(related_name='start_node', blank=True, to='graph.Node', null=True),
            preserve_default=True,
        ),
    ]
