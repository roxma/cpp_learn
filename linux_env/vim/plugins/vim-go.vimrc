
let g:go_auto_type_info=1

" disable go fmt on siave
let g:go_fmt_autosave = 0

" turn highlighting on
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" autocmd FileType go nmap <buffer>  <C-w><C-]> <Plug>(go-def-split)
autocmd FileType go nnoremap <buffer> <silent> <C-w><C-]> :<C-u>call go#def#Jump("split")<CR>
" autocmd FileType go nnoremap <buffer> <C-w><C-]> :<C-u>call go#def#Jump("split")<CR>

