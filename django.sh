### INSTALL DJANGO ------------------------------
# in venv
pip install django



### DJANGO-ADMIN --------------------------------
# start a new django project
# the "." in the end is mandatory!
django-admin startproject project-name .



### MANAGE.PY -----------------------------------

### CREATE DB -----------------------------------
# migrate = modify
# command creates default SQlite DB
python manage.py migrate


### RUN SERVER ----------------------------------
# start the server
python manage.py runserver 