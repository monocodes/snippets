---
title: Vim
categories:
  - vim
  - notes
  - guides
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [vim commands](#vim-commands)
  - [Command Mode](#command-mode)
  - [Extended Mode: (Colon Mode)](#extended-mode-colon-mode)
    - [Extended Mode - additional commands](#extended-mode---additional-commands)
- [.vimrc](#vimrc)
- [neovim install](#neovim-install)
  - [neovim paths](#neovim-paths)
  - [macos](#macos)
  - [linux](#linux)

## vim commands

This is command mode editor for files. Other editors in Linux are emacs, gedit vi editor is most popular
It has 3 modes:

1. **Command Mode**
2. **Insert mode** (edit mode)
3. **Extended mode (Colon Mode)**

Note: When you open the vim editor, it will be in the **command mode** by default.

---

### Command Mode

- gg - To go to the beginning of the page
- G - To go to end of the page
- w - To move the cursor forward, word by word
- b - To move the cursor backward, word by word
- nw - To move the cursor forward to n words (SW)
- nb - To move the cursor backward to n words (SB)
- u - To undo last change (word)
- Ctrl+R - To redo the changes
- U - To undo the previous changes (entire line)
- VY - To copy a line
- nyy - To copy n lines (Syy or 4yy)
- p - To paste line below the cursor position
- dw - To delete the word letter by letter {like Backspace}
- x - To paste line above the cursor position
- X - To delete the world letter by letter (like DEL Key)
- dd - To delete entire line
- ndd - To delete n no. of lines from cursor position (Sdd)
- gg - dG - delete all lines in file (need to be at the beginning of the file)
- / - To search a word in the file
  - n - to next result
  - N - to previous result

---

### Extended Mode: (Colon Mode)

Extended Mode is used for save and quit or save without quit using `Esc` Key with `:`

- Esc+:w - To Save the changes
- Esc+:q - To quit (Without saving)
- Esc+:wq - To save and quit
- Esc+:w! - To save forcefully
- Esc+wq! - To save and quit forcefully
- Esc+:x - To save and quit
- Esc+:X - To give passw or d to the file and remove password
- Esc+:20(n) - To go to line no 20 or n
- Esc+: se nu - To set the line numbers to the file !
- Esc+: se nonu - To Remove the set line numbers

---

#### Extended Mode - additional commands

search and replace only once every line

```sh
:%s/word-to-replace/word-that-replace

# example
:%s/coronavirus/covid19
```

search and replace g - globally (more than one time in line)

```sh
:%s/word-to-replace/word-that-replace/g

# example
:%s/coronavirus/covid19/g
```

search and replace g - globally (more than one time in line) with nothing

```sh
:%s/word-to-replace//g

# example
:%s/coronavirus//g
```

search and replace whitespaces from the start of each line

```sh
# example with 4 spaces

:%s/^    //
```

search and replace with delimiters

- *example* with `apt` `sources.list`

  - make `sources.list` backup

  - ```sh
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
    ```

  - ```sh
    sudo vim /etc/apt/sources.list
    ```

  - `:` to enter colon mode in `vim`

  - switch to main repos

  - ```properties
    %s/http:\/\/us\./http:\/\//g
    ```

  - or to Armenia repos

  - ```properties
    %s/http:\/\/ru\./http:\/\/am\./g
    ```

---

## .vimrc

Enable syntax in vim

```sh
echo "syntax on" >> ~/.vimrc
```

If you get this error:

```sh
No Syntax items defined for this buffer
```

Add this to `~/.vimrc`

```sh
filetype plugin indent on
syntax on
# or
echo -e "filetype plugin indent on\nsyntax on" >> ~/.vimrc
```

Fix “not working” `backspace` in `vim`:

```sh
$ echo "set backspace=indent,eol,start" >> ~/.vimrc
```

Fix “not working” `backspace` in `vi`:

```sh
$ echo "set backspace=indent,eol,start" >> ~/.exrc
```

---

## Netrw Cheatsheet (Vim's File Browser)

See also:

* [vinegar.vim](https://github.com/tpope/vim-vinegar), which makes <kbd>-</kbd> open netrw in the directory of the current file, with the cursor on the current file (and pressing <kbd>-</kbd> again goes up a directory). Vinegar also hides a bunch of junk that's normally at the top of netrw windows, changes the default order of files, and hides files that match `wildignore`.

  With vinegar, <kbd>.</kbd> in netrw opens Vim's command line with the path to the file under the cursor at the end of the command. <kbd>!</kbd> does the same but also prepends `!` at the start of the command. <kbd><kbd>y</kbd><kbd>.</kbd></kbd> copies the absolute path of the file under the cursor. <kbd>~</kbd> goes to your home dir. <kbd><kbd>Ctrl</kbd>+<kbd>6</kbd></kbd> goes back to the file (buffer) that you had open before you opened netrw.

To launch netrw:

* Run `vim` with a directory as the command-line argument
* <kbd>:edit path/to/a/directory <kbd>Enter</kbd></kbd> (or <kbd>:e <path/to/a/directory</kbd>)
* <kbd>:e .</kbd> to open the current working directory
* <kbd>:Explore</kbd> or <kbd>:E</kbd>opens netrw in the directory of the current file
* `:Sexplore` or `:Sex` launches netrw in a new split window below the current
  window (`:split .` or `:sp .` will do the same, but open the current working
  directory instead of the directory of the current file)
* `:Vexplore` or `:Vex` launches netrw in a new split window left of the current
  window (`:vsplit .` or `:vs .` will do the same, but open the current working
  directory instead of the directory of the current file, and to the right
  instead of to the left for some reason)

You can use all the normal vim movement commands to move around within a netrw
buffer, including search! And you `Enter` to open the file or directory under
the cursor.

Other netrw commands:

* `%` creates a new file (not saved to the filesystem until you save it)
* `d` creates a new directory (immediately)
* See netrw's quick help menu (`I`) for deleting and renaming files

**See Also**

* Vimcasts on netrw: http://vimcasts.org/episodes/the-file-explorer/
* Vimcasts "oil and vinegar" post about why netrw works in normal vim buffers
  instead of in a sidebar or project drawer: http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/

---

## neovim install

> This scripts will be usable when I decide to migrate to **neovim** from **vim**.
>
> `set number` + `set mouse=` are not very usable because in that way you will copy numbers with text from terminal.
>
> So, I need to use **VISUAL** mode of **neovim/vim** or do not use line numbers.

### neovim paths

user config

```sh
~/.config/nvim/init.vim
```

### macos

neovim install one-liner

```sh
brew install neovim && \
  mkdir -p ~/.config/nvim/ ; \
  echo -e 'set number\nset mouse=' >> ~/.config/nvim/init.vim && \
  if test ~/.profile
  echo -e 'export EDITOR=nvim' >> ~/.bash_profile
```

### linux

Install it with default package manager or use **linuxbrew**

```sh
brew install neovim && \
	mkdir -p ~/.config/nvim/ ; \
  echo -e 'set number\nset mouse=' >> ~/.config/nvim/init.vim && \
  sudo mkdir -p /root/.config/nvim ; \
  echo -e 'set number\nset mouse=' | sudo tee -a /root/.config/nvim/init.vim && \
  [ -e ~/.bash_profile ] && \
  echo -e 'export EDITOR=nvim\nalias vim=nvim' >> ~/.bash_profile && \
  echo -e 'export EDITOR=nvim\nalias vim=nvim' | sudo tee -a /root/.bash_profile && \
  source ~/.bash_profile ; \
  [ -e ~/.profile ] && \
  echo -e 'export EDITOR=nvim\nalias vim=nvim' >> ~/.profile && \
  echo -e 'export EDITOR=nvim\nalias vim=nvim' | sudo tee -a /root/.profile && \
  source ~/.profile
```

---
