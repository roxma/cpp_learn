
# Environment setup

Compile vim from source with:

	./configure --prefix=$(readlink -f ~/roxma/.local_vim)/ --with-features=huge  --enable-pythoninterp && make && make install


Compile cmake from source with:

	mkdir ~/.local_cmake
	./configure --prefix=$(readlink -f ~/.local_cmake)/
	make && make install




# A Minimum List of Useful Commands:


### Normal mode Movint

- `Ctrl-O`	Jump back to the previous (older) location. Use the ':jumps' command to see a list of jump history.
- `Ctrl-I`	(same as Tab) Jump forward to the next (newer) location.
- `Ctrl-]`	go to definition
- `Ctrl-w Ctrl-]` Open the definition in a horizontal split


### Command Line editing

- `Ctrl-B`	Move to beginning of command line.
- `Ctrl-E`	Move to end of command line.
- `Ctrl-W`	Delete the word before the cursor.
- `Ctrl-U`	Delete all words before the cursor.
- `Ctrl-F`	Open command line window.
- `v` `e` `y` to select a word, and then `:<C-r>0` to paste the word to command line. where `0` is the register.


### Search and Replace

- Replace one by one
    - `:s/search_string/replace_string/` to replace the first string found in the cursor line, Then `n` to find the next, then `&` to repeat the last substitute command.
        - `s`   substitute

- Replace all
    - `:%s/search_string/replace_string/g`
        - `%`	Traverse and Execute all lines
        - `g`	Replace all occurance in the line.
- Replace inside blocks
    - `v` or `V`, and then `:s/search_string/replace_string/`


### Formatting

- `gq`  Format lines according to `textwidth`
- `=` Auto indent

### Diff

- `vimdiff  FILE_LEFT  FILE_RIGHT` or `vim -d  FILE_LEFT  FILE_RIGHT` or `:vertical diffsplit FILE_RIGHT`


### Paste

- `:set paste` and `:set nopaste`, used to paste some snippet of code, that already has indentatio.
- `ctrl-r 0` to paste register 0 content in insert mode. `:register` to see the registers' values.


### External Commands

- `:sh`			Open a bash shell.
- `:read !cmd`	Execute a shell command, read the output into vim.


## Makefile

- `:set makegrp=make\ all` and then `:make`. `:make` will compile if you are using a Makefile. Use these to examine the compile errors:
-  `:copen` open a mini-window with list of errors 
-  hit enter on an error to jump to line 
- `:cclose` closes the mini-window
- `:cw` toggles the mini-window (if errors exist)

