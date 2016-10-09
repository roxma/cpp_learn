
function _roxma_ctags_init() {

	cd $(dirname ${BASH_SOURCE[0]})

	if [ -d .local_software/ctags/bin ]
	then
		echo 'export PATH='$(pwd)/.local_software/ctags/bin':$PATH'
		echo 'export PATH='$(pwd)/.local_software/ctags/bin':$PATH' 1>&3
	fi
}

# tmux installation script: https://gist.github.com/roxma/1f8a3c51314d439a5cd816c811673467

function roxma_install_ctags() {
	if [ -d $(dirname ${BASH_SOURCE[0]})/.local_software/ctags/bin/ ]
	then
		echo "You've already installed proxychains!"
		return 0
	fi
	{
		cd "$(dirname ${BASH_SOURCE[0]})"/.local_software && mkdir -p tmp && cd tmp  && rm -rf ctags && git clone git@github.com:universal-ctags/ctags.git
		cd ctags  && ./autogen.sh && ./configure --prefix="$(dirname ${BASH_SOURCE[0]})/.local_software/ctags/" &&  make && make install
	} | tee
}

eval "$((_roxma_ctags_init) 3>&1 1>&2 )"

