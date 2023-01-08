### NETWORK -------------------------------------
# how to flush DNS
sudo killall -HUP mDNSResponder; sleep 2; echo macOS DNS Cache Reset | say

# arp
# see arp table
arp -a

# to delete the cache for a particular interface
sudo arp -d 192.168.1.10 ifscope en0

# to clear the whole cache table
sudo arp -a -d



### USEFUL COMMANDS -----------------------------
# restart terminal
exec zsh -l


### SED ###
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


### EXPORT ###
# how to get rid of item after EXPORT someting
# check ~/.zprofile and ~/.zshrc

# for example, set LDFLAGS and CPPFLAGS
export LDFLAGS="-L/opt/homebrew/opt/libffi/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libffi/include"

# to set multiple LDFLAGS and CPPFLAGS
export CPPFLAGS="-I/opt/homebrew/opt/tcl-tk/include -I/opt/homebrew/opt/libffi/include"
export LDFLAGS="-L/opt/homebrew/opt/tcl-tk/lib -L/opt/homebrew/opt/libffi/lib"

# view active flags
echo ${LDFLAGS}
echo ${CPPFLAGS}

# unset flags
unset LDFLAGS
unset CPPFLAGS


### USERS & GROUPS ###
# list all users
dscl . list /users

# list all groups
dscl . list /groups



### USEFUL SHORTCUTS ----------------------------
# display dotfiles in Finder
Command+Shift+Dot

# smiles menu in any text editor
cmd + ctrl + space



### FILESYSTEM ----------------------------------
fs_usage
# The file system usage tool is ideal since it taps in to the real time file system events and dumps activity to a file or the screen. Since you know the exact path of the file, you can filter out all the thousands of irrelevant (to this case) filesystem changes and see what reads / writes to that file pretty quickly.
sudo fs_usage | grep /Users/me/aa



### APPS ----------------------------------------

### Google Chrome ###

"""
How do I disable Chrome's two-finger back/forward navigation? Open terminal and type:
"""
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool FALSE

# restart chrome
chrome://restart



### TIME MACHINE --------------------------------
### Time Machine settings ### 
/Library/Preferences/com.apple.TimeMachine.plist

# to edit com.apple.TimeMachine.plist
# 1) cp it anywhere
# 2) edit it with xml editor or xcode
# 3) sudo cp com.apple.TimeMachine.plist to /Library/Preferences/