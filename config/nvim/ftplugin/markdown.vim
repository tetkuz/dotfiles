setlocal foldmethod=expr
setlocal foldexpr=MarkdownFoldLevel(v:lnum)

function! MarkdownFoldLevel(lnum)
	let line = getline(a:lnum)
	let depth = len(matchstr(line, '^#\{1,6\}'))
	if depth > 0
		return '>' . depth
	endif
	return '='
endfunction
