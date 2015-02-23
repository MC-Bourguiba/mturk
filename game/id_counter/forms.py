from django import forms

from .models import User


class UserIDForm(forms.Form):
    user_id = forms.CharField()

class UserForm(forms.ModelForm):
    class Meta:
        model = User
        exclude = ['logged_in', 'completed_task', 'entered_number']

class NumberForm(forms.Form):
    enter_number = forms.FloatField()
