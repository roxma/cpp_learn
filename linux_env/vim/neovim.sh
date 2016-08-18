
##
# This script is used to setup the user's nvim environment, including:
#

function _roxma_nvim_init()
{
    roxma_nvim_rcfile_generate
	customVimrcFile=$(roxma_nvim_rcfile_name)

	localVimDir=".local_software/neovim"

	cd $(dirname ${BASH_SOURCE[0]})

	if [[ -d $(pwd)/${localVimDir} ]]; then

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

	fi

	# export path if neovim installed
	if [[ -f $(dirname ${BASH_SOURCE[0]})/.local_software/neovim/bin/nvim ]]
	then
		# echo 'export PATH="'$(readlink -f $(dirname ${BASH_SOURCE[0]}))'/.local_software/neovim/bin":$PATH' 1>&3
		echo 'unalias nvim 2>/dev/null' 1>&3
		unalias nvim 2>/dev/null
		alias nvim="$(readlink -f $(dirname ${BASH_SOURCE[0]}))/.local_software/neovim/bin/nvim -u \"$(roxma_nvim_rcfile_name)\""
		alias nvim 1>&3
		alias nvim
	fi

}

function roxma_install_neovim() {
	pip list | grep neovim
	local ret1=$?
	pip3 list | grep neovim
	local ret2=$?
	if [[ $ret1 != 0 ]]  && [[ $ret2 != 0 ]]
	then
		echo "'pip3 install neovim' should be done before installing neovim"
		echo "If you don't have python33, you may need this gist to install python33: https://gist.github.com/roxma/c4de9e894ef35fe1d1777c946d9094da"
		echo "do you want to continue? (yes/no)"
		local yes
		read yes
		if [[ "$yes" != "yes" ]] && [[ "$yes" != "YES" ]]
		then
			return
		fi
	fi
    # make a subprocess
    {
        cd "$(dirname ${BASH_SOURCE[0]})"/.local_software && mkdir -p tmp && cd tmp 
        if [[ $? != 0 ]]
        then
            echo "make tmp dir failed"
            return 1
        fi
        if [[ ! -d neovim ]]
        then
            git clone https://github.com/neovim/neovim
        fi
        if [[ $? != 0 ]]
        then
            echo "install failed."
            return 1
        fi
        prefix=$(readlink -f ../neovim)
        rm -rf neovim/build
        cd neovim && make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX:PATH=${prefix}" CMAKE_BUILD_TYPE=Release &&  make install
        # make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX:PATH=$HOME/neovim"
    } | tee
}

# setup 256 color for vim
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi

eval "$((_roxma_nvim_init) 3>&1 1>&2 )"

