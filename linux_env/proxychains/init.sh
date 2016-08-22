
function _roxma_proxychains_init() {

	cd $(dirname ${BASH_SOURCE[0]})

	if [ -d .local_software/proxychains/bin ]
	then
		echo 'export PATH='$(pwd)/.local_software/proxychains/bin':$PATH'
		echo 'export PATH='$(pwd)/.local_software/proxychains/bin':$PATH' 1>&3
	fi
}

# tmux installation script: https://gist.github.com/roxma/1f8a3c51314d439a5cd816c811673467

eval "$((_roxma_tmux_init) 3>&1 1>&2 )"


function roxma_install_proxychains() {
	if [ -d $(dirname ${BASH_SOURCE[0]})/.local_software/proxychains/bin/ ]
	then
		echo "You've already installed proxychains!"
		return 0
	fi
	{
		cd "$(dirname ${BASH_SOURCE[0]})"/.local_software && mkdir -p tmp && cd tmp  && rm -rf proxychains-ng && git clone git@github.com:rofl0r/proxychains-ng.git
		cd proxychains-ng  && ./configure --prefix="$(dirname ${BASH_SOURCE[0]})/.local_software/proxychains/" &&  make && make install && make install-config
	} | tee
}

eval "$((_roxma_proxychains_init) 3>&1 1>&2 )"

