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