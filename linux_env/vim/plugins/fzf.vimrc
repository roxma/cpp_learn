
" fzf files
nnoremap <C-f><C-f> :FZF<CR>
nnoremap <C-f>f     :FZF<CR>
nnoremap <Leader>f  :FZF<CR>


" fzf mru
function! s:fzf_all_files()
  return extend(
  \ filter(copy(v:oldfiles),
  \        "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/'"),
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

command! FZFMru call fzf#run({
\ 'source':  reverse(s:fzf_all_files()),
\ 'sink':    'edit',
\ 'options': '-m -x +s',
\ 'down':    '40%' })

nnoremap <C-f><C-m> :FZFMru<CR>
nnoremap <C-f>m     :FZFMru<CR>


" fzf buffer list
function! s:fzf_buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:fzf_bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

command! FZFBuffer call fzf#run({ 'source':  reverse(s:fzf_buflist()), 'sink':    function('<sid>fzf_bufopen'), 'options': '+m', 'down':    len(s:fzf_buflist()) + 2 })
nnoremap <C-f><C-b> :FZFBuffer<CR>
nnoremap <C-f>b     :FZFBuffer<CR>
nnoremap <Leader>b  :FZFBuffer<CR>


" fzf lines

function! s:fzf_line_handler(l)
  let keys = split(a:l, ':\t')
  exec 'buf' keys[0]
  exec keys[1]
  normal! ^zz
endfunction

function! s:fzf_buffer_lines()
  let res = []
  for b in filter(range(1, bufnr('$')), 'buflisted(v:val)')
    call extend(res, map(getbufline(b,0,"$"), 'b . ":\t" . (v:key + 1) . ":\t" . v:val '))
  endfor
  return res
endfunction

command! FZFLines call fzf#run({
\   'source':  <sid>fzf_buffer_lines(),
\   'sink':    function('<sid>fzf_line_handler'),
\   'options': '--extended --nth=3..',
\   'down':    '60%'
\})

nnoremap <C-f>l  	 :FZFLines<CR>
nnoremap <C-f><C-l>  :FZFLines<CR>

