# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('graph', '0007_playermodel_flow'),
    ]

    operations = [
        migrations.AddField(
            model_name='playermodel',
            name='in_use',
            field=models.BooleanField(default=False),
            preserve_default=True,
        ),
    ]
