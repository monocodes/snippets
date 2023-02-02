"""
    VI Visual display editor
    VIM Visual display editor improved
    VIM EDITOR

This is command mode editor for files. Other editors in Linux are emacs, gedit vi editor is most popular
It has 3 modes:
1 - Command Mode
2 - Insert mode (edit mode)
3 - Extended command mode
Note: When you open the vim editor, it will be in the command mode by default.

Command Mode:
gg - To go to the beginning of the page
G - To go to end of the page
w - To move the cursor forward, word by word
b - To move the cursor backward, word by word
nw - To move the cursor forward to n words (SW) nb To move the cursor backward to n words {SB)
u - To undo last change (word)
Ctrl+R - To redo the changes
U - To undo the previous changes (entire line)
VY - To copy a line
nyy - To copy n lines (Syy or 4yy)
p - To paste line below the cursor position
dw - To delete the word letter by letter {like Backspace}
x - To paste line above the cursor position
X - To delete the world letter by letter (like DEL Key)
dd - To delete entire line
ndd - To delete n no. of lines from cursor position{Sdd)
/ - To search a word in the file


Extended Mode: (Colon Mode)
Extended Mode is used for save and quit or save without quit using "Esc" Key with":"

Esc+:w - To Save the changes
Esc+:q - To quit (Without saving)
Esc+:wq - To save and quit
Esc+:w! - To save forcefully
Esc+wq! - To save and quit forcefully
Esc+:x - To save and quit
Esc+:X - To give passw or d to the file and remove password
Esc+:20(n) - To go to line no 20 or n
Esc+: se nu - To set the line numbers to the file !
Esc+: se nonu - To Remove the set line numbers
"""

commands ----------------------------------------
# search and replace only once every line
:%s/word-to-replace/word-that-replace
# example
:%s/coronavirus/covid19

# search and replace g - globally (more than one time in line)
:%s/word-to-replace/word-that-replace/g
# example
:%s/coronavirus/covid19/g

# search and replace g - globally (more than one time in line) with nothing
:%s/word-to-replace//g
# example
:%s/coronavirus//g