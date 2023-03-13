*************************************************
# PATHS
*************************************************
# PATH variable
cat /etc/paths

# PATH files
ls /etc/paths.d

# show current path in terminal
echo "$PATH"

### $PATH guide is at the bottom of the page ###



-------------------------------------------------
# .zshrc .zprofile
-------------------------------------------------
$HOME/.zshrc
$HOME/.zprofile
~/.zshrc
~/.zprofile

# to update PATH from .zprofile
source $HOME/.zprofile
# or
. $HOME/.zprofile



-------------------------------------------------
# EXPORT
-------------------------------------------------
# show current environmental variables
printenv

# how to get rid of item after EXPORT something
# check ~/.zprofile and ~/.zshrc
printenv
unset var-name

# for example, set LDFLAGS and CPPFLAGS
export LDFLAGS="-L/opt/homebrew/opt/libffi/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libffi/include"

# to set multiple LDFLAGS and CPPFLAGS
export CPPFLAGS="-I/opt/homebrew/opt/tcl-tk/include -I/opt/homebrew/opt/libffi/include"
export LDFLAGS="-L/opt/homebrew/opt/tcl-tk/lib -L/opt/homebrew/opt/libffi/lib"

# show active flags
echo ${LDFLAGS}
echo ${CPPFLAGS}

# unset flags
unset LDFLAGS
unset CPPFLAGS





*************************************************
# NETWORK
*************************************************

# how to flush DNS
sudo killall -HUP mDNSResponder
sudo killall -HUP mDNSResponder; sleep 2; echo macOS DNS Cache Reset | say

# arp
# see arp table
arp -a

# to delete the cache for a particular interface
sudo arp -d 192.168.1.10 ifscope en0

# to clear the whole cache table
sudo arp -a -d


### traceroute ###
# show path to the server and latency problems
traceroute google.com


### Adding a Second IP Address to an Existing Network Adapter ###
# non-persistent, deletes after reboot
sudo ifconfig en0 alias 128.133.123.83/24 up

# remove alias
sudo ifconfig en0 -alias 128.133.123.83





*************************************************
# USEFUL COMMANDS
*************************************************
# restart terminal
exec zsh -l

# get help with the command
man command-name
man sed



-------------------------------------------------
# USERS & GROUPS
-------------------------------------------------
# list all users
dscl . list /users

# list all groups
dscl . list /groups





*************************************************
# USEFUL SHORTCUTS
*************************************************
# display dotfiles in Finder
Command+Shift+Dot

# smiles menu in any text editor
cmd + ctrl + space





*************************************************
# FILESYSTEM
*************************************************
fs_usage
# The file system usage tool is ideal since it taps in to the real time file system events and dumps activity to a file or the screen. Since you know the exact path of the file, you can filter out all the thousands of irrelevant (to this case) filesystem changes and see what reads / writes to that file pretty quickly.
sudo fs_usage | grep /Users/me/aa





*************************************************
# APPS
*************************************************

-------------------------------------------------
# Google Chrome
-------------------------------------------------

"""
How do I disable Chrome's two-finger back/forward navigation? Open terminal and type:
"""
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool FALSE

# restart chrome
chrome://restart



-------------------------------------------------
# TIME MACHINE
-------------------------------------------------

### Time Machine settings ### 
/Library/Preferences/com.apple.TimeMachine.plist

# to edit com.apple.TimeMachine.plist
# 1) cp it anywhere
# 2) edit it with xml editor or xcode
# 3) sudo cp com.apple.TimeMachine.plist to /Library/Preferences/



-------------------------------------------------
# terminal
-------------------------------------------------
# switch to next tab in current window
ctrl + tab

# switch to previous tab in current window
ctrl + shift + tab





*************************************************
# console apps
*************************************************

-------------------------------------------------
# grep
-------------------------------------------------
# made grep colorful on macos
# add to the ~/.zprofile
vim ~/.zprofile
export GREP_OPTIONS='--color=auto'
source ~/.zprofile


-------------------------------------------------
# vim
-------------------------------------------------
# Create a .vimrc file on your home ~/ folder and
# then edit it with vim ~/.vimrc. You can try 
# adding syntax on inside ~/.vimrc file. 
# The following command does that:
echo "syntax on" >> ~/.vimrc



-------------------------------------------------
# sed
-------------------------------------------------
### use sed from macOS or use gsed from GNU ###
brew install gsed

# find text in files recursively and change it
LC_ALL=C find . -type f -name 'filename-regex' -exec sed -i '' s/word-to-replace/word-that-replace/g {} +
# example
LC_ALL=C find . -type f -name '*' -exec sed -i '' s/venv-data_vis/venv-data-vis/g {} +

