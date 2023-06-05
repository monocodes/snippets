---
title: tmux
categories:
  - software
  - guides
  - notes
author: monocodes
url: https://github.com/monocodes/snippets.git
---

## [tmux cheatsheet](https://gist.github.com/MohamedAlaa/2961058#windows-tabs)

### tmux shortcuts & cheatsheet

start new:

```sh
tmux
```

start new with session name:

```sh
tmux new -s myname
```

attach:

```sh
tmux a  #  (or at, or attach)
```

attach to named:

```sh
tmux a -t myname
```

list sessions:

```sh
tmux ls
```

kill session:

```sh
tmux kill-session -t myname
```

Kill all the tmux sessions:

```sh
tmux ls | grep : | cut -d. -f1 | awk '{print substr($1, 0, length($1)-1)}' | xargs kill
```

### List all shortcuts

In tmux, hit the prefix `Ctrl-b` or `C-b`  and then:

to see all the shortcuts keys in tmux simply use the `C-?`

### Sessions

```properties
:new<CR>  new session
s  list sessions
$  name session
```

### Windows (tabs)

```properties
c  create window
w  list windows
n  next window
p  previous window
f  find window
,  name window
&  kill window
```

### Panes (splits)

```properties
%  vertical split
"  horizontal split

o  swap panes
q  show pane numbers
x  kill pane
+  break pane into window (e.g. to select text by mouse to copy)
-  restore pane from window
⍽  space - toggle between layouts
q  show pane numbers, when the numbers show up type the key to goto that pane)
{  move the current pane left)
}  move the current pane right)
z  toggle pane zoom (make current pane fullscreen)
```

### Sync Panes

You can do this by switching to the appropriate window, typing your Tmux prefix (commonly Ctrl-B or Ctrl-A) and then a colon to bring up a Tmux command line, and typing:

```properties
:setw synchronize-panes
```

