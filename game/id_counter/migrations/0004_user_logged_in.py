# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('id_counter', '0003_auto_20150223_1058'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='logged_in',
            field=models.BooleanField(default=False),
            preserve_default=True,
        ),
    ]
