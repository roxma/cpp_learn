

cd $(dirname ${BASH_SOURCE[0]})

function roxma_install_tmux_powerline_conf() {
    (
        c="$(roxma_tmux_powerline_conf_generate)"
        cd $(dirname ${BASH_SOURCE[0]}) && echo "${c//__tmux_powerline_path/$(readlink -f .local_software/tmux-powerline)}" >> ".local_software/tmux/etc/tmux.conf"
    )
}

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

    echo alias tmux='tmux -f '"$(readlink -f .local_software/tmux/etc/tmux.conf)"
    alias tmux='tmux -f '"$(readlink -f .local_software/tmux/etc/tmux.conf)"

fi

function _do_roxma_install_tmux_powerline() {

    cd $(dirname ${BASH_SOURCE[0]})

    if [ ! -d $(dirname ${BASH_SOURCE[0]})/.local_software ]
    then
        echo "Error: .local_software not exist!"
        exit 2
    fi

    (cd .local_software && git clone 'https://github.com/erikw/tmux-powerline.git') &&  roxma_install_tmux_powerline_conf
}

function roxma_install_tmux_powerline() {
    ( _do_roxma_install_tmux_powerline )
}

cd -

