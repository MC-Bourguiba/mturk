# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('id_counter', '0005_user_completed_task'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='logged_in',
            field=models.BooleanField(default=True),
            preserve_default=True,
        ),
    ]
