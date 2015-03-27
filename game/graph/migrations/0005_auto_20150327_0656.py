# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('graph', '0004_auto_20150327_0652'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='playermodel',
            name='id',
        ),
        migrations.AddField(
            model_name='playermodel',
            name='name',
            field=models.TextField(default=b'2015-03-27 06:56:50.263885+00:00', serialize=False, primary_key=True),
            preserve_default=False,
        ),
    ]
