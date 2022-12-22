### INSTALL DJANGO ------------------------------
# in venv
pip install django



### DJANGO-ADMIN --------------------------------
# start a new django project
# the "." in the end is mandatory!
# no hyphens "-" are allowed, use underscores "_" instead
django-admin startproject project-name .



### MANAGE.PY -----------------------------------

### RUN SERVER & START APP ----------------------
# start the server
python manage.py runserver

# with specifying the listening port (without - default is 8000)
python manage.py runserver port-number


# start the app
# app-name here must not be the same project-name as in startproject command
python manage.py startapp app-name


### MODIFY DB -----------------------------------
### CREATE DB ###
# migrate = modify
# command creates default SQlite DB or modifies db when you made some changes
# in config files
python manage.py migrate

# modify db to use new model or app
python manage.py makemigrations app-name
python manage.py migrate


### DJANGO SHELL --------------------------------
# enter the django shell
python manage.py shell


### SUPERUSER -----------------------------------
# create superuser
python manage.py createsuperuser

# change user password
python manage.py changepassword username

# change username
python manage.py shell
from django.contrib.auth.models import User
user = User.objects.get(username='username') #or email=<email>
user.first_name = 'first_name'
user.last_name = 'last_name'
user.username = 'username' #make sure it is unique
user.save()



### NOTES ---------------------------------------
# model fields
"""
To see the different kinds of fields you can use in a model, see the Django Model Field Reference at https://docs.djangoproject.com/en/2.2/ref/models/fields/. You won’t need all the information right now, but it will be extremely useful when you’re developing your own apps.
"""

# security, sensitive information
"""
Some sensitive information can be hidden from a site’s administrators. For example, Django doesn’t store the password you enter; instead, it stores a string derived from the password, called a hash. Each time you enter your password, Django hashes your entry and compares it to the stored hash. If the two hashes match, you’re authenticated. By requiring hashes to match, if an attacker gains access to a site’s database, they’ll be able to read its stored hashes but not the passwords. When a site is set up properly, it’s almost impossible to get the original passwords from the hashes.
"""

# restart the django shell everytime you modify models.py
"""
Each time you modify your models, you’ll need to restart the shell to see the effects of those changes.
"""

# 18-3. The Django API
"""
When you write code to access the data in your project, you’re writing a query. Skim through the documentation for querying your data at https://docs.djangoproject.com/en/2.2/topics/db/queries/, https://docs.djangoproject.com/en/4.1/topics/db/queries/. Much of what you see will look new to you, but it will be very useful as you start to work on your own projects.
"""