# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('graph', '0005_auto_20150327_0656'),
    ]

    operations = [
        migrations.AlterField(
            model_name='player',
            name='player_model',
            field=models.ForeignKey(blank=True, to='graph.PlayerModel', null=True),
            preserve_default=True,
        ),
    ]
