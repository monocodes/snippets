-------------------------------------------------
# stress
-------------------------------------------------
# stress - utility to stress the hardware
# start stress on cpu with 4 processes for 300 seconds in background
nohup stress -c 4 -t 300 &

# small script to test monitoring alarms
# stress.sh
#!/bin/bash
sudo stress -c 4 -t 60 && sleep 60 && stress -c 4 -t 60 && sleep 60 && stress -c 4 -t 360 && sleep  && stress -c 4 -t 460 && sleep 30 && stress -c 4 -t 360 && sleep 60

# run it in background
nohup ./stress.sh &




-------------------------------------------------
### INSTALLS
-------------------------------------------------



-------------------------------------------------
### NOTES
-------------------------------------------------
-------------------------------------------------
### BASH '', ""
-------------------------------------------------
# https://stackoverflow.com/questions/6697753/difference-between-single-and-double-quotes-in-bash

The accepted answer is great. I am making a table that helps in quick comprehension of the topic. The explanation involves a simple variable a as well as an indexed array arr.

If we set

a=apple      # a simple variable
arr=(apple)  # an indexed array with a single element
and then echo the expression in the second column, we would get the result / behavior shown in the third column. The fourth column explains the behavior.

#	Expression	Result	Comments
1	"$a"	apple	variables are expanded inside ""
2	'$a'	$a	variables are not expanded inside ''
3	"'$a'"	'apple'	'' has no special meaning inside ""
4	'"$a"'	"$a"	"" is treated literally inside ''
5	'\''	invalid	can not escape a ' within ''; use "'" or $'\'' (ANSI-C quoting)
6	"red$arocks"	red	$arocks does not expand $a; use ${a}rocks to preserve $a
7	"redapple$"	redapple$	$ followed by no variable name evaluates to $
8	'\"'	\"	\ has no special meaning inside ''
9	"\'"	\'	\' is interpreted inside "" but has no significance for '
10	"\""	"	\" is interpreted inside ""
11	"*"	*	glob does not work inside "" or ''
12	"\t\n"	\t\n	\t and \n have no special meaning inside "" or ''; use ANSI-C quoting
13	"`echo hi`"	hi	`` and $() are evaluated inside "" (backquotes are retained in actual output)
14	'`echo hi`'	`echo hi`	`` and $() are not evaluated inside '' (backquotes are retained in actual output)
15	'${arr[0]}'	${arr[0]}	array access not possible inside ''
16	"${arr[0]}"	apple	array access works inside ""
17	$'$a\''	$a'	single quotes can be escaped inside ANSI-C quoting
18	"$'\t'"	$'\t'	ANSI-C quoting is not interpreted inside ""
19	'!cmd'	!cmd	history expansion character '!' is ignored inside ''
20	"!cmd"	cmd args	expands to the most recent command matching "cmd"
21	$'!cmd'	!cmd	history expansion character '!' is ignored inside ANSI-C quotes
See also:

ANSI-C quoting with $'' - GNU Bash Manual - https://www.gnu.org/software/bash/manual/html_node/ANSI_002dC-Quoting.html
Locale translation with $"" - GNU Bash Manual - https://www.gnu.org/software/bash/manual/html_node/Locale-Translation.html#Locale-Translation
A three-point formula for quotes - https://stackoverflow.com/a/42104627/6862601





-------------------------------------------------
### SED '', ""
-------------------------------------------------

# https://unix.stackexchange.com/questions/542454/escaping-single-quote-in-sed-replace-string

You don't need to escape in sed, where ' has no special significance. You need to escape it in bash.

$ sed -e "s/'/singlequote/g" <<<"'"
singlequote
You can see here that the double quotes protect the single quote from bash, and sed does fine with it. Here's what happens when you switch the single quotes.

$ sed -e 's/'/singlequote/g' <<<"'"
>
The strange thing about ' in bourne like shells (all?) is that it functions less like " and more like a flag to disable other character interpretation until another ' is seen. If you enclose it in double quotes it won't have it's special significance. Observe:

$ echo 'isn'"'"'t this hard?'
isn't this hard?
You can also escape it with a backslash as shown in the other answer. But you have to leave the single quoted block before that will work. So while this seems like it would work:

echo '\''
it does not; the first ' disables the meaning of the \ character.

I suggest you take a different approach. sed expressions can be specified as command line arguments - but at the expense of having to escape from the shell. It's not bad to escape a short and simple sed expression, but yours is pretty long and has a lot of special characters.

I would put your sed command in a file, and invoke sed with the -f argument to specify the command file instead of specifying it at the command line. http://man7.org/linux/man-pages/man1/sed.1.html or man sed will go into detail. This way the sed commands aren't part of what the shell sees (it only sees the filename) and the shell escaping conundrum disappears.

$ cat t.sed
s/'*/singlequote(s)/g

