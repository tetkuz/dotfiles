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

set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
call dein#begin(expand('~/.cache/dein'))
call dein#add('Shougo/dein.vim')
" Plugins {{{
call dein#add('Rip-Rip/clang_complete')
call dein#add('Shougo/denite.nvim')
call dein#add('Shougo/deoplete.nvim')
call dein#add('Shougo/neoinclude.vim')
call dein#add('Shougo/neomru.vim')
call dein#add('Shougo/neosnippet-snippets')
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
call dein#add('bling/vim-airline')
call dein#add('cakebaker/scss-syntax.vim')
call dein#add('cespare/vim-toml')
call dein#add('hail2u/vim-css3-syntax')
call dein#add('junegunn/vim-easy-align')
call dein#add('kana/vim-smartinput')
call dein#add('majutsushi/tagbar')
call dein#add('mattn/emmet-vim')
call dein#add('mattn/gist-vim')
call dein#add('mattn/webapi-vim')
call dein#add('morhetz/gruvbox')
call dein#add('othree/html5.vim')
call dein#add('othree/javascript-libraries-syntax.vim')
call dein#add('rhysd/vim-gfm-syntax')
call dein#add('rking/ag.vim')
call dein#add('scrooloose/nerdtree')
call dein#add('scrooloose/syntastic')
call dein#add('thiblahute/vim-devhelp')
call dein#add('tpope/vim-abolish')
call dein#add('tpope/vim-endwise')
call dein#add('tpope/vim-rails')
call dein#add('tpope/vim-surround')
call dein#add('vim-scripts/gtk-vim-syntax')
call dein#add('vimwiki/vimwiki')
call dein#add('vivien/vim-linux-coding-style')
" }}}
call dein#end()

filetype plugin indent on

if dein#check_install()
  call dein#install()
endif

set background=dark
colorscheme gruvbox

nnoremap <silent> ,r :Denite file_mru<CR>
nnoremap <silent> ,f :Denite file_rec<CR>
call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')

imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

let g:deoplete#sources#clang#libclang_path='/usr/lib/llvm-3.8/lib/libclang.so.1'
let g:deoplete#sources#clang#clang_header='/usr/lib/llvm-3.8/lib/clang/3.8.1/include'
let g:deoplete#auto_complete_delay=100
let g:deoplete#enable_at_startup=1

nnoremap <silent> <leader>t :TagbarToggle<CR>
let g:devhelpSearch=1

let g:linuxsty_patterns = [ "/usr/src/", "/linux" ]

let g:clang_complete_auto = 0
let g:clang_auto_select = 0
let g:clang_omnicppcomplete_compliance = 0
let g:clang_make_default_keymappings = 0
"let g:clang_use_library = 1
let g:clang_library_path='/usr/lib/llvm-3.8/lib/libclang.so.1'

let g:surround_{char2nr('-')} = "<% \r %>"
let g:surround_{char2nr('=')} = "<%= \r %>"
