### Python useful commands ----------------------



### IMPORT SYS ----------------------------------
### Question ###
# How to import your module from another directory or root directory.
"""
For example:
1) VS Code opened in directory 1
2) Script script.py you are working with located in directory 1/2/script.py
3) Module you want to import is located in root directory: 1/module.py 
4) To import function from module from directory 1 you need to write in your script.py the following lines:

import sys
sys.path.append('')
from module import func
"""



### Interacting with OS -------------------------

### Question ###
""" 
This question already has answers here:
open() gives FileNotFoundError/IOError: Errno 2 No such file or directory (7 answers)
Closed 3 years ago.
I am trying to open a CSV file but for some reason python cannot locate it.

Here is my code (it's just a simple code but I cannot solve the problem): """

"""
import csv

with open('address.csv','r') as f:
    reader = csv.reader(f)
    for row in reader:
        print row
"""

### Answer ###
print("\n### Answer ###")

""" When you open a file with the name address.csv, you are telling the open() function that your file is in the current working directory. This is called a relative path.

To give you an idea of what that means, add this to your code: """

import os

cwd = os.getcwd()  # Get the current working directory (cwd)
files = os.listdir(cwd)  # Get all the files in that directory
print("Files in %r: %s" % (cwd, files))

""" That will print the current working directory along with all the files in it.

Another way to tell the open() function where your file is located is by using an absolute path, e.g.: 

f = open("/Users/foo/address.csv")
"""