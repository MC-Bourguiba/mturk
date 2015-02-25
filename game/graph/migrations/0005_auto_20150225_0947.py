# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('graph', '0004_auto_20150225_0945'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='node',
            name='id',
        ),
        migrations.AlterField(
            model_name='node',
            name='node_id',
            field=models.IntegerField(serialize=False, primary_key=True),
            preserve_default=True,
        ),
    ]
