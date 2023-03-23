---
title: python
categories:
  - software
  - guides
  - notes
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# python

## useful hints

### Python variables in docker

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

---

### Evaluate boolean environment variable in Python

1. Use `strtobool` function

    ```python
    from distutils.util import strtobool
    
    DEBUG = strtobool(os.getenv("DEBUG", "false"))
    ```

    > `dustutils` package may be deprecated in future

2. Use built-in method  
    Here anything but `True` will evaluate to False. DEBUG is False unless explicitly set to `True` in ENV

    ```python
    DEBUG = (os.getenv('DEBUG', 'False') == 'True')
    ```
