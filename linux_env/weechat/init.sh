
function _roxma_weechat_init()
{
	cd $(dirname ${BASH_SOURCE[0]})

	if [ -d .local_software -a -n "$(which weechat 2>/dev/null)" ]
	then
		# Generate tmux.conf
		mkdir -p .local_software/weechat_data
		cd .local_software/weechat_data
		roxma_weechat_scripts_tgz > roxma_scripts.tar.gz
		tar -zxf roxma_scripts.tar.gz
		echo 'unalias weechat 2>/dev/null' 1>&3
		unalias weechat 2>/dev/null
		alias weechat="$(which weechat) -d $(readlink -f $(dirname ${BASH_SOURCE[0]})/.local_software/weechat_data)"
		alias weechat 1>&3
		alias weechat
	fi
}

eval "$((_roxma_weechat_init) 3>&1 1>&2 )"

