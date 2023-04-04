---
title: python
categories:
  - software
  - guides
  - notes
  - code
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# python

- [python](#python)
  - [built-in functions and methods](#built-in-functions-and-methods)
    - [dir()](#dir)
  - [useful hints](#useful-hints)
    - [Python variables in docker](#python-variables-in-docker)
    - [Evaluate boolean environment variable in Python](#evaluate-boolean-environment-variable-in-python)

## built-in functions and methods

### dir()

The `dir()` function returns all properties and methods of the specified object, without the values.

```python
# Examples

# int
x = 2
print(dir(x))
# Output
['__abs__', '__add__', '__and__', '__bool__', '__ceil__', '__class__', '__delattr__', '__dir__', '__divmod__', '__doc__', '__eq__', '__float__', '__floor__', '__floordiv__', '__format__', '__ge__', '__getattribute__', '__getnewargs__', '__gt__', '__hash__', '__index__', '__init__', '__init_subclass__', '__int__', '__invert__', '__le__', '__lshift__', '__lt__', '__mod__', '__mul__', '__ne__', '__neg__', '__new__', '__or__', '__pos__', '__pow__', '__radd__', '__rand__', '__rdivmod__', '__reduce__', '__reduce_ex__', '__repr__', '__rfloordiv__', '__rlshift__', '__rmod__', '__rmul__', '__ror__', '__round__', '__rpow__', '__rrshift__', '__rshift__', '__rsub__', '__rtruediv__', '__rxor__', '__setattr__', '__sizeof__', '__str__', '__sub__', '__subclasshook__', '__truediv__', '__trunc__', '__xor__', 'as_integer_ratio', 'bit_count', 'bit_length', 'conjugate', 'denominator', 'from_bytes', 'imag', 'numerator', 'real', 'to_bytes']

# str
message = "Hello World!"
print(dir(message))
# or
print(dir(""))
# Output
['__add__', '__class__', '__contains__', '__delattr__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__getitem__', '__getnewargs__', '__gt__', '__hash__', '__init__', '__init_subclass__', '__iter__', '__le__', '__len__', '__lt__', '__mod__', '__mul__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__rmod__', '__rmul__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', 'capitalize', 'casefold', 'center', 'count', 'encode', 'endswith', 'expandtabs', 'find', 'format', 'format_map', 'index', 'isalnum', 'isalpha', 'isascii', 'isdecimal', 'isdigit', 'isidentifier', 'islower', 'isnumeric', 'isprintable', 'isspace', 'istitle', 'isupper', 'join', 'ljust', 'lower', 'lstrip', 'maketrans', 'partition', 'removeprefix', 'removesuffix', 'replace', 'rfind', 'rindex', 'rjust', 'rpartition', 'rsplit', 'rstrip', 'split', 'splitlines', 'startswith', 'strip', 'swapcase', 'title', 'translate', 'upper', 'zfill']

# list
print(dir([]))
# Output
['__add__', '__class__', '__class_getitem__', '__contains__', '__delattr__', '__delitem__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__getitem__', '__gt__', '__hash__', '__iadd__', '__imul__', '__init__', '__init_subclass__', '__iter__', '__le__', '__len__', '__lt__', '__mul__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__reversed__', '__rmul__', '__setattr__', '__setitem__', '__sizeof__', '__str__', '__subclasshook__', 'append', 'clear', 'copy', 'count', 'extend', 'index', 'insert', 'pop', 'remove', 'reverse', 'sort']
```

---

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
