
function _roxma_proxychains_init() {

	cd $(dirname ${BASH_SOURCE[0]})

	if [ -d .local_software/proxychains/bin ]
	then
		echo 'export PATH='$(pwd)/.local_software/proxychains/bin':$PATH'
		echo 'export PATH='$(pwd)/.local_software/proxychains/bin':$PATH' 1>&3
	fi
}

# tmux installation script: https://gist.github.com/roxma/1f8a3c51314d439a5cd816c811673467

eval "$((_roxma_proxychains_init) 3>&1 1>&2 )"


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

# used togethre with shadowsocks:
# pip3 install shadowsocks
# /bin/ssserver -p port -k password -m rc4-md5 --user nobody -d start
# sslocal -c /etc/shadowsocks.json -d start
#
# /etc/shadowsocks.json file:
# {
#         "server"        : "server",
#         "server_port"   : port,
#         "local_address" : "127.0.0.1",
#         "local_port"    : 1080,
#         "password"      : "password",
#         "timeout"       : 1000,
#         "method"        : "rc4-md5"
# }
