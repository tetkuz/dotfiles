" Default Coding style
let g:gnu=1

if exists("g:gnu") " GNU Coding style
  setlocal expandtab
  setlocal sw=2 ts=8 tw=80
  setlocal cinoptions=>2s,e-s,n-s,{s,^-s,:s,=s,g0,+.5s,p2s,t0,(0,W2,u0,w1,m1,l1
  setlocal cindent
  setlocal fo-=t fo+=croql
  setlocal comments=sO:*\ -,mO:\ \ \ ,exO:*/,s1:/*,mb:\ ,ex:*/
  set cpo-=C
  "setlocal equalprg=~/src/gst/common/gst-indent\ 2>\ /dev/null
elseif exists("g:kernel")
  setlocal sw=8 ts=8 sts=8 tw=80
  setlocal noexpandtab
  setlocal cinoptions=:0,l1,t0,g0,(0
  setlocal cindent
else
  setlocal noexpandtab
  setlocal sw=4 ts=4 tw=80
  setlocal cinoptions+=t0
endif


let glib_deprecated_errors = 1
let gtk3_deprecated_errors = 1
let gstreamer_deprecated_errors = 1

runtime! syntax/glib.vim
runtime! syntax/gtk3.vim
runtime! syntax/gstreamer.vim
