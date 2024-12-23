call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

inoremap jj <Esc>
nnoremap ff :Files <CR>
nnoremap gf :GFiles <CR>
nnoremap rr :Rg
set nu
set noswapfile
filetype plugin indent on
if has("syntax")
	syntax on
endif
set tabstop=2       " Number of visual spaces per TAB
set shiftwidth=2    " Number of spaces to use for each step of (auto)indent
set expandtab       " Use spaces instead of tabs
