

" disable default behavior for php
let g:sacpDefaultFileTypesEnable = { "php":0, "markdown":1, "text":1, "go":1}

autocmd FileType php,php5,php7 call sacp#enableForThisBuffer({ "matches": [
			\ { '=~': '\v[a-zA-Z]{4}$', 'feedkeys': "\<Plug>(sacp_cache_fuzzy_omnicomplete)"},
			\ { '=~': '::$'           , 'feedkeys': "\<Plug>(sacp_cache_fuzzy_omnicomplete)"},
			\ { '=~': '->$'           , 'feedkeys': "\<Plug>(sacp_cache_fuzzy_omnicomplete)"},
			\ ]
			\ })




