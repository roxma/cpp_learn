

" only enable for php complications
let g:ycm_filetype_whitelist = {"php":1}

""
" NOTICE: The  regex is python's syntax
" 3 characters to 
let g:ycm_semantic_triggers.php =  ['->','::','re![_a-zA-Z]{3,}']

