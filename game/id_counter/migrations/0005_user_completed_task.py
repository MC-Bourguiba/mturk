# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('id_counter', '0004_user_logged_in'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='completed_task',
            field=models.BooleanField(default=False),
            preserve_default=True,
        ),
    ]
