# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('id_counter', '0007_user_entered_number'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='entered_number',
            field=models.FloatField(null=True, blank=True),
            preserve_default=True,
        ),
    ]
