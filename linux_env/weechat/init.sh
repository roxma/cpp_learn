
cd $(dirname ${BASH_SOURCE[0]})

function roxma_weechat_conf() {
    cd $(dirname ${BASH_SOURCE[0]})
    # Generate tmux.conf
    mkdir -p .local_software/weechat_data
    cd .local_software/weechat_data
    roxma_weechat_scripts_tgz > roxma_scripts.tar.gz
    tar -zxf roxma_scripts.tar.gz
}


if [ -d .local_software -a -n "$(which weechat 2>/dev/null)" ]
then
    (roxma_weechat_conf)
    unalias weechat 2>/dev/null
    alias weechat="$(which weechat) -d $(readlink -f $(dirname ${BASH_SOURCE[0]})/.local_software/weechat_data)"
    alias weechat
fi