"""
OS X uses a mix of BSD and GNU tools, so best always check the documentation (although I had it that less didn't even conform to the OS X manpage):
https://web.archive.org/web/20170808213955/https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/sed.1.html

sed takes the argument after -i as the extension for backups. Provide an empty string (-i '') for no backups.

The following should do:
find . -type f -name '*.txt' -exec sed -i '' s/this/that/g {} +

The -type f is just good practice; sed will complain if you give it a directory or so.
-exec is preferred over xargs; you needn't bother with -print0 or anything.

The {} + at the end means that find will append all results as arguments to one instance of the called command, instead of re-running it for each result. (One exception is when the maximal number of command-line arguments allowed by the OS is breached; in that case find will run more than one instance.)

If you get an error like "invalid byte sequence," it might help to force the standard locale by adding LC_ALL=C at the start of the command, like so:
LC_ALL=C find . -type f -name '*.txt' -exec sed -i '' s/this/that/g {} +
"""





*************************************************
# SYMBOLIC LINKS
*************************************************
# example of deleting unuseful symbolic links

# Step 3: Remove Python symbolic links
"""
The symlinks referencing Python frameworks are in the /usr/local/bin directory. If you would like to see the broken symlinks, please use the following command.
"""
# become root
sudo -i

# check first
ls -l /usr/local/bin | grep '../Library/Frameworks/Python.framework'

# delete
ls -l /usr/local/bin | grep '../Library/Frameworks/Python.framework' | awk '{print $9}' | tr -d @ | xargs rm

# check again
ls /usr/local/bin





*************************************************
# GUIDES
*************************************************

-------------------------------------------------
# $PATH GUIDE
-------------------------------------------------

# https://www.cyberciti.biz/faq/appleosx-bash-unix-change-set-path-environment-variable/

$PATH is nothing but an environment variable on Linux, OS X, Unix-like operating systems, and Microsoft Windows. You can specify a set of directories where executable programs are located using $PATH. The $PATH variable is specified as a list of directory names separated by colon (:) characters.
ADVERTISEMENT
MacOS Print $PATH Settings
To print the current settings, open the Terminal application and then printf command or echo command

echo "$PATH"
OR

printf "%s\n" $PATH
Here is what I see
Fig.01: Displaying the current $PATH settings using echo / printf on OS X
Fig.01: Displaying the current $PATH settings using echo / printf on OS X

macOS (OS X): Change your PATH environment variable
You can add path to any one of the following method:

$HOME/.bash_profile file using export syntax.
/etc/paths.d directory.
Method #1: $HOME/.bash_profile file to set or change $PATH under macOS
Open the Terminal app on macOS
The syntax is as follows using the export command to add to the PATH on macOS:
export PATH=$PATH:/new/dir/location1
export PATH=$PATH:/new/dir1:/dir2:/dir/path/no3
In this example, add the /usr/local/sbin/modemZapp/ directory to $PATH variable. Edit the file $HOME/.bash_profile, enter:
vi $HOME/.bash_profile

OR
nano ~/.bash_profile
Append the following export command:
export PATH=$PATH:/usr/local/sbin/modemZapp
Save and close the file when using vim/vi as a text editor. Then, to apply changes immediately enter the following source command:
source $HOME/.bash_profile

OR
. $HOME/.bash_profile
Finally, verify your new path settings, enter:
echo "$PATH"

Sample outputs:
/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin:/usr/local/sbin/modemZapp
Method #2: /etc/paths.d directory
Apple recommends the path_helper tool to generate the PATH variable i.e. helper for constructing PATH environment variable. From the man page:

The path_helper utility reads the contents of the files in the directories /etc/paths.d and /etc/manpaths.d and appends their contents to the PATH and MANPATH environment variables respectively.

(The MANPATH environment variable will not be modified unless it is already set in the environment.)

Files in these directories should contain one path element per line.

Prior to reading these directories, default PATH and MANPATH values are obtained from the files /etc/paths and /etc/manpaths respectively.

To list existing path, enter:
ls -l /etc/paths.d/

Sample outputs:

total 16
-rw-r--r--  1 root  wheel  13 Sep 28  2012 40-XQuartz
You can use the cat command to see path settings in 40-XQuartz:
cat /etc/paths.d/40-XQuartz

Sample outputs:

/opt/X11/bin
To set /usr/local/sbin/modemZapp to $PATH, enter:

sudo -s 'echo "/usr/local/sbin/modemZapp" > /etc/paths.d/zmodemapp'
OR use vi text editor as follows to create /etc/paths.d/zmodemapp file:
sudo vi /etc/paths.d/zmodemapp

and append the following text:

/usr/local/sbin/modemZapp
Save and close the file. You need to reboot the system. Alternatively, you can close and reopen the Terminal app to see new $PATH changes.

Conclusion
MacOS Set or Change $PATH settings:

Use the .bash_profile file when you need to generate the PATH variable for a single user account.
Use the /etc/paths.d/ directory or folder via the path_helper command tool to generate the PATH variable for all user accounts on the system. This method only works on OS X Leopard and higher macOS version.
See the following manual pages using the help command or man command on your macOS / OS X machine:
man bash
man path_helper
help export