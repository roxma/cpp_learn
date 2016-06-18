
function _roxma_tmux_init() {

	cd $(dirname ${BASH_SOURCE[0]})

	if [ -d .local_software ]
	then

		# Generate tmux.conf
		mkdir -p .local_software/tmux/etc
		roxma_tmux_conf_generate > ".local_software/tmux/etc/tmux.conf"

		# tmux-powerline this project is not not maintained anymore
		# if [ ! -d .local_software/tmux-powerline ]
		# then
		#     echo "roxma_install_tmux_powerline ### use this command to install https://github.com/erikw/tmux-powerline"
		# else
		#     roxma_install_tmux_powerline_conf
		# fi

		echo 'unalias tmux 2>/dev/null' 1>&3
		alias tmux='tmux -f '"$(readlink -f .local_software/tmux/etc/tmux.conf)"
		alias tmux 1>&3
		alias tmux

	fi
}

eval "$((_roxma_tmux_init) 3>&1 1>&2 )"

