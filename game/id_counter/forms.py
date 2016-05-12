from django import forms

from .models import User


class UserIDForm(forms.Form):
    user_id = forms.CharField()

    def is_alpha_num(self):
        return str(self.user_id).isalpha()

class UserForm(forms.ModelForm):
    class Meta:
        model = User
        exclude = ['logged_in', 'completed_task', 'entered_number']
        def is_alpha_num(self):
            return str(self.user.user_id).isalpha()

class NumberForm(forms.Form):
    enter_number = forms.FloatField()
