---
title: python
categories:
  - software
  - guides
  - notes
  - code
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [install python](#install-python)
  - [macOS brew and pyenv](#macos-brew-and-pyenv)
  - [pyenv](#pyenv)
  - [uninstall python](#uninstall-python)
- [built-in functions and methods](#built-in-functions-and-methods)
  - [dir()](#dir)
- [python notes](#python-notes)
  - [Python variables in docker](#python-variables-in-docker)
  - [Evaluate boolean environment variable in Python](#evaluate-boolean-environment-variable-in-python)
  - [Import module from another directory or root directory](#import-module-from-another-directory-or-root-directory)
  - [Interacting with OS](#interacting-with-os)
  - [Break Long Lines in Python](#break-long-lines-in-python)
    - [Breaking Long Lines of Code in Python](#breaking-long-lines-of-code-in-python)
    - [How to Auto-Break Long Lines of Code in Python](#how-to-auto-break-long-lines-of-code-in-python)
    - [How to Break a String into Multiple Lines](#how-to-break-a-string-into-multiple-lines)
    - [Break a Function Arguments into Multiple Lines](#break-a-function-arguments-into-multiple-lines)
    - [Break a List into Multiple Lines](#break-a-list-into-multiple-lines)
    - [Break a Dictionary into Multiple Lines](#break-a-dictionary-into-multiple-lines)
    - [Break Mathematical Operations into Multiple Lines](#break-mathematical-operations-into-multiple-lines)
    - [Break Comparisons into Multiple Lines](#break-comparisons-into-multiple-lines)
    - [Conclusion](#conclusion)

## install python

### macOS brew and pyenv

1. First install [homebrew](../brew.md), **Xcode**, **Xcode Command Line Tools**

2. Install Xcode Command Line Tools

   ```sh
   xcode-select --install
   ```

3. Install pyenv

   ```sh
   brew install pyenv
   ```

4. Configure auto-activation of pyenv and penv-virtualenv.  
   In other words, to auto activate (and deactivate) virtualenvs upon entering (and leaving) directories that contain a pyenv’s `.python-version` file, you should have the following lines at the end of `~/.zshrc`:

   ```sh
   vim ~/.zshrc
   
   # Append to file
   if command -v pyenv 1>/dev/null 2>&1; then
     eval "$(pyenv init -)";
     eval "$(pyenv virtualenv-init -)"; 
   fi
   ```

   There is a downside to auto-activation, though. The auto-switch seems to slow zsh down quite a bit. For more information on this, read [#132](https://github.com/pyenv/pyenv-virtualenv/issues/132) and [#259](https://github.com/pyenv/pyenv-virtualenv/issues/259)

---

### pyenv

install peynv-virtualenv

```sh
brew install pyenv-virtualenv
```

list avalaible python packages

```sh
pyenv install -l
```

install needed python version

```sh
pyenv install 3.10.4
```

set global used python version

```sh
pyenv global 3.10.4
```

check pyenv installed python versions

```sh
pyenv versions
```

check what version is used in current session in current dir and how version set

```sh
pyenv version
```

create new virtual environment

```sh
pyenv virtualenv 3.10.5 virtualenv-name
```

specify python version in current dir  
don't forget to point **VS Code** to use this virtualenv

```sh
pyenv local virtualenv-name
pyenv local python-version-name

# check created file
cat .python-version
```

activate and deactivate pyenv version manually

```sh
pyenv activate name
pyenv deactivate name
```

uninstall pyenv python

```sh
pyenv uninstall python-version-name
pyenv uninstall virtualenv-name
```

force uninstall

```sh
pyenv uninstall -f virtualenv-name
```

---

### uninstall python

```sh
cd Library
sudo rm -rf Python
sudo rm -rf /Applications/Python
sudo rm -rf /Library/Frameworks/Python.framework
sudo rm -rf /usr/local/bin/python
```

**Remove Python symbolic links**

The symlinks referencing Python frameworks are in the `/usr/local/bin` directory. If you would like to see the broken symlinks, please use the following command.

1. become root

   ```sh
   sudo -i
   ```

2. check symlinks first

   ```sh
   ls -l /usr/local/bin | grep '../Library/Frameworks/Python.framework'
   ```

3. delete symlinks

   ```sh
   ls -l /usr/local/bin | grep '../Library/Frameworks/Python.framework' | awk '{print $9}' | tr -d @ | xargs rm
   ```

4. check symlinks again

   ```sh
   ls /usr/local/bin
   ```

---

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

## python notes

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

---

### Import module from another directory or root directory

**import sys**

example:

1. VS Code opened in directory 1

2. Script *script.py* you are working with located in directory *1/2/script.py*

3. Module that nedeed to be imported is located in root directory: *1/module.py*

4. To import function from module from directory 1 you need to write in your *script.py* the following lines:

   ```python
   import sys
   sys.path.append('')
   from module import func
   ```

---

### Interacting with OS

[FileNotFoundError: [Errno 2\] No such file or directory [duplicate]](https://stackoverflow.com/questions/22282760/filenotfounderror-errno-2-no-such-file-or-directory)

I am trying to open a CSV file but for some reason python cannot locate it.

Here is my code (it's just a simple code but I cannot solve the problem):

```py
import csv

with open('address.csv','r') as f:
    reader = csv.reader(f)
    for row in reader:
        print row
```

When you open a file with the name `address.csv`, you are telling the `open()` function that your file is in the current working directory. This is called a relative path.

To give you an idea of what that means, add this to your code:

```py
import os

cwd = os.getcwd()  # Get the current working directory (cwd)
files = os.listdir(cwd)  # Get all the files in that directory
print("Files in %r: %s" % (cwd, files))
```

That will print the current working directory along with all the files in it.

Another way to tell the `open()` function where your file is located is by using an absolute path, e.g.:

```py
f = open("/Users/foo/address.csv")
```

---

### [Break Long Lines in Python](https://www.codingem.com/python-how-to-break-long-lines/)

By [Artturi Jalli](https://www.codingem.com/author/artturijalli/)

Python supports implicit line continuation. This means you can break long lines of code.

For example, instead of this:

```python
math_students = ["Alice", "Bob", "Charlie", "David", "Emmanuel"]
```

You can write it like this:

```py
math_students = [
    "Alice",
    "Bob",
    "Charlie",
    "David",
    "Emmanuel"
]
```

As a matter of fact, you should limit all lines of code to[ a maximum of 79 characters](<https://www.python.org/dev/peps/pep-0008/#:~:text=limit> all lines to a maximum of 79 characters.).

Today, you are going to learn when and how to break long lines in Python.

#### Breaking Long Lines of Code in Python

Breaking lines increases the total number of lines of code. But at the same, it can drastically improve the readability of your code.

It is recommended not to have lines of code longer than 79 characters.

Python supports implicit line continuation. This means any expression inside the parenthesis, square brackets, or curly braces can be broken into multiple lines.

For example, here is a long **print()** function call is broken into multiple lines in a couple of ways:

```py
print("Alice", "Bob", "Charlie", "David", "Emmanuel",
      "Farao", "Gabriel", "Hilbert", "Isaac")

print(
    "Alice", "Bob", "Charlie",
    "David", "Emmanuel", "Farao",
    "Gabriel", "Hilbert", "Isaac"
)

print(
    "Alice",
    "Bob",
    "Charlie",
    "David",
    "Emmanuel",
    "Farao",
    "Gabriel",
    "Hilbert",
    "Isaac"
)
```

There are many ways you can break long lines in Python. You may want to check the [official style guide](https://www.python.org/dev/peps/pep-0008) that explains best practices more thoroughly.

Before jumping into examples, notice that there is a way to automatize the line-breaking process.

#### How to Auto-Break Long Lines of Code in Python

Popular code editors allow you install plugins that enforce code style guidelines.

A cool feature of these plugins is you can usually auto-format code. In other words, the plugin automatically takes care no line exceeds the 79 character “limit”.

For example, in VSCode it is possible to automatically [format code on save](https://dev.to/adamlombard/how-to-use-the-black-python-code-formatter-in-vscode-3lo0).

Next up, let’s see some examples when you may want to split expressions into multiple lines.

#### How to Break a String into Multiple Lines

To break a string to multiple lines, wrap each string in the new line inbetween a pair of double quotation marks.

For instance, you can do this:

```python
print(
    "This happens to be"
    " so long string that"
    " it may be a better idea"
    " to break the line not to"
    " extend it further to the right"
)
```

But you **cannot** do this:

```python
print(
    "This happens to be
    so long string that
    it may be a better idea
    to break the line not to
    extend it further to the right"
)
```

#### Break a Function Arguments into Multiple Lines

If your function takes a number of arguments that extends line of code far to the right, feel free to break the expression into multiple lines.

For example, instead of doing this:

```python
def example_function(first_number, second_number, third_number, fourth_number, fifth_number):
    pass
```

You can do this:

```python
def example_function(
    first_number,
    second_number,
    third_number,
    fourth_number,
    fifth_number
):
    pass
```

#### Break a List into Multiple Lines

For example, let’s create a 3×3 matrix using a [list](https://medium.com/codex/python-101-working-with-lists-df46ac8cfb9f):

```python
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
```

This is fine, but as you may know, a matrix is written in a table format. This makes it look more like a table of values.

To follow this convention in Python, you can split the matrix (the list of lists) into multiple lines:

```python
matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]
```

#### Break a Dictionary into Multiple Lines

Just like breaking a list declaration into multiple lines, you can do it with a dictionary.

For instance, instead of a long expression like this:

```python
student = {"name": "Alice", "graduated": False, "married": False, "age": 23, "hobbies": ["Jogging", "Gym", "Boxing"]}
```

Let’s split the dictionary into a bunch of lines to make it more understandable:

```python
student = {
    "name": "Alice",
    "graduated": False,
    "married": False,
    "age": 23,
    "hobbies": ["Jogging", "Gym", "Boxing"]
}
```

#### Break Mathematical Operations into Multiple Lines

To split a chain of binary operations, break the line before the operator. This makes the code more readable as the binary operators are not all over the place.

For example, instead of doing this:

```python
income = gross_wages + taxable_interest + (dividends - qualified_dividends) - ira_deduction - student_loan_interest
```

You can do this:

```python
income = (gross_wages
          + taxable_interest
          + (dividends - qualified_dividends)
          - ira_deduction
          - student_loan_interest)
```

This example is directly from the [PEP-0008 style guide](<https://www.python.org/dev/peps/pep-0008/#:~:text=continued> line appropriately.-,should a line break before or after a binary operator%3F,-For decades the).

#### Break Comparisons into Multiple Lines

Like any other expression, comparisons can also take some space. To avoid too long chains of comparisons, you can break the line.

For instance:

```python
if (is_rainy == True and
    is_hot == True and
    is_sunny == True and
    is_night == True):
    print("How is that possible...?")
```

#### Conclusion

Python’s implicit continuation makes it possible to break long expressions into multi-line expressions. This is useful for code readability.

To break an expression into multiple lines, wrap the expression around a set of parenthesis and break it down as you want.

If the expression is already in a set of parenthesis, square brackets, or curly braces, you can split it to multiple lines. This is true for example for lists, tuples, and dictionaries.

---