$ sed -f t.sed <<<"' ' '''"
singlequote(s) singlequote(s) singlequote(s)
"""




-------------------------------------------------
### GUIDES
-------------------------------------------------
-------------------------------------------------
### SED GUIDE
-------------------------------------------------
# https://www.cyberciti.biz/faq/how-to-use-sed-to-find-and-replace-text-in-files-in-linux-unix-shell/

How to use sed to find and replace text in files in Linux / Unix shell
Author: Vivek Gite Last updated: January 7, 2023 36 comments
See all GNU/Linux related FAQIam a new Linux user. I wanted to find the text called “foo” and replaced to “bar” in the file named “hosts.txt.” How do I use the sed command to find and replace text/string on Linux or UNIX-like system?

The sed stands for stream editor. It reads the given file, modifying the input as specified by a list of sed commands. By default, the input is written to the screen, but you can force to update file.
ADVERTISEMENT
Find and replace text within a file using sed command
The procedure to change the text in files under Linux/Unix using sed:

Use Stream EDitor (sed) as follows:
sed -i 's/old-text/new-text/g' input.txt
The s is the substitute command of sed for find and replace
It tells sed to find all occurrences of ‘old-text’ and replace with ‘new-text’ in a file named input.txt
Verify that file has been updated:
more input.txt
Let us see syntax and usage in details.
Tutorial details
Difficulty level	Easy
Root privileges	No
Requirements	Linux or Unix terminal
Category	Linux shell scripting
Prerequisites	sed utility
OS compatibility	BSD • Linux • macOS • Unix • WSL
Est. reading time	4 minutes
Syntax: sed find and replace text
The syntax is:
sed 's/word1/word2/g' input.file
## *BSD/macOS sed syntax ##
sed 's/word1/word2/g' input.file > output.file
## GNU/Linux sed syntax ##
sed -i 's/word1/word2/g' input.file
sed -i -e 's/word1/word2/g' -e 's/xx/yy/g' input.file
## Use + separator instead of / ##
sed -i 's+regex+new-text+g' file.txt

The above replace all occurrences of characters in word1 in the pattern space with the corresponding characters from word2.

Examples that use sed to find and replace
Let us create a text file called hello.txt as follows:
cat hello.txt

Sample file:

The is a test file created by nixCrft for demo purpose.
foo is good.
Foo is nice.
I love FOO.
I am going to use s/ for substitute the found expression foo with bar as follows:
sed 's/foo/bar/g' hello.txt

Sample outputs:

The is a test file created by nixCrft for demo purpose.
bar is good.
Foo is nice.
I love FOO.
sed find and replace examples for unix and linux
To update file pass the -i option when using GNU/sed version:
sed -i 's/foo/bar/g' hello.txt
cat hello.txt

The g/ means global replace i.e. find all occurrences of foo and replace with bar using sed. If you removed the /g only first occurrence is changed. For instance:
sed -i 's/foo/bar/' hello.txt

The / act as delimiter characters. To match all cases of foo (foo, FOO, Foo, FoO) add I (capitalized I) option as follows:
sed -i 's/foo/bar/gI' hello.txt
cat hello.txt

Sample outputs:

The is a test file created by nixCrft for demo purpose.
bar is good.
bar is nice.
I love bar.
A note about *BSD and macOS sed version
Please note that the BSD implementation of sed (FreeBSD/OpenBSD/NetBSD/MacOS and co) does NOT support case-insensitive matching including file updates with the help of -i option. Hence, you need to install gnu sed. Run the following command on Apple macOS (first set up home brew on macOS):
brew install gnu-sed
######################################
### now use gsed command as follows ##
######################################
gsed -i 's/foo/bar/gI' hello.txt
#########################################
### make a backup and then update file ##
#########################################
gsed -i'.BAK' 's/foo/bar/gI' hello.txt
cat hello.txt

sed command problems
Consider the following text file:
cat input.txt
http:// is outdate.
Consider using https:// for all your needs.

Find word ‘http://’ and replace with ‘https://www.cyberciti.biz’:
sed 's/http:///https://www.cyberciti.biz/g' input.txt

You will get an error that read as follows:

sed: 1: "s/http:///https://www.c ...": bad flag in substitute command: '/'
Our syntax is correct but the / delimiter character is also part of word1 and word2 in above example. Sed command allows you to change the delimiter / to something else. So I am going to use +:
sed 's+http://+https://www.cyberciti.biz+g' input.txt

Sample outputs:

https://www.cyberciti.biz is outdate.
Consider using https:// for all your needs.
How to use sed to match word and perform find and replace
In this example only find word ‘love’ and replace it with ‘sick’ if line content a specific string such as FOO:
sed -i -e '/FOO/s/love/sick/' input.txt

Use cat command to verify new changes:
cat input.txt

Recap and conclusion – Using sed to find and replace text in given files
The general syntax is as follows:
## find word1 and replace with word2 using sed ##
sed -i 's/word1/word2/g' input
## you can change the delimiter to keep syntax simple ##
sed -i 's+word1+word2+g' input
sed -i 's_word1_word2_g' input
## you can add I option to GNU sed to case insensitive search ##
sed -i 's/word1/word2/gI' input
sed -i 's_word1_word2_gI' input

See BSD (used on macOS too) sed or GNU sed man page by typing the following man command/info command or help command:
man sed
# gnu sed options #
sed --help
info sed