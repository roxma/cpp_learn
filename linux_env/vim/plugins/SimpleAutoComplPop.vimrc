

" disable default behavior for php
let g:sacpDefaultFileTypesEnable = { "php":0, "markdown":1, "text":1, "go":1}

" 1. matches local variables
autocmd FileType php,php5,php7 call sacp#enableForThisBuffer({ "matches": [
			\ { '=~': '\$\w\{2,}$'     , 'feedkeys': "\<C-X>\<C-n>"},
			\ { '=~': '\v[a-zA-Z]{3,}$', 'feedkeys': "\<Plug>(sacp_cache_fuzzy_omnicomplete)"},
			\ { '=~': '::$'            , 'feedkeys': "\<Plug>(sacp_cache_fuzzy_omnicomplete)"},
			\ { '=~': '->$'            , 'feedkeys': "\<Plug>(sacp_cache_fuzzy_omnicomplete)"},
			\ ]
			\ })