You can optionally add on or off to specify which state you want; otherwise the option is simply toggled. This option is specific to one window, so it won’t change the way your other sessions or windows operate. When you’re done, toggle it off again by repeating the command. [tip source](http://blog.sanctum.geek.nz/sync-tmux-panes/)

### Resizing Panes

Better to use mouse or arrow keys with holding `Ctrl`:

```properties
C-b C-↓  resize the current pane down
C-b C-↑  resize the current pane upward
C-b C-←  resize the current pane left
C-b C-→  resize the current pane right
```

You can also resize panes if you don’t like the layout defaults. I personally rarely need to do this, though it’s handy to know how. Here is the basic syntax to resize panes:

```properties
PREFIX : resize-pane -D (Resizes the current pane down)
PREFIX : resize-pane -U (Resizes the current pane upward)
PREFIX : resize-pane -L (Resizes the current pane left)
PREFIX : resize-pane -R (Resizes the current pane right)
PREFIX : resize-pane -D 20 (Resizes the current pane down by 20 cells)
PREFIX : resize-pane -U 20 (Resizes the current pane upward by 20 cells)
PREFIX : resize-pane -L 20 (Resizes the current pane left by 20 cells)
PREFIX : resize-pane -R 20 (Resizes the current pane right by 20 cells)
PREFIX : resize-pane -t 2 -L 20 (Resizes the pane with the id of 2 left by 20 cells)
```

### Copy mode

Pressing PREFIX [ places us in Copy mode. We can then use our movement keys to move our cursor around the screen. By default, the arrow keys work. we set our configuration file to use Vim keys for moving between windows and resizing panes so we wouldn’t have to take our hands off the home row. tmux has a vi mode for working with the buffer as well. To enable it, add this line to .tmux.conf:

```properties
setw -g mode-keys vi
```

With this option set, we can use h, j, k, and l to move around our buffer.

To get out of Copy mode, we just press the ENTER key. Moving around one character at a time isn’t very efficient. Since we enabled vi mode, we can also use some other visible shortcuts to move around the buffer.

For example, we can use "w" to jump to the next word and "b" to jump back one word. And we can use "f", followed by any character, to jump to that character on the same line, and "F" to jump backwards on the line.

```properties
   Function                vi             emacs
   Back to indentation     ^              M-m
   Clear selection         Escape         C-g
   Copy selection          Enter          M-w
   Cursor down             j              Down
   Cursor left             h              Left
   Cursor right            l              Right
   Cursor to bottom line   L
   Cursor to middle line   M              M-r
   Cursor to top line      H              M-R
   Cursor up               k              Up
   Delete entire line      d              C-u
   Delete to end of line   D              C-k
   End of line             $              C-e
   Goto line               :              g
   Half page down          C-d            M-Down
   Half page up            C-u            M-Up
   Next page               C-f            Page down
   Next word               w              M-f
   Paste buffer            p              C-y
   Previous page           C-b            Page up
   Previous word           b              M-b
   Quit mode               q              Escape
   Scroll down             C-Down or J    C-Down
   Scroll up               C-Up or K      C-Up
   Search again            n              n
   Search backward         ?              C-r
   Search forward          /              C-s
   Start of line           0              C-a
   Start selection         Space          C-Space
   Transpose chars                        C-t
```

### Misc

```properties
d  detach
t  big clock
?  list shortcuts
:  prompt
```

### Configurations Options

```properties
# Mouse support - set to on if you want to use the mouse
* setw -g mode-mouse off
* set -g mouse-select-pane off
* set -g mouse-resize-pane off
* set -g mouse-select-window off

# Set the default terminal mode to 256color mode
set -g default-terminal "screen-256color"

# enable activity alerts
setw -g monitor-activity on
set -g visual-activity on

# Center the window list
set -g status-justify centre

# Maximize and restore a pane
unbind Up bind Up new-window -d -n tmp \; swap-pane -s tmp.1 \; select-window -t tmp
unbind Down
bind Down last-window \; swap-pane -s tmp.1 \; kill-window -t tmp

# Renumber windows automatically
set -g renumber-windows on
# renumber-windows [on | off]
# If on, when a window is closed in a session, automatically renumber
# the other windows in numerical order.  This respects the
# base-index option if it has been set.  If off, do not renumber
# the windows.
```

### Resources

* [tmux: Productive Mouse-Free Development](http://pragprog.com/book/bhtmux/tmux)
* [How to reorder windows](http://superuser.com/questions/343572/tmux-how-do-i-reorder-my-windows)

### Changelog

* 1411143833002 - Added [toggle zoom] under Panes (splits) section.
* 1411143833002 - [Added Sync Panes]
* 1414276652677 - [Added Kill all tmux sessions ]
* 1438585211173 - [corrected create and add next and previus thanks to @justinjhendrick]
* 1676001639197 - [corrected a typo Thanks to @justinjhendrick](#resizing-panes)

### Request an Update

We Noticed that our Cheatsheet is growing and people are coloberating to add new tips and tricks, so please tweet to me what would you like to add and let's make it better!

* Twitter: [@MohammedAlaa](http://twitter.com/MohammedAlaa)

---

## .tmux.conf

### macOS prerequisites

#### [Resizing pane with C-B + arrow keys is not working for tmux on mac?](https://superuser.com/questions/660013/resizing-pane-is-not-working-for-tmux-on-mac)

**Question**

After searching through, I figured ctrl+b ( PREFIX ) then ctrl + arrow should resize the current pane. But it is not working. Am I missing anything ?

Thanks.

**Answer**

Probably your terminal is not sending a (distinct) sequence when you hold Control and press an arrow key.

Try running `cat` and typing the keys into it (Control-C to quit). You will probably find that (e.g.) Up and Control-Up both generate the same sequence.

**OS X *Terminal* application**

In its default configuration the OS X *Terminal* application sends the sequence `^[[A` (or `^[OA`) whether you type Up or Control-Up (also any combination with Shift and Option, too).

However, you can reconfigure *Terminal* to send appropriate codes. It is a bit tedious, but you usually only have to do it once.

1. *Terminal* > **Preferences…**

2. **Settings** top-level tab

3. pick the profile you want to modify

4. **Keyboard** tab

5. click the plus button to add a new binding

   * pick a cursor key

   * set the modifier to `control`

   * use the `Send Text:` action

   * type `Escape`

     (will show up as `\033`) followed by `[1;5` and one more character:

     * `A` for Up,
     * `B` for Down,
     * `C` for Right, or
     * `D` for Left

   * click **OK** to add the binding

For example, the final sequence for Control-Up should end up looking like `\033[1;5A`.

These sequences are the ones that XTerm generates (see the [ctlseqs](http://invisible-island.net/xterm/ctlseqs/ctlseqs.html) documentation for details).

Repeat the last step for the other arrow keys.

---

### [How to copy and paste with a mouse with tmux](https://unix.stackexchange.com/questions/318281/how-to-copy-and-paste-with-a-mouse-with-tmux)

Put this block of code in your `~/.tmux.conf`. This will enable mouse integration letting you copy from a pane with your mouse without having to zoom.

#### macOS old .tmux.conf

```properties
set -g mouse on
bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
bind -n WheelDownPane select-pane -t= \; send-keys -M
bind -n C-WheelUpPane select-pane -t= \; copy-mode -e \; send-keys -M
bind -t vi-copy    C-WheelUpPane   halfpage-up
bind -t vi-copy    C-WheelDownPane halfpage-down
bind -t emacs-copy C-WheelUpPane   halfpage-up
bind -t emacs-copy C-WheelDownPane halfpage-down

# To copy, drag to highlight text in yellow, press Enter and then release mouse
# Use vim keybindings in copy mode
setw -g mode-keys vi
# Update default binding of `Enter` to also use copy-pipe
unbind -t vi-copy Enter
bind-key -t vi-copy Enter copy-pipe "pbcopy"
```

After that, restart your tmux session. Highlight some text with mouse, but don't let go the mouse. Now while the text is stil highlighted and mouse pressed, press return key. The highlighted text will disappear and will be copied to your clipboard. Now release the mouse.

Apart from this, there are also some cool things you can do with the mouse like scroll up and down, select the active pane, etc.

If you are using a **newer version of tmux** on macOS, try the following instead of the one above:

#### macOS new .tmux.conf

```properties
# macOS only
set -g mouse on
bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
bind -n WheelDownPane select-pane -t= \; send-keys -M
bind -n C-WheelUpPane select-pane -t= \; copy-mode -e \; send-keys -M
bind -T copy-mode-vi    C-WheelUpPane   send-keys -X halfpage-up
bind -T copy-mode-vi    C-WheelDownPane send-keys -X halfpage-down
bind -T copy-mode-emacs C-WheelUpPane   send-keys -X halfpage-up
bind -T copy-mode-emacs C-WheelDownPane send-keys -X halfpage-down

# To copy, left click and drag to highlight text in yellow, 
# once you release left click yellow text will disappear and will automatically be available in clibboard
# # Use vim keybindings in copy mode
setw -g mode-keys vi
# Update default binding of `Enter` to also use copy-pipe
unbind -T copy-mode-vi Enter
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
```

If using iTerm on macOS, goto iTerm2 > Preferences > “General” tab, and in the “Selection” section, check “Applications in terminal may access clipboard”.

And if you are using **Linux** and a newer version of tmux, then

#### Linux .tmux.conf

```properties
# Linux only
set -g mouse on
bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
bind -n WheelDownPane select-pane -t= \; send-keys -M
bind -n C-WheelUpPane select-pane -t= \; copy-mode -e \; send-keys -M
bind -T copy-mode-vi    C-WheelUpPane   send-keys -X halfpage-up
bind -T copy-mode-vi    C-WheelDownPane send-keys -X halfpage-down
bind -T copy-mode-emacs C-WheelUpPane   send-keys -X halfpage-up
bind -T copy-mode-emacs C-WheelDownPane send-keys -X halfpage-down

# To copy, left click and drag to highlight text in yellow, 
# once you release left click yellow text will disappear and will automatically be available in clibboard
# # Use vim keybindings in copy mode
setw -g mode-keys vi
# Update default binding of `Enter` to also use copy-pipe
unbind -T copy-mode-vi Enter
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xclip -selection c"
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
```

In Debian and Debian based distros (Ubuntu, Kali), you might need to install `xclip`:

```sh
sudo apt-get install -y xclip
```

(You may also check out <https://github.com/gpakosz/.tmux> for many other tmux options.)

---

### Automatically renumber windows

add to *.tmux.conf*

```properties
set -g renumber-windows on
# renumber-windows [on | off]
# If on, when a window is closed in a session, automatically renumber
# the other windows in numerical order.  This respects the
# base-index option if it has been set.  If off, do not renumber
# the windows.
```
