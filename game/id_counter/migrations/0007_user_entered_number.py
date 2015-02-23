# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('id_counter', '0006_auto_20150223_1243'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='entered_number',
            field=models.IntegerField(null=True, blank=True),
            preserve_default=True,
        ),
    ]
