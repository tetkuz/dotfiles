" GNU Coding style
setlocal expandtab
setlocal sw=2 ts=8 tw=78
setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
setlocal cindent
setlocal fo-=t fo+=croql
setlocal comments=sO:*\ -,mO:\ \ \ ,exO:*/,s1:/*,mb:\ ,ex:*/
set cpo-=C

let glib_deprecated_errors = 1
let gtk3_deprecated_errors = 1
let gstreamer_deprecated_errors = 1

runtime! syntax/glib.vim
runtime! syntax/gtk3.vim
runtime! syntax/gstreamer.vim
