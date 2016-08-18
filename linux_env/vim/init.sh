
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
			let s:customvimrc_local_software_dir='$(pwd)/.local_software/'
			let s:customvimrc_vim_dir='$(pwd)/${localVimDir}/'

			source $(pwd)/${localVimDir}/plugins/vim-plug/plug.vim
			set nocompatible
			syntax on
			filetype plugin indent on
			" > ${customVimrcFile}.tmp
			cat ${customVimrcFile} >> ${customVimrcFile}.tmp
			mv ${customVimrcFile}.tmp ${customVimrcFile}
			#
			###

			# If plugins has changed
			if [[ "$(roxma_vim_plugins_tgz_encoded_content_md5sum)" != "$(cat ${localVimDir}/plugins_md5sum.txt 2>/dev/null )" ]]
			then

				# clean old plugins
				rm -rf ${localVimDir}/plugins_md5sum.txt ${localVimDir}/plugins ${localVimDir}/plugins.tar.gz ${localVimDir}/bundle ${localVimDir}/vim-pathogen-master

				# decompress new vim plugins
				echo "$(roxma_vim_plugins_tgz_encoded)" | base64_decode > ${localVimDir}/plugins.tar.gz			# plugins.tar.gz
				tar -zxf ${localVimDir}/plugins.tar.gz -C ${localVimDir}/ && rm ${localVimDir}/plugins.tar.gz	# decompress plugins.tar.gz
				roxma_vim_plugins_tgz_encoded_content_md5sum > ${localVimDir}/plugins_md5sum.txt
			fi

		} | tee

	fi
}

eval "$( (_roxma_vim_env_init) 3>&1 1>&2)"

