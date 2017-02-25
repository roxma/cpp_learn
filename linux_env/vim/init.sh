
##
# user fd 3 to output bashrc to eval
function _roxma_vim_env_init()
{

	cd $(dirname ${BASH_SOURCE[0]})
	localVimDir=".local_software/vim"
	if [ -f $(pwd)/${localVimDir}/bin/vim ]
	then
		# use --cmd option to execute cmd before any vimrc file loaded to make pathogen work
		customVimrcFile=$(roxma_vim_rcfile)

		echo 'unalias vim 2>/dev/null'  1>&3 
		unalias vim 2>/dev/null
		alias vim="$(pwd)/${localVimDir}/bin/vim -u \"$customVimrcFile\""
		alias vim  1>&3
		alias vim

		# separate process
		{

			###
			# prepend some script to the vimrc file:
			# 1. set custom vimrc environment variables
			# 2. add vim-plug to rtp
			echo "
			set nocompatible
			syntax on
			filetype plugin indent on
			set encoding=utf-8 fileencodings=ucs-bom,utf-8,gbk,gb18030,latin1 termencoding=utf-8
			source $(pwd)/${localVimDir}/plugins/vim-plug/plug.vim
			set rtp+=$(pwd)/${localVimDir}/plugins/vim-tweak
			try
				call tweak#bootstrap('$(pwd)/${localVimDir}/plugged/')
			catch /\V\^Vim(call):E117: Unknown function: tweak#bootstrap\$/
				let l:dummp = 0
			endtry
			if has('win32') || has('win64')
				\" 解决 windows 乱码
				source $VIMRUNTIME/delmenu.vim
				source $VIMRUNTIME/menu.vim

				if has('gui')
					set guioptions-=m  \"remove menu bar
					set guioptions-=T  \"remove toolbar
					set guioptions-=r  \"remove right-hand scroll bar
					set guioptions-=L  \"remove left-hand scroll bar
				endif
			endif
			" > ${customVimrcFile}.tmp
			cat ${customVimrcFile} >> ${customVimrcFile}.tmp
			mv ${customVimrcFile}.tmp ${customVimrcFile}
			#
			###

			# If plugins has changed
			if [ ! -d $(pwd)/${localVimDir}/plugins ]
			then
				# decompress new vim plugins
				echo "$(roxma_vim_plugins_tgz_encoded)" | base64_decode > ${localVimDir}/plugins.tar.gz			# plugins.tar.gz
				tar -zxf ${localVimDir}/plugins.tar.gz -C ${localVimDir}/ && rm ${localVimDir}/plugins.tar.gz	# decompress plugins.tar.gz
				(
				cd $(pwd)/${localVimDir}/plugins
				mv vim-tweak vim-tweak.bak
				git clone git@github.com:roxma/vim-tweak.git
				if [ "$?" != 0 ]
				then
					mv vim-tweak.bak vim-tweak
				else
					true
				fi
				)
			fi

		} | tee

	fi
}

eval "$( (_roxma_vim_env_init) 3>&1 1>&2)"

