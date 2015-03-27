# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('graph', '0009_auto_20150327_1029'),
    ]

    operations = [
        migrations.RenameField(
            model_name='edge',
            old_name='weight_function',
            new_name='cost_function',
        ),
    ]
