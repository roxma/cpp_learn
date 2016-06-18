""
" load vimrc files in the "'s:customvimrc_local_software_dir' . '/user_vimrc/'"
" directory

if exists("s:customvimrc_local_software_dir")
	let s:userVimrcFiels = glob(s:customvimrc_local_software_dir . "/user_vimrc/*.vimrc")
	let s:userVimrcFielsArr = split(s:userVimrcFiels)
	for s:f in s:userVimrcFielsArr
		execute "source " . s:f
	endfor
endif
