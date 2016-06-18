""
" Parse and execute vimscript in c/cpp file
"
" for example: (test.cpp)
" /**
"  * @vimrc let &l:makeprg='cd ' . expand('%:p:h') . ' && g++ test.cpp -o test.o'
"  */
"

"""
" Secirity issue
"""

autocmd FileType c,cpp call CFileLocalVimrc()

function! CFileLocalVimrc()
	
	let l:l = 1
	let l:skipThis=1

	" check first line
	let l:lineArr = getbufline('%',l)
	if ( len(l:lineArr)==0)   " empty file
		return
	endif
	let l:lineStr = l:lineArr[0]
	if ( l:lineStr !~ '^\/\*\*$' )				" /** first line
		return
	endif

	let l:l = l:l+1
	while (1)

		let l:lineArr = getbufline("%",l)
		if ( len(l:lineArr)==0)
			call cursor(l:l-1, 1)
			return
		endif

		let l:lineStr = l:lineArr[0]
		if(l:lineStr !~ '^\s\*')
			return
		endif

		if(l:lineStr =~ '^\s\*\s@vimrc')
			let l:toExecute = substitute(l:lineStr,'^\s\*\s@vimrc','','')
			" silent execute '!echo l:toExecute'
			execute l:toExecute
		endif
      
		let l:l = l:l+1
	endwhile

endfunction

