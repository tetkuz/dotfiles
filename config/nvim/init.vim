" vim:foldmethod=marker
" My sets {{{
syntax on
set relativenumber
set ruler
set cursorline
set cursorcolumn
set laststatus=2
set showmatch
set ambiwidth=double
set hlsearch
set display=lastline
set fillchars=
set spelllang=en,cjk
set splitbelow
set pumheight=10
set history=10000
set noexpandtab
set autoindent
set wildmode=list,full
set completeopt=preview
set smartindent
set autoread
set nobackup
set noswapfile
set noundofile
set hlsearch
set incsearch
set ignorecase
set smartcase
set nowrapscan
set clipboard+=unnamedplus
set mouse+=a
set list
set listchars=tab:»\ ,nbsp:%
" }}}
" My maps {{{
nnoremap <M-t> :split term://zsh<CR>i
nnoremap <M-T> :tabnew term://zsh<CR>i
nnoremap x "_x
nmap Y y$
nnoremap tw "adiwP
nnoremap <Space>h :<C-u>tab help<Space>
nnoremap <Space>vh :<C-u>vertical belowright help<Space>
nnoremap <Space>. :<C-u>tabedit $MYVIMRC<CR>
nnoremap <silent> <ESC><ESC> :noh<CR>
nnoremap gcd :cd %:h<CR>
nnoremap / :set hlsearch<CR>/
nnoremap gr gT
nnoremap T :tabnew<CR>
vnoremap <M-g> y:!chromium "http://www.google.com/search?q=<C-R>""\ &<CR>
" }}}
" My autocommads {{{
au BufWritePre * %s/\s\+$//e
au FileType ruby,eruby,html,javascript set sw=2 sts=2 et
" }}}
let g:python3_host_prog = '/usr/bin/python3'

if &compatible
  set nocompatible
endif

let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/dein.toml'

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir, [$MYVIMRC, s:toml_file])
  call dein#load_toml(s:toml_file)
  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on

if dein#check_install()
  call dein#install()
endif

