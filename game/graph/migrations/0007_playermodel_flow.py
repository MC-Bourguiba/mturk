# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('graph', '0006_auto_20150327_0925'),
    ]

    operations = [
        migrations.AddField(
            model_name='playermodel',
            name='flow',
            field=models.FloatField(null=True, blank=True),
            preserve_default=True,
        ),
    ]
