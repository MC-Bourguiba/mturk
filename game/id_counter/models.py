from django.db import models



class User(models.Model):
    user_id = models.CharField(max_length=15, primary_key=True)
    logged_in = models.BooleanField(default=True)
    completed_task = models.BooleanField(default=False)
    entered_number = models.FloatField(null=True, blank=True)

    def __unicode__(self):
        return self.user_id

