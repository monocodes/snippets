# Environment variables in Python & Docker

- [Environment variables in Python \& Docker](#environment-variables-in-python--docker)
  - [Python](#python)
  - [Docker](#docker)
  - [Summary](#summary)

![img](https://miro.medium.com/v2/resize:fit:1400/1*cw4r2TQwzJnzRTqBReC49w@2x.jpeg)

Generated using OpenAI DALL·E 2.

Using environment variables is a useful way of providing inputs into programs. It can be used to:

- add configurations
- insert secret variables

These variables are frequently used when deploying applications with your cloud service provider and/or Docker. It is definitely something you should have knowledge of since it is used everywhere, regardless of programming language or system.

To list existing environment variables in bash, you can open a terminal and type:

```sh
printenv
```

To set an environment variable in bash, you simply type:

```sh
export MY_ENV_VARIABLE="MY VALUE"
```

To verify that it now exists, type:

```sh
echo $MY_ENV_VARIABLE
```

And “MY VALUE” should be printed.

## Python

To access these variables in Python we can use the `os` package. There are two ways to access them. Here I will use one of the variables I found on my system (MacBook, bash) when typing `printenv` (TERM_PROGRAM):

```py
import os

# first way
os.environ['TERM_PROGRAM']
# => 'Apple_Terminal'
# a non-existing variable will lead to error
os.environ["THIS_VARIABLE_DOESNT_EXIST"]
# => KeyError: 'THIS_VARIABLE_DOESNT_EXIST'

# second way
print(os.getenv("TERM_PROGRAM"))
# => 'Apple_Terminal'
# a non-existing variable will lead to None
print(os.getenv("THIS_VARIABLE_DOESNT_EXIST"))
# => None
# but you could also specify if you want it to return
# something else if the key does not exist
print(os.getenv("THIS_VARIABLE_DOESNT_EXIST", "Return this if it does not exist..."))
# => "Return this if it does not exist..."
```

Great, we know how to access the variables, but inserting variables through the terminal using `export KEY=VALUE` is rather inconvenient. Instead, we would like to have a way to change multiple variables easily and insert them into the software smoothly.

Enter *.env*-files. These files are handy for inserting env-variables by only changing a single file. Each line in the file will describe a variable to value-mapping, for instance:

```sh
VARIABLE1 = HELLO
VARIABLE2 = "WORLD"
VARIABLE3 = ${VARIABLE1} ${VARIABLE2}
```

Here the second variable was quoted, but the result will be the same whether you type with or without quotes. The third variable uses previously defined environment variables using ${<variable_name>}. All variables will by default be loaded as strings. The names for these files are usually “.env”. If we have multiple files we could add a prefix or suffix and switch between them. Now, imagine we have a file called .env with the content specified above. To insert these into Python locally, we can use the `python-dotenv` package. Start by installing it:

```sh
pip install python-dotenv
```

Then only a single function call is necessary to load the variables from the file:

```py

from dotenv import load_dotenv
import os

# by default .env will be loaded
load_dotenv()
# if we had another file called .env2
# we could load it using
# load_dotenv(".env2")

# now we can use os.getenv as before:
print(os.getenv("VARIABLE1"))
# => "HELLO"
print(os.getenv("VARIABLE2"))
# => "WORLD"
print(os.getenv("VARIABLE3"))
# => "HELLO WORLD"
```

**NOTE**: if you have secrets in a .env file, don’t forget to add it to .gitignore to avoid it from being pushed to git.

## Docker

When deploying applications docker is often used. With it, there are more appropriate options for inserting environment variables than using python-dotenv. Here I’m going to talk about local development. When you deploy your container(s) to the cloud the insertion of env-variables would depend on what provider and deployment option that is used.

I will use docker-compose here. While it is not necessary, I believe it’s a great tool regardless if you create one or multiple docker containers. For the demo project the following file structure is used:

![img](https://miro.medium.com/v2/resize:fit:1268/1*0uxobevVHNZXBcnOUlV4Tw.png)

Folder structure

There is a quite a few files, but they all contain very little code. In the docker file we have:

```dockerfile
FROM python:3.8-alpine
COPY app .
CMD python -u main.py
```

A python base-image is imported, here alpine because it is lightweight. The app folder is then copied and finally the python file, main.py, is run. In the .env file we have:

```sh
MY_SECRET_VARIABLE = "I'm batman!"
```

As described, the variable is “secret”, env-variables that are not secret can be hardcoded in the docker-compose file, which is shown below:

```yaml
version: '3'
services:
  my_component:
    # Here you can specify an env-file with variables
    # that can be used in the docker-container,
    # BUT these variables can not be used here in the
    # docker-compose using ${...} UNLESS it is a file named
    # ".env". This file (in the same directory) is always
    # loaded into the docker-compose, but not into the 
    # docker-containers unless the variables are mapped in the 
    # environment option below or using the env_file option here.
    env_file: .env
    container_name: my_component
    build:
      context: .
      dockerfile: Dockerfile
    environment: # specify the env-variables here
      # secret ones in .env file or system
      MY_SECRET_VARIABLE: ${MY_SECRET_VARIABLE}
      # and public ones can be hardcoded
      MY_PUBLIC_VARIABLE: Hello world
      # sometimes the console won't show print messages,
      # using PYTHONUNBUFFERED: 1 can fix this
      PYTHONUNBUFFERED: 1
```

Note the comment describing the difference between the **env_file** option and the **environment** option and using the filename **.env** specifically as opposed to something else.

Next, a .dockerignore file is added. This is to avoid adding the .env-file into the image since it might contain sensitive information. The content is thus only:

```yaml
.env
```

Finally, we have the main.py file that will be run. Here the environment variables are just printed:

```py
import os
import time

for k in ["MY_PUBLIC_VARIABLE", "MY_SECRET_VARIABLE"]:
    print(k, os.getenv(k))
```

To run everything the following expression is typed in the terminal:

```sh
docker-compose -f docker-compose.yml up --build
```

And the result is:

![img](https://miro.medium.com/v2/resize:fit:1136/1*cvtrleNkPlkJ6smCVbyJHA.png)

Results

## Summary

Environment variables are important because they are a common medium for injecting configurations into our software. While in this article Python was used, environment variables can be used with most programming languages. Good luck!
