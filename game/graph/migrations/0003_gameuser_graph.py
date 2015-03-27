# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('graph', '0002_auto_20150327_0159'),
    ]

    operations = [
        migrations.AddField(
            model_name='gameuser',
            name='graph',
            field=models.ForeignKey(blank=True, to='graph.Graph', null=True),
            preserve_default=True,
        ),
    ]
