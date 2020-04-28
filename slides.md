---
title: 'Class 8: Chapter 14: Files'
separator: '\-\-\-\-\-'
verticalSeparator: '\+\+\+\+\+'
theme: 'moon'
revealOptions:
    transition: 'fade'
---

### ITSE-1042 Intermediate Python
<span style="font-family:Helvetica Neue; font-weight:bold; color:#e49436">Class 8: Chapter 14: Files</span>
<br /><br />

-----

##### Chapter 14: Files

+++++

##### 14.1 Persistence

+++++

Most of the programs we have seen so far run for a short time and produce some output and end with no saved data. If you run the program again, it starts with a clean slate.

+++++

If a program isn't transient, it is persistent. Meaning, they run for a long time (or all the time); they keep at least some of their data in permanent storage (a hard drive, for example); and if they shut down and restart, they pick up where they left off. An example of a persistent program is an operating system like the one you are presently using.

+++++

One of the simplest ways for programs to maintain their data is by reading and writing text files. We have already seen programs that read text files; in this chapter we will see programs that write them. An alternative is to store the state of the program in a database or with a module, shelve.

+++++

##### 14.2 Reading and writing

+++++

We saw how to open and read a file in Section 9.1. To write a file, you have to open it with mode 'w' as a second parameter:

```python
fout = open('output.txt', 'w')
```

+++++

If the file already exists, opening it in write mode clears out the old data and starts fresh, so be careful! If the file doesn’t exist, a new one is created. open returns a file object that provides methods for working with the file.

```python
fout = open('output.txt', 'w')
line1 = "This here's the wattle,\n"
fout.write(line1)    # returns number of characters written
```

+++++

The file object keeps track of where it is, so if you call write again, it adds the new data to the end of the file.

```python
fout = open('output.txt', 'w')
line1 = "This here's the wattle,\n"
fout.write(line1)    # returns number of characters written
line2 = "the emblem of our land.\n"
fout.write(line2)
```

+++++

When you are done writing, you should close the file.

```python
fout = open('output.txt', 'w')
line1 = "This here's the wattle,\n"
fout.write(line1)    # returns number of characters written
line2 = "the emblem of our land.\n"
fout.write(line2)
fout.close()
```

Note: If you don’t close the file, it gets closed for you when the program ends.

+++++

There is also a better way to open files that you should typically use. This way will open the file and automatically close it once the code inside it completes.

```python
with open("test.txt", "w") as out_file:
    out_file.write("Hello!\nTest 123!")
```

+++++

<pre class="stretch"><code class="python" data-trim data-noescape>
#!/usr/bin/env python3

# Exercise 14.1
#
# 1. Write a function called sed that takes as arguments a pattern string, a
# replacement string, and two filenames; it should read the first file and write
# the contents into the second file (creating it if necessary). If the pattern
# string appears anywhere in the file, it should be replaced with the
# replacement string.
# 
# If an error occurs while opening, reading, writing or closing files, your
# program should catch the exception, print an error message, and exit.
</code></pre>

+++++

##### 14.3 Format operator

+++++

The argument of write has to be a string, so if we want to put other values in a file, we have to convert them to strings. The easiest way to do that is with str:

```python
x = 52
fout.write(str(x))
```

+++++

An alternative is to use the format operator, %. When applied to integers, % is the modulus operator. But when the first operand is a string, % is the format operator.

For example, the format sequence '%d' means that the second operand should be formatted as a decimal integer:

```python
camels = 42
'%d' % camels    # '42'
```

Note:
The first operand is the format string, which contains one or more format sequences,
which specify how the second operand is formatted. The result is a string.
The result is the string '42'

+++++

A format sequence can appear anywhere in the string, so you can embed a value in a sentence:

```python
'I have spotted %d camels.' % camels
'I have spotted 42 camels.'
```

+++++

If there is more than one format sequence in the string, the second argument has to be a tuple. Each format sequence is matched with an element of the tuple, in order.

