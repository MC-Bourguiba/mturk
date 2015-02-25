# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import uuidfield.fields


class Migration(migrations.Migration):

    dependencies = [
        ('graph', '0002_auto_20150225_0938'),
    ]

    operations = [
        migrations.AlterField(
            model_name='node',
            name='node_id',
            field=uuidfield.fields.UUIDField(unique=True, max_length=32, editable=False, blank=True),
            preserve_default=True,
        ),
    ]
