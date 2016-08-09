
" You should execute :PlugInstall to install plugins when open vim for the
" first time

call plug#begin(s:customvimrc_vim_dir . '/plugged/')

" Plug 'altercation/vim-colors-solarized'
" Plug 'noahfrederick/vim-noctu'
" Plug 'w0ng/vim-hybrid'
Plug 'morhetz/gruvbox'
" Plug 'flazz/vim-colorschemes'

Plug 'simeji/winresizer'
Plug 'bling/vim-airline'

" I use my own simple configuration, don't need this plugin anymore
" Plug 'edkolev/tmuxline.vim'

" git
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'airblade/vim-gitgutter'

Plug 'godlygeek/tabular'
" vim-surround have nice key mappings, but still I think it's too limited and
" complicated.
" cool, but still have some confuzing issues, not what I want
" Plug 'terryma/vim-multiple-cursors'
Plug 'dhruvasagar/vim-table-mode'

Plug 'Lokaltog/vim-easymotion'

" YouCompleteMe slow down vim's start time, replace it with SimpleAutoComplPop
" Plug 'Valloric/YouCompleteMe'
Plug 'roxma/SimpleAutoComplPop'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'

" need to install the_silver_searcher first: https://github.com/ggreer/the_silver_searcher
Plug 'rking/ag.vim'
" Replace ctrlp with fzf
" Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', { 'do': './install --no-key-bindings --no-completion --no-update-rc' } " only install fzf for vim
Plug 'junegunn/fzf.vim'
" for the enhanced <Leader>* key
Plug 'haya14busa/vim-asterisk'

Plug 'scrooloose/syntastic'

" html
Plug 'othree/html5.vim'

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


Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'roxma/vim-tmux-clipboard'

" crashes if no man page found
" Plug 'jez/vim-superman'

" not needed
" Plug 'christoomey/vim-tmux-navigator'

" Can't match JavaScript inside html <script> tag
" Plug 'tmhedberg/matchit'

" Browse hacker news in vim
" Plug 'ryanss/vim-hackernews'

call plug#end()

