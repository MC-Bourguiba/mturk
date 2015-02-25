# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('graph', '0003_auto_20150225_0942'),
    ]

    operations = [
        migrations.AlterField(
            model_name='node',
            name='node_id',
            field=models.IntegerField(default=0),
            preserve_default=True,
        ),
    ]
