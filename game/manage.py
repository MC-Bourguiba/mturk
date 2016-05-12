#!/usr/bin/env python
import os
import sys

if __name__ == "__main__":
    sys.path.append('app/game/game')
    os.environ["DJANGO_SETTINGS_MODULE"]= "game.settings"

    print sys.path
    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)
