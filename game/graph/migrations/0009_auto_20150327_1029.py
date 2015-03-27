# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('graph', '0008_playermodel_in_use'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='playermodel',
            options={'ordering': ['name']},
        ),
        migrations.AlterField(
            model_name='edge',
            name='weight_function',
            field=models.TextField(default=b'x'),
            preserve_default=True,
        ),
    ]
