
" You should execute :PlugInstall to install plugins when open vim for the
" first time

call plug#begin(s:customvimrc_vim_dir . '/plugged/')

Plug 'altercation/vim-colors-solarized'
Plug 'noahfrederick/vim-noctu'

Plug 'simeji/winresizer'
Plug 'bling/vim-airline'
Plug 'edkolev/tmuxline.vim'

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'scrooloose/nerdtree'
Plug 'godlygeek/tabular'
Plug 'Lokaltog/vim-easymotion'


Plug 'majutsushi/tagbar'
Plug 'dhruvasagar/vim-table-mode'
" YouCompleteMe slow down vim's start time, replace it with SimpleAutoComplPop
" Plug 'Valloric/YouCompleteMe'
Plug 'roxma/SimpleAutoComplPop'


" need to install the_silver_searcher first: https://github.com/ggreer/the_silver_searcher
Plug 'rking/ag.vim'
" Replace ctrlp with fzf
" Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', { 'do': './install --no-key-bindings --no-completion --no-update-rc' } " only install fzf for vim
Plug 'junegunn/fzf.vim'
" for the enhanced <Leader>* key
Plug 'haya14busa/vim-asterisk'

Plug 'scrooloose/syntastic'

" markdown
Plug 'plasticboy/vim-markdown'

" php
" Use my own forked repo, I'm planning on performance improvment
Plug 'roxma/phpcomplete.vim'

" vim go
Plug 'fatih/vim-go'

" web front-end
Plug 'jelera/vim-javascript-syntax'
Plug 'mattn/emmet-vim'

" not needed
" Plug 'christoomey/vim-tmux-navigator'

" Can't match JavaScript inside html <script> tag
" Plug 'tmhedberg/matchit'

" Browse hacker news in vim
" Plug 'ryanss/vim-hackernews'

call plug#end()

