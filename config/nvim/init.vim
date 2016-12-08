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
vnoremap <C-Space> y:!google-chrome "http://www.google.com/search?q=<C-R>""<CR>
" }}}
let g:python3_host_prog = '/usr/bin/python3'

if &compatible
  set nocompatible
endif

set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
call dein#begin(expand('~/.cache/dein'))
call dein#add('Shougo/dein.vim')
" Plugins {{{
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/neosnippet-snippets')
call dein#add('Shougo/neomru.vim')
call dein#add('Shougo/denite.nvim')
call dein#add('Shougo/deoplete.nvim')
call dein#add('bling/vim-airline')
call dein#add('morhetz/gruvbox')
call dein#add('scrooloose/nerdtree', { 'if': '0' } )
call dein#add('tpope/vim-surround')
call dein#add('junegunn/vim-easy-align')
call dein#add('tpope/vim-abolish')
call dein#add('rking/ag.vim')
call dein#add('kana/vim-smartinput')
call dein#add('scrooloose/syntastic')
call dein#add('mattn/webapi-vim')
call dein#add('mattn/gist-vim')
call dein#add('vimwiki/vimwiki')
" }}}
call dein#end()

filetype plugin indent on

if dein#check_install()
  call dein#install()
endif

set background=dark
colorscheme gruvbox

imap <Tab>     <Plug>(neosnippet_expand_or_jump)
smap <Tab>     <Plug>(neosnippet_expand_or_jump)
xmap <Tab>     <Plug>(neosnippet_expand_target)

nnoremap <silent> ,r :Denite file_mru<CR>
nnoremap <silent> ,f :Denite file_rec<CR>
"call denite#custom#map('insert', '<C-n>', 'move_to_next_line')
"call denite#custom#map('insert', '<C-p>', 'move_to_prev_line')

let g:deoplete#enable_at_startup = 1