The following example uses '%d' to format an integer, '%g' to format a floating-point number, and '%s' to format a string:

```python
'In %d years I have spotted %g %s.' % (3, 0.1, 'camels')
# 'In 3 years I have spotted 0.1 camels.'
```

+++++

The number of elements in the tuple has to match the number of format sequences in the string. The types of the elements also have to match the format sequences:

```python
'%d %d %d' % (1, 2)
TypeError: not enough arguments for format string
>>> '%d' % 'dollars'
TypeError: %d format: a number is required, not str
```
[https://pyformat.info/](https://pyformat.info/)

Note:
In the first example, there aren’t enough elements; in the second, the element is the wrong
type.
For more information on the format operator, see https://docs.python.org/3/library/
stdtypes.html#printf-style-string-formatting.

+++++

##### 14.4 Filenames and paths

+++++

Every running program has a “current directory”, which is the default directory for most operations.

The os module provides functions for working with files and directories (“os” stands for “operating system”). os.getcwd returns the name of the current directory:

```python
import os
cwd = os.getcwd()
print(cwd)
# '/home/dinsdale'
```

Note:
cwd stands for “current working directory”. The result in this example is /home/dinsdale,
which is the home directory of a user named dinsdale.

+++++

A string like '/home/dinsdale' that identifies a file or directory is called a path. A simple filename, like memo.txt is also considered a path, but it is a relative path because it relates to the current directory.

```python
os.path.abspath('memo.txt')
# '/home/dinsdale/memo.txt'
os.path.exists('memo.txt')
# True
os.path.isdir('memo.txt')
# False
os.path.isdir('/home/dinsdale')
# True
os.path.isfile('memo.txt')
# True
os.listdir(cwd)
# ['music', 'photos', 'memo.txt']
```

+++++

To demonstrate these functions, the following example “walks” through a directory, prints the names of all the files, and calls itself recursively on all the directories.

```python
def walk(dirname):
    for name in os.listdir(dirname):
        path = os.path.join(dirname, name)
        if os.path.isfile(path):
            print(path)
        else:
            walk(path)
```

Note:
os.path.join takes a directory and a file name and joins them into a complete path.
The os module provides a function called walk that is similar to this one but more versatile.

+++++

##### 14.5 Catching exceptions

+++++

A lot of things can go wrong when you try to read and write files. If you try to open a file that doesn’t exist, you get an IOError:

```python
fin = open('bad_file')
# IOError: [Errno 2] No such file or directory: 'bad_file'
```

+++++

If you don’t have permission to access a file:

```python
fout = open('/etc/passwd', 'w')
# PermissionError: [Errno 13] Permission denied: '/etc/passwd'
```

+++++

And if you try to open a directory for reading, you get:

```python
fin = open('/home')
# IsADirectoryError: [Errno 21] Is a directory: '/home'
```

+++++

To avoid these errors, you could use functions like os.path.exists and os.path.isfile, but it would take a lot of time and code to check all the possibilities (if “Errno 21” is any indication, there are at least 21 things that can go wrong).

It is better to go ahead and try—and deal with problems if they happen—which is exactly what the try statement does. The syntax is similar to an if...else statement:

```python
try:
    fin = open('bad_file')
except:
    print('Something went wrong.')
```

Note:
Python starts by executing the try clause. If all goes well, it skips the except clause and
proceeds. If an exception occurs, it jumps out of the try clause and runs the except clause.
Handling an exception with a try statement is called catching an exception. In this example,
the except clause prints an error message that is not very helpful. In general, catching
an exception gives you a chance to fix the problem, or try again, or at least end the program
gracefully

+++++

##### 14.6 Databases

+++++

A database is a file that is organized for storing data. Many databases are organized like a dictionary in the sense that they map from keys to values. The biggest difference between a database and a dictionary is that the database is on disk (or other permanent storage), so it persists after the program ends.

+++++

The module dbm provides a generic interface for creating and updating UNIX dbm database files. As an example, we’ll create a database that contains captions for image files.

Opening a database is similar to opening other files:

```python
import dbm
db = dbm.open('captions', 'c')
```

Note: 
The mode 'c' means that the database should be created if it doesn’t already exist. The
result is a database object that can be used (for most operations) like a dictionary.

+++++

```python
import dbm
db = dbm.open('captions', 'c')
# When you create a new item, dbm updates the database file.
db['cleese.png'] = 'Photo of John Cleese.'
# When you access one of the items, dbm reads the file:
print(db['cleese.png'])
# The result is a bytes object, which is why it begins with b. A bytes object is similar to a
# string in many ways. When you get farther into Python, the difference becomes important,
# but for now we can ignore it.
# b'Photo of John Cleese.'
# If you make another assignment to an existing key, dbm replaces the old value:
db['cleese.png'] = 'Photo of John Cleese doing a silly walk.'
print(db['cleese.png'])
# b'Photo of John Cleese doing a silly walk.'
```

+++++

Some dictionary methods, like keys and items, don’t work with database objects. But iteration with a for loop works:

```python
for key in db:
    print(key, db[key])

# As with other files, you should close the database when you are done:
db.close()
```

+++++

##### 14.7 Pickling
    
+++++

A limitation of dbm is that the keys and values have to be strings or bytes. If you try to use any other type, you get an error.

The pickle module can help. It translates almost any type of object into a string suitable for storage in a database, and then translates strings back into objects.

pickle.dumps takes an object as a parameter and returns a string representation (dumps is short for “dump string”):

+++++

```python
import pickle
t = [1, 2, 3]
pickle.dumps(t)
# b'\x80\x03]q\x00(K\x01K\x02K\x03e.'
```

Note:
The format isn’t obvious to human readers; it is meant to be easy for pickle to interpret.

+++++

pickle.loads (“load string”) reconstitutes the object:

```python
t1 = [1, 2, 3]
s = pickle.dumps(t1)
t2 = pickle.loads(s)
print(t2)
# [1, 2, 3]
```

+++++

Although the new object has the same value as the old, it is not (in general) the same object:

```python
t1 == t2
# True
t1 is t2
# False
```

In other words, pickling and then unpickling has the same effect as copying the object. 

+++++

You can use pickle to store non-strings in a database. In fact, this combination is so common that it has been encapsulated in a module called shelve which works almost identically to dmb in manner of opening, defining, modifying, and accesing objects.

+++++


##### Choosing a Database
   
DBM provides key/data pairs in a data file. It is basically a persistent dictionary, which can be used 
as a readily available simple database. 

There are 4 alternative DBM services available in Python: dbm, dbm.gnu, and dbm.ndbm. and dbm.dumb 
(Portable DBM implemented in Python). In addition, the anydbm module provides a generic intererface to all of 
the dbm implementations, and chooses the best DBM module avaiable.

The DBM modules provide you with your data stored as a key/value pair. You can use the the value of a DBM persistent dictionary 
when:
- data needs are simple
- small amounts of data are involved
- high performance is not required 

However, when you need a more sophisticated, high performance database manager,  
or you have the need for a full relational DB, you should use a relational database such as 
sqlite3,  MySQL PostgreSQL, MongoDB, Sybase, Oracle DB, or IBM DB2. 

 
+++++

##### 14.8 Pipes

+++++

Most operating systems provide a command-line interface, also known as a shell. Any program that you can launch from the shell can also be launched from Python using a pipe object, which represents a running program.

For example, the Unix command ls -l normally displays the contents of the current directory in long format. You can launch ls with os.popen:

```python
cmd = 'ls -l'
fp = os.popen(cmd)
```

+++++

The argument is a string that contains a shell command. The return value is an object that behaves like an open file. You can read the output from the ls process one line at a time with readline or get the whole thing at once with read:

```python
cmd = 'ls -l'
fp = os.popen(cmd)
res = fp.read()
# When you are done, you close the pipe like a file:
stat = fp.close()
print(stat)
# None
# The return value is the final status of the ls process; None means that it ended normally (with no errors).
```

+++++

For example, most Unix systems provide a command called md5sum that reads the contents of a file and computes a “checksum”. This command provides an efficient way to check whether two files have the same contents. The probability that different contents yield the same checksum is very small (that is, unlikely to happen before the universe collapses).

+++++

You can use a pipe to run md5sum from Python and get the result:

```python
filename = 'book.tex'
cmd = 'md5sum ' + filename
fp = os.popen(cmd)
res = fp.read()
stat = fp.close()
print(res)
1e0033f0ed0656636de0d75144ba32e0 book.tex
print(stat)
None
```

+++++

##### 14.9 Writing modules

+++++

Any file that contains Python code can be imported as a module. For example, suppose you have a file named wc.py with the following code:

```python
def linecount(filename):
    count = 0
    for line in open(filename):
        count += 1
    return count

print(linecount('wc.py'))
```

Note:
If you run this program, it reads itself and prints the number of lines in the file, which is 7.

+++++

You can also import it like this:

```python
import wc
# 7

# Now you have a module object wc:
wc
# <module 'wc' from 'wc.py'>

# The module object provides linecount:
wc.linecount('wc.py')
# 7
```

+++++

So that’s how you write modules in Python. The only problem with this example is that when you import the module it runs the test code at the bottom. Normally when you import a module, it defines new functions but it doesn’t run them.

Programs that will be imported as modules often use the following idiom:

```python
if __name__ == '__main__':
    print(linecount('wc.py'))
```

+++++

__name__ is a built-in variable that is set when the program starts. If the program is running as a script, __name__ has the value '__main__'; in that case, the test code runs. Otherwise, if the module is being imported, the test code is skipped.

Warning: If you import a module that has already been imported, Python does nothing. It does not re-read the file, even if it has changed.

If you want to reload a module, you can use the built-in function reload, but it can be tricky, so the safest thing to do is restart the interpreter and then import the module again.

+++++

##### PEP 8 -- Style Guide for Python Code

__PEP 8__ is the Style Guide for Python Code.   
PEP8 provides coding conventions for the Python code comprising the standard library in the main Python distribution. https://www.python.org/dev/peps/pep-0008/

The PEP8 guidelines are intended to improve the readability of code and make it consistent across the wide spectrum of Python code. 

A style guide is about consistency. Consistency with the style guide is important. Consistency within a project is more important. Consistency within one module or function is the most important.

+++++

Some of the areas covered in the PEP8 Style Guide include:  
- Code Lay-out   
-- Indentation   
-- Tabs or Spaces   
-- Maximum Line Length   
-- Should a Line Break Before or After a Binary Operator?   
-- Blank Lines   
-- Source File Encoding   
-- Imports   
-- Module Names   
- String Quotes
- Whitespace in Expressions and Statements   
- When to Use Trailing Commas      
- Comments      
- Documentation Strings      
- Naming Conventions      

However, know when to be inconsistent -- sometimes style guide recommendations just aren't applicable.

+++++

<pre class="stretch"><code class="python" data-trim data-noescape>
#!/usr/bin/env python3

# Exercise 14.2
#
# 1. If you download my solution to Exercise 12-2 from 
# http://thinkpython2.com/code/anagram_sets.py, you'll see that it creates a 
# dictionary that maps from a sorted string of letters to the list of words that
# can be spelled with those letters. For example, 'opst' maps to the list 
# ['opts', 'post', 'pots', 'spot', 'stop', 'tops'].
#
# Write a module that imports anagram_sets and provides two new functions: 
# store_anagrams should store the anagram dictionary in a "shelf"; read_anagrams
# should look up a word and return a list of its anagrams.
</code></pre>


+++++

Homework is 14.3.
